#!/usr/bin/env python3
"""Build one benchmark variant. Both variants use Probe.cpp and Probe.java."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import time

root = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument("repo", type=Path)
parser.add_argument("variant", choices=["before", "after"])
parser.add_argument("revision", help="fbjni commit, or WORKTREE for local testing")
parser.add_argument("--pause-for-lock", type=Path)
args = parser.parse_args()
repo = args.repo.resolve()
variant = root / "build" / args.variant
source = variant / "src"

def run(*cmd, **kwargs):
    return subprocess.run(list(map(str, cmd)), check=True, **kwargs)

def output(*cmd):
    return run(*cmd, stdout=subprocess.PIPE, text=True).stdout.strip()

def wait_for_build():
    while args.pause_for_lock and args.pause_for_lock.exists():
        time.sleep(2)

ref = "HEAD" if args.revision == "WORKTREE" else args.revision
revision = output("git", "-C", repo, "rev-parse", "--verify", ref + "^{commit}")
# git archive preserves commit mtimes. Fresh objects keep an older revision
# from accidentally reusing a newer variant's compiled probe or fbjni library.
if variant.exists():
    shutil.rmtree(variant)
source.mkdir(parents=True)
if args.revision == "WORKTREE":
    shutil.copytree(repo / "cxx", source / "cxx", dirs_exist_ok=True)
    shutil.copy2(repo / "CMakeLists.txt", source)
else:
    archive = variant / "fbjni.tar"
    run("git", "-C", repo, "archive", "-o", archive, revision, "CMakeLists.txt", "cxx")
    run("tar", "-xf", archive, "-C", source)
    archive.unlink()

sdk = Path(os.environ.get("ANDROID_HOME", Path.home() / "Library/Android/sdk"))
ndk = Path(os.environ.get("ANDROID_NDK_HOME", sdk / "ndk/29.0.14206865"))
cmake = os.environ.get("CMAKE", str(sdk / "cmake/3.22.1/bin/cmake"))
java = Path(os.environ["JAVA_HOME"]) / "bin" if "JAVA_HOME" in os.environ else Path(shutil.which("javac")).parent
ninja = shutil.which("ninja")
abi = os.environ.get("ANDROID_ABI", "arm64-v8a")
build_tools = os.environ.get("BUILD_TOOLS", "36.0.0")
compile_sdk = os.environ.get("COMPILE_SDK", "36")
dex = variant / "dex"
classes = variant / "classes"
classes.mkdir(exist_ok=True)
dex.mkdir(exist_ok=True)
wait_for_build()
run(java / "javac", "--release", "8", "-d", classes, root / "Probe.java")
run(java / "jar", "cf", variant / "classes.jar", "-C", classes, ".")
run(sdk / "build-tools" / build_tools / "d8", "--release", "--min-api", "28", "--lib",
    sdk / "platforms" / ("android-" + compile_sdk) / "android.jar",
    "--output", dex, variant / "classes.jar")
run(java / "jar", "cf", variant / "probe.jar", "-C", dex, "classes.dex")

native = variant / "native"
wait_for_build()
run(cmake, "-S", root, "-B", native, "-G", "Ninja", "-DCMAKE_MAKE_PROGRAM=" + ninja,
    "-DCMAKE_TOOLCHAIN_FILE=" + str(ndk / "build/cmake/android.toolchain.cmake"),
    "-DANDROID_ABI=" + abi, "-DANDROID_PLATFORM=android-28", "-DANDROID_STL=c++_shared",
    "-DCMAKE_BUILD_TYPE=Release", "-DFBJNI_ROOT=" + str(source))
wait_for_build()
run(cmake, "--build", native, "--parallel", "4", "--target", "call-bench")
platform = next((ndk / "toolchains/llvm/prebuilt").iterdir())
triples = {"arm64-v8a": "aarch64-linux-android", "armeabi-v7a": "arm-linux-androideabi",
           "x86": "i686-linux-android", "x86_64": "x86_64-linux-android"}
shutil.copy2(platform / "sysroot/usr/lib" / triples[abi] / "libc++_shared.so", variant)
shutil.copy2(native / "fbjni/libfbjni.so", variant)
shutil.copy2(native / "libcall-bench.so", variant)

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

metadata = {
    "commit": revision,
    "harness_sha256": {name: digest(root / name) for name in
                       ["CMakeLists.txt", "Probe.cpp", "Probe.java"]},
    "worktree_snapshot": args.revision == "WORKTREE",
    "abi": abi, "android_min_api": 28, "android_compile_sdk": compile_sdk,
    "android_build_tools": build_tools,
    "ndk": next(line.split("=", 1)[1].strip() for line in (ndk / "source.properties")
                .read_text().splitlines() if line.startswith("Pkg.Revision")),
    "clang": output(platform / "bin/clang", "--version").splitlines()[0],
    "cmake": output(cmake, "--version").splitlines()[0],
    "javac": output(java / "javac", "-version"),
    "configuration": "Release -O3 -DNDEBUG",
    "sha256": {name: digest(variant / name) for name in
               ["libcall-bench.so", "libfbjni.so", "libc++_shared.so", "dex/classes.dex", "probe.jar"]},
    "fbjni_sources_sha256": hashlib.sha256("".join(
        str(p.relative_to(source)) + " " + digest(p) + "\n"
        for p in sorted(source.rglob("*")) if p.is_file()).encode()).hexdigest()
}
(variant / "build.json").write_text(json.dumps(metadata, indent=2) + "\n")
