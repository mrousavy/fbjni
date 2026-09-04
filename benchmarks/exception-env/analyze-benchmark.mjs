import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
const root = dirname(fileURLToPath(import.meta.url));
const runs = JSON.parse(readFileSync(join(root, 'results/runs.json')));
if (runs.length !== 32) throw new Error('Incomplete experiment');
const mean = xs => xs.reduce((sum, x) => sum + x, 0) / xs.length;
const geometric = xs => Math.exp(mean(xs.map(Math.log)));
const median = xs => {
  const sorted = xs.toSorted((a, b) => a - b);
  return (sorted[(sorted.length - 1) >> 1] + sorted[sorted.length >> 1]) / 2;
};
const ci = xs => {
  const average = mean(xs);
  const variance = xs.reduce((sum, x) => sum + (x - average) ** 2, 0) / (xs.length - 1);
  const margin = 2.364624251 * Math.sqrt(variance / xs.length); // t(7), two-sided 95%
  return [average - margin, average + margin];
};
const summary = [];
for (const scenario of [0, 1]) {
  const processes = runs.map(run => ({
    block: run.block, version: run.version, label: run.label,
    medianNs: median(run.samples.filter(s => s.scenario === scenario).map(s => s.nanos / s.iterations)),
  }));
  const blocks = Array.from({ length: 8 }, (_, block) => {
    const before = geometric(processes.filter(p => p.block === block && p.version === 'before').map(p => p.medianNs));
    const after = geometric(processes.filter(p => p.block === block && p.version === 'after').map(p => p.medianNs));
    return { block, before, after, difference: before - after, ratio: before / after };
  });
  const ratio = geometric(blocks.map(b => b.ratio));
  const ratioCI = ci(blocks.map(b => Math.log(b.ratio))).map(Math.exp);
  summary.push({
    scenario,
    case: scenario === 0 ? 'Exception helper only, existing cached environment' : 'JMethod<double(double,double)> to stateful Java instance',
    beforeGeometricMedianNs: geometric(blocks.map(b => b.before)),
    afterGeometricMedianNs: geometric(blocks.map(b => b.after)),
    beforeOverAfterRatio: ratio,
    ratio95CI: ratioCI,
    latencyReductionPercent: 100 * (1 - 1 / ratio),
    latencyReduction95CI: ratioCI.map(r => 100 * (1 - 1 / r)),
    meanPairedNsSaved: mean(blocks.map(b => b.difference)),
    nsSaved95CI: ci(blocks.map(b => b.difference)),
    blocks,
    processes,
  });
}
writeFileSync(join(root, 'results/summary.json'), JSON.stringify(summary, null, 2) + '\n');
for (const { blocks, processes, ...s } of summary) console.log(JSON.stringify(s, null, 2));
