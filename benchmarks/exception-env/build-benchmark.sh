#!/usr/bin/env bash
set -euo pipefail

validation_dir="$(cd "$(dirname "$0")" && pwd)"
patched_root="${FBJNI_AFTER:?Set FBJNI_AFTER to the patched fbjni checkout}"
baseline_root="${FBJNI_BEFORE:?Set FBJNI_BEFORE to the upstream fbjni checkout}"
sdk_root="${ANDROID_HOME:?Set ANDROID_HOME to the Android SDK}"
ndk_root="$sdk_root/ndk/27.1.12297006"
jdk_root="${JAVA_HOME:?Set JAVA_HOME to a JDK 17 installation}"
compiler="$ndk_root/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android24-clang++"

for version in before after; do
  source_root="$patched_root"
  defines=(-UUSE_EXPLICIT_ENV)
  if [[ "$version" == before ]]; then
    source_root="$baseline_root"
  else
    defines=(-DUSE_EXPLICIT_ENV)
  fi
  "$sdk_root/cmake/3.22.1/bin/cmake" -S "$source_root" \
    -B "$validation_dir/android-$version" \
    -DCMAKE_TOOLCHAIN_FILE="$ndk_root/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-24 \
    -DANDROID_STL=c++_shared -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  "$sdk_root/cmake/3.22.1/bin/cmake" \
    --build "$validation_dir/android-$version" --parallel 6
  "$compiler" -std=c++20 -O3 -DNDEBUG -Wall -Wextra -Wpedantic \
    -fPIC -shared -fno-omit-frame-pointer -fexceptions -frtti \
    "${defines[@]}" -I "$source_root/cxx" \
    "$validation_dir/EnvBenchmark.cpp" \
    -L "$validation_dir/android-$version" -lfbjni -ldl \
    -Wl,--no-undefined -Wl,-rpath,'$ORIGIN' \
    -o "$validation_dir/android-$version/libenv-bench.so"
  cp "$ndk_root/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so" \
    "$validation_dir/android-$version/"
done

native_loader="${FBJNI_NATIVE_LOADER:?Set FBJNI_NATIVE_LOADER to nativeloader-0.10.5.jar}"
jsr305="${FBJNI_JSR305:?Set FBJNI_JSR305 to jsr305-3.0.2.jar}"
infer="${FBJNI_INFER:?Set FBJNI_INFER to infer-annotation-0.18.0.jar}"
mkdir -p "$validation_dir/classes" "$validation_dir/dex"
"$jdk_root/bin/javac" -cp "$native_loader" -d "$validation_dir/classes" "$validation_dir/EnvBenchmark.java"
"$jdk_root/bin/jar" --create --file "$validation_dir/driver.jar" -C "$validation_dir/classes" .
"$jdk_root/bin/jar" --create --file "$validation_dir/fbjni-classes.jar" -C "$patched_root/fbjni-java-only/build/classes/java/main" .
JAVA_HOME="$jdk_root" "$sdk_root/build-tools/36.0.0/d8" --release --min-api 24 \
  --lib "$sdk_root/platforms/android-34/android.jar" \
  --output "$validation_dir/dex" "$validation_dir/driver.jar" \
  "$validation_dir/fbjni-classes.jar" "$native_loader" "$jsr305" "$infer"
