# Android JNI method-call benchmark

Compare two fbjni revisions on the same Android device. Both builds use the same C++ probe and Java bytecode. The probe measures virtual, static and nonvirtual calls, object construction and conversion from `std::string` to a Java string. A control calls the four-integer method through handwritten `CallIntMethodA` in both builds. Method lookup happens before timing. Each timed loop includes the wrapper's argument conversion, exception check and local-reference cleanup.

## Run

Use Python 3.9 or newer, Git, JDK 17, Ninja and the Android SDK. The defaults use NDK `29.0.14206865`, CMake `3.22.1`, SDK platform 36 and build tools `36.0.0`. Set `ANDROID_HOME` and `JAVA_HOME`, and put `ninja` and `adb` on `PATH`. The device or emulator must run Android API 28 or newer. Set `ANDROID_ABI` to match it (default `arm64-v8a`).

Run these commands from `benchmarks/method-calls`. Replace the revisions with any two commits in the checkout that support the probe. The example compares variadic calls with the first `jvalue` implementation.

```sh
python3 build.py ../.. before 0e750eeed7eb05e71c22c4c099acfeae8ddc5728
python3 build.py ../.. after b5fd11f530c66153112767e2cb10e3fc7ef5d012
python3 run.py --serial emulator-5554 --lock /tmp/fbjni-method-calls.lock --output build/run-1
python3 analyze.py build/run-1
```

Choose a new output directory for each run. Use the same `--lock` path for benchmarks that share a device. The runner starts a short `-Xcheck:jni` process for each build before timing. Timed processes inherit the device's ART settings. See `device.json` in the run directory for the build fingerprint, ABI and CheckJNI properties.

## Read the results

By default, the runner starts eight pairs of fresh ART processes, alternating which revision runs first. Both processes in a pair use the same seed to shuffle the cases. After three warmup rounds, each process records five rounds of 262,144 calls per case. Construction and string conversion use 65,536 calls per round.

The analyzer prints a Markdown table and writes `summary.json` to the run directory. The before and after columns show the median of the per-process medians in nanoseconds per call. The percentage column shows the median reduction across matched pairs. A positive value means the candidate took less time. The 95% interval resamples process pairs within each run order. `runs.json` contains the individual measurements. The build manifests record the tested commits, toolchains and binary hashes.
