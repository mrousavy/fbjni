import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(fileURLToPath(import.meta.url));
const adb = process.env.ADB ?? 'adb';
const serial = process.env.ANDROID_SERIAL ?? 'emulator-5554';
const remote = process.env.FBJNI_REMOTE ?? '/data/local/tmp/fbjni-env-check-sbf8z9';
const output = join(root, 'results');
mkdirSync(output); // Do not overwrite an earlier measurement.
function command(executable, args) {
  const result = spawnSync(executable, args, { encoding: 'utf8', maxBuffer: 16 * 1024 * 1024 });
  if (result.status !== 0) throw new Error(`${executable}: ${result.stderr ?? result.error}`);
  return result.stdout + result.stderr;
}
const environment = {
  startedAt: new Date().toISOString(),
  host: command('sw_vers', []),
  hardware: command('sysctl', ['-n', 'machdep.cpu.brand_string']),
  device: command(adb, ['-s', serial, 'shell', 'getprop']),
  deviceCpu: command(adb, ['-s', serial, 'shell', 'cat /proc/cpuinfo']),
  emulator: command(adb, ['-s', serial, 'emu', 'avd', 'name']),
  files: {},
};
for (const file of ['EnvBenchmark.cpp', 'EnvBenchmark.java', 'PLAN.md', 'dex/classes.dex',
  ...['before', 'after'].flatMap(version => ['libfbjni.so', 'libenv-bench.so', 'libc++_shared.so'].map(name => `android-${version}/${name}`))]) {
  environment.files[file] = createHash('sha256').update(readFileSync(join(root, file))).digest('hex');
}
writeFileSync(join(output, 'environment.json'), JSON.stringify(environment, null, 2) + '\n');
const runs = [];
for (let block = 0; block < 8; block++) {
  const order = block % 2 === 0 ? ['before', 'after', 'after', 'before'] : ['after', 'before', 'before', 'after'];
  for (let position = 0; position < order.length; position++) {
    const version = order[position];
    const label = `block-${block}-position-${position}-${version}`;
    const startedAt = new Date().toISOString();
    const log = command(adb, ['-s', serial, 'shell',
      `CLASSPATH=${remote}/classes.dex LD_LIBRARY_PATH=${remote}/${version} app_process -Djava.library.path=${remote}/${version} /data/local/tmp org.fbjni.bench.EnvBenchmark ${label} 1000000 12`]);
    writeFileSync(join(output, `${label}.log`), log);
    const samples = log.split(/\r?\n/).filter(line => line.startsWith('SAMPLE,')).map(line => {
      const [tag, actualLabel, sample, scenario, iterations, nanos] = line.split(',');
      if (actualLabel !== label || Number(iterations) !== 1000000 || !(Number(nanos) > 0)) {
        throw new Error(`Invalid sample: ${line}`);
      }
      return { sample: Number(sample), scenario: Number(scenario), iterations: Number(iterations), nanos: Number(nanos) };
    });
    if (samples.length !== 24 || new Set(samples.map(s => `${s.sample}:${s.scenario}`)).size !== 24 ||
        samples.some(s => ![0, 1].includes(s.scenario) || s.sample < 0 || s.sample >= 12)) {
      throw new Error(`Missing/duplicate samples: ${label}`);
    }
    runs.push({ block, position, version, label, startedAt, samples });
    writeFileSync(join(output, 'runs.json'), JSON.stringify(runs, null, 2) + '\n');
    console.log(`Completed ${runs.length}/32: ${label}`);
  }
}
environment.completedAt = new Date().toISOString();
writeFileSync(join(output, 'environment.json'), JSON.stringify(environment, null, 2) + '\n');
