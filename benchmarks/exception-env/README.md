# Existing JNIEnv exception-check benchmark

This branch retains the benchmark evidence separately from the small fbjni PR.
The timed C++ and Java drivers are unchanged from the measured run. The build
script has been parameterized for reuse; the collection script now accepts an
ADB path and remote directory.

## Results

Android 14 ARM64 emulator on Apple M2 Pro, NDK 27.1.12297006, C++20, `-O3`,
shared libc++. Baseline is `f2f5cf19817a0b3664c9c5320d3b798c458542c3`;
patched source is `45a82454e1440bceb3d88a8c33d210b1bebb45fc`.

| Case | Before, ns/call | After, ns/call | Time reduction, 95% CI |
| --- | ---: | ---: | ---: |
| Exception helper alone | 7.35 | 1.88 | 74.4% [71.0%, 77.5%] |
| fbjni virtual call to a stateful Java `add` method | 33.07 | 28.48 | 13.9% [5.9%, 21.1%] |

The full-call estimate saves 4.66 ns/call on average across paired blocks
(95% CI: 1.84 to 7.49 ns). That estimate and the difference between the two
displayed geometric means use different aggregations, so they need not match.

These are emulator microbenchmarks, not physical Android device, Kotlin,
Nitro, or JSI measurements. The intervals describe variation within this run,
not expected gains across devices. The full call still includes virtual JNI
dispatch and variadic argument passing. Only environment reuse changed.

## Method

The [plan](PLAN.md) was written before collecting the full measurement run.
There are 32 fresh ART processes in eight ABBA/BAAB blocks, with 16 processes
per version. Each process warms both cases for five batches, then records
12 batches per case, alternating case order. Each batch has 1,000,000 calls.
Both versions enter through fbjni's registered native wrapper, so the
environment is already cached in fbjni TLS. Both call the same Java method.
The method takes changing inputs and its exact accumulated result is checked
after the timer stops. Method lookup is outside the timed region. No empty
loop subtraction or slow-sample exclusion is used.

Each process contributes its median ns/call per case. The two process medians
for each version in a block are combined geometrically. The reported ratio
is the geometric mean of the eight paired before/after ratios. The 95%
interval uses Student's t on those eight log-ratios, with seven degrees of
freedom. Absolute savings use the mean paired block difference.

[runs.json](results/runs.json) contains every raw timed sample.
[summary.json](results/summary.json) includes every process median and paired
block. [environment.json](results/environment.json) records the environment,
an actual library compiler command, and SHA-256 hashes of the timed artifacts.
Both library builds had identical compiler commands after normalizing paths.
The normal release JNI settings were used; CheckJNI was not requested and
neither `debug.checkjni` nor `dalvik.vm.checkjni` was set. There was no profiler,
sanitizer, or LTO instrumentation in the timed builds.

## Why it changes

The [original helper assembly](helper-before.asm) calls
`Environment::current()` before `ExceptionCheck()`. The [patched helper
assembly](helper-after.asm) uses its supplied `JNIEnv*` directly. It still
checks for exceptions and retains the same translation path. The original
no-argument symbol is also present in the patched library.

The full-call loop still calls `Environment::current()` once before the JNI
method call. It then preserves that pointer in a register and passes it to
the new exception helper. Previously the exception helper looked it up a
second time. This is not an inline-exception-check or JNI `A`-form experiment.

## Reproduce

To recompute the published estimates, use Node 24:

```sh
node analyze-benchmark.mjs
```

For a new Android run on macOS, copy these scripts into a fresh directory
without `results/`, and use separate baseline and patched fbjni checkouts at
the commits above. Install JDK 17, NDK 27.1.12297006, Android CMake 3.22.1,
build-tools 36.0.0 and platform android-34. Set `JAVA_HOME`, `ANDROID_HOME`,
`FBJNI_BEFORE` and `FBJNI_AFTER` to their paths. Build the Java classes:

```sh
cd "$FBJNI_AFTER"
./gradlew :fbjni-java-only:classes
```

Set `FBJNI_NATIVE_LOADER`, `FBJNI_JSR305` and `FBJNI_INFER` to the dependency
jars in Gradle's cache: nativeloader 0.10.5, jsr305 3.0.2 and infer-annotation
0.18.0. In the fresh benchmark directory, run:

```sh
bash build-benchmark.sh
```

Boot an ARM64 Android 14 emulator and set `ANDROID_SERIAL`. Set `ADB` to the
Android SDK's adb executable. Deploy into a new, unused directory under
`/data/local/tmp`:

```sh
export FBJNI_REMOTE=/data/local/tmp/fbjni-env-check-reproduction
"$ADB" -s "$ANDROID_SERIAL" shell \
  "test ! -e $FBJNI_REMOTE && mkdir -p $FBJNI_REMOTE/before $FBJNI_REMOTE/after"
"$ADB" -s "$ANDROID_SERIAL" push dex/classes.dex "$FBJNI_REMOTE/classes.dex"
for version in before after; do
  "$ADB" -s "$ANDROID_SERIAL" push \
    "android-$version/libfbjni.so" \
    "android-$version/libenv-bench.so" \
    "android-$version/libc++_shared.so" "$FBJNI_REMOTE/$version/"
done
"$ADB" -s "$ANDROID_SERIAL" shell "chmod 444 $FBJNI_REMOTE/classes.dex"
node run-benchmark.mjs
node analyze-benchmark.mjs
```

No app installation is needed. The collector uses `app_process`, loads only
one version per process, and refuses to overwrite an existing results folder.
Keep host activity low during collection. Hardware and runtime differences
will change the numbers; do not treat these measurements as universal.

## Correctness checks for the patch

`./gradlew assembleDebug` passed for arm64-v8a, armeabi-v7a, x86 and x86_64.
The host Java/JNI suite passed: 169 passed, two skipped. It also passed when
the native libraries were built with AddressSanitizer and UndefinedBehaviorSanitizer.
Four new tests cover both overloads with and without a pending exception,
including original throwable identity and clearing the pending exception.

The standalone host C++ suite had six passing tests and one failure:
`Utf16toUTF8_test.negativeUtf16StringLength`. The same test failed against the
unmodified upstream library with the same host compiler. UBSan reports pointer
overflow in the existing `utf8.cpp:222` negative-length path. That unrelated
failure was not fixed as part of this PR.
