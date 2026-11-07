#!/usr/bin/env python3
"""Run matched fresh ART processes on one reserved Android device."""
import argparse
import contextlib
import hashlib
import json
import os
import platform
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import time

root = Path(__file__).resolve().parent
p = argparse.ArgumentParser()
p.add_argument("--serial", default="emulator-5554")
p.add_argument("--lock", type=Path, required=True, help="Shared device reservation directory")
p.add_argument("--active-marker", type=Path, help="Create this file while holding the reservation")
p.add_argument("--output", type=Path, required=True)
p.add_argument("--pairs", type=int, default=8)
p.add_argument("--rounds", type=int, default=5)
p.add_argument("--iterations", type=int, default=262144)
p.add_argument("--seed", type=int, default=20261107)
p.add_argument("--smoke-only", action="store_true")
a = p.parse_args()
if a.pairs < 2 or a.pairs % 2 or a.rounds < 1 or a.iterations < 16:
    p.error("use an even number of pairs, positive rounds, and at least 16 iterations")
a.output.mkdir(parents=True, exist_ok=False)
adb = shutil.which("adb") or str(Path(os.environ["ANDROID_HOME"]) / "platform-tools/adb")
if not Path(adb).is_file():
    p.error("set ANDROID_HOME or put adb on PATH")

@contextlib.contextmanager
def device_lock():
    print("Waiting for shared device reservation", flush=True)
    while True:
        try:
            a.lock.mkdir()
            break
        except FileExistsError:
            time.sleep(2)
    mine = a.lock.stat()
    marker_created = False
    print("Acquired shared device reservation", flush=True)
    try:
        if a.active_marker:
            a.active_marker.touch(exist_ok=False)
            marker_created = True
            time.sleep(3)
        yield
    finally:
        if marker_created:
            a.active_marker.unlink()
        if a.lock.exists() and os.path.samestat(mine, a.lock.stat()):
            a.lock.rmdir()
            print("Released shared device reservation", flush=True)

def device(*cmd, **kwargs):
    return subprocess.run([adb, "-s", a.serial, *map(str, cmd)], check=True, **kwargs)

def shell_output(*cmd):
    return device("shell", *cmd, capture_output=True, text=True).stdout.strip()

def write_json(path, obj):
    path.write_text(json.dumps(obj, indent=2) + "\n")

config = {"pairs": a.pairs, "rounds_per_process": a.rounds,
          "iterations": a.iterations, "seed": a.seed, "warmup_rounds": 3}
if platform.system() == "Darwin":
    cpu = subprocess.check_output(["sysctl", "-n", "machdep.cpu.brand_string"], text=True).strip()
else:
    cpu = platform.processor()
write_json(a.output / "host.json", {"system": platform.system(), "release": platform.release(),
                                   "architecture": platform.machine(), "cpu": cpu})
write_json(a.output / "config.json", config)
deployed_files = ["libcall-bench.so", "libfbjni.so", "libc++_shared.so", "probe.jar"]
variants = {}
for variant in ["before", "after"]:
    directory = root / "build" / variant
    metadata = json.loads((directory / "build.json").read_text())
    if not all(name in metadata["sha256"] for name in deployed_files):
        raise RuntimeError(f"rebuild {variant}: manifest missing a deployed binary hash")
    # Check what will actually run. Editing Probe.cpp or replacing a binary
    # after build.py finished makes its recorded hash stale.
    for base, hashes in ((root, metadata["harness_sha256"]), (directory, metadata["sha256"])):
        for name, expected in hashes.items():
            if hashlib.sha256((base / name).read_bytes()).hexdigest() != expected:
                raise RuntimeError(f"{variant}: {name} differs from build.json; rebuild this variant")
    write_json(a.output / (variant + "-build.json"), metadata)
    variants[variant] = metadata
before, after = variants["before"], variants["after"]
for field in ("harness_sha256", "abi", "android_min_api", "android_compile_sdk", "android_build_tools",
              "ndk", "clang", "cmake", "javac", "configuration"):
    if before[field] != after[field]:
        raise RuntimeError("builds differ in " + field)
if before["sha256"]["dex/classes.dex"] != after["sha256"]["dex/classes.dex"]:
    raise RuntimeError("expected identical dex for both variants")

with device_lock():
    if device("get-state", capture_output=True, text=True).stdout.strip() != "device":
        raise RuntimeError("device unavailable")
    properties = ["ro.product.model", "ro.product.cpu.abi", "ro.build.version.sdk", "ro.build.version.release",
                  "ro.build.fingerprint", "ro.kernel.qemu", "dalvik.vm.usejit",
                  "dalvik.vm.checkjni", "debug.checkjni"]
    write_json(a.output / "device.json", {prop: shell_output("getprop", prop) for prop in properties})
    remote = shell_output("mktemp", "-d", "/data/local/tmp/fbjni-call-bench.XXXXXXXX")
    if not re.fullmatch(r"/data/local/tmp/fbjni-call-bench\.[A-Za-z0-9]+", remote):
        raise RuntimeError("unexpected mktemp result: " + repr(remote))
    try:
        for variant in ["before", "after"]:
            local = root / "build" / variant
            dest = remote + "/" + variant
            device("shell", "mkdir", dest)
            device("push", *[local / name for name in deployed_files], dest + "/",
                   stdout=subprocess.DEVNULL)
            device("shell", "chmod", "444", dest + "/probe.jar")
        results = []
        def process(variant, pair, position, smoke=False):
            directory = remote + "/" + variant
            flags = ["-Xcheck:jni"] if smoke else []
            command = ["env", "CLASSPATH=" + directory + "/probe.jar",
                       "LD_LIBRARY_PATH=" + directory, "app_process", *flags,
                       "-Djava.library.path=" + directory, "/system/bin", "bench.Probe",
                       str(a.seed + pair), str(1 if smoke else a.rounds),
                       str(1024 if smoke else a.iterations)]
            started = time.time()
            result = subprocess.run([adb, "-s", a.serial, "shell", shlex.join(command)],
                                    capture_output=True, text=True)
            key = f"smoke-{variant}" if smoke else f"pair-{pair:02}-{position}-{variant}"
            (a.output / (key + ".stderr")).write_text(result.stderr)
            (a.output / (key + ".stdout")).write_text(result.stdout)
            result.check_returncode()
            if smoke and any(w in (result.stderr + result.stdout).upper() for w in
                             ["JNI WARNING", "JNI DETECTED ERROR"]):
                raise RuntimeError("CheckJNI diagnostic in " + key)
            samples = [json.loads(x) for x in result.stdout.splitlines() if x.startswith("{")]
            if len(samples) != 9 * (1 if smoke else a.rounds):
                raise RuntimeError("incomplete process: " + key)
            if not smoke:
                results.append({"pair": pair, "position": position, "variant": variant,
                                "seed": a.seed + pair, "unix_start_s": started, "samples": samples})
                write_json(a.output / "runs.json", results)
            print(key + " passed", flush=True)
        for variant in ["before", "after"]:
            process(variant, 0, 0, smoke=True)
        if not a.smoke_only:
            for pair in range(a.pairs):
                order = ["after", "before"] if pair % 2 else ["before", "after"]
                for position, variant in enumerate(order):
                    process(variant, pair, position)
    finally:
        device("shell", "rm", "-rf", remote)
