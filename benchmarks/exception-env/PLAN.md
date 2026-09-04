# Environment-overload benchmark plan

Compare fbjni upstream f2f5cf19817a0b3664c9c5320d3b798c458542c3 with the
environment-overload patch. Both libraries and the same benchmark driver are
compiled with Android NDK 27.1.12297006 for arm64, API 24, C++20 and -O3.
Run on Android 14/API 34 ARM64 AVD hosted on Apple M2 Pro. No CheckJNI,
profiling, sanitizer instrumentation, or LTO during timing. Record runtime
properties and inspect the emitted calls before collecting results.

Each fresh ART process loads only one version of fbjni and its matching
benchmark library. Both use fbjni's normal registered JNI entry wrapper, so
the current JNIEnv is already in fbjni's TLS cache. Neither case throws.

Cases:
0. Repeated exception helper with an existing environment: old no-argument
   function versus new explicit-env overload.
1. Actual JMethod<double(double,double)> calls to the same stateful Java
   instance's add method. Lookup is outside the timer. Virtual dispatch,
   argument conversion, variadic JNI call and checksum work are unchanged.
   Only the exception helper used by the actual fbjni headers differs.

Use 1,000,000 calls per timed batch, five warmup batches per case, then 12
samples per case. Alternate case order within each process. Record all raw
elapsed times. Validate the exact changing-input checksum outside timing.
Do not subtract a baseline loop or discard slow samples.

Use eight ABBA blocks, alternating ABBA/BAAB between blocks: 32 fresh
processes total, 16 per version. Reduce each process/case to its median, then
combine the two process medians per version in each block geometrically.
Report the geometric before/after ratio and a 95% Student-t interval across
the eight paired block log-ratios, plus mean paired block differences in
ns/call. Do not claim a gain if the interval includes parity.

These are ART/JNI microbenchmarks, not Nitro/JSI app benchmarks or physical
Android device measurements. Helper-only percentages must not be described
as whole-call or whole-app improvements.
