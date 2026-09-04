#include <fbjni/fbjni.h>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <dlfcn.h>
#include <stdexcept>

using namespace facebook::jni;
using Clock = std::chrono::steady_clock;

static double sumMasked(int count, int mask) {
  const int width = mask + 1;
  const int remainder = count % width;
  return double(count / width) * width * mask / 2 +
      double(remainder) * (remainder - 1) / 2;
}

static jlong measure(JNIEnv* env, jobject self, jint scenario, jint iterations) {
  static const bool logged = [env] {
    Dl_info info{};
    dladdr(reinterpret_cast<void*>(env->functions->ExceptionCheck), &info);
    std::printf("ENV,ExceptionCheck,%s,%s\n", info.dli_fname ? info.dli_fname : "unknown", info.dli_sname ? info.dli_sname : "unknown");
    return true;
  }();
  (void)logged;
  if (iterations <= 0) {
    throw std::invalid_argument("iterations must be positive");
  }
  if (env->ExceptionCheck()) {
    throw std::runtime_error("pending exception before measurement");
  }

  if (scenario == 0) {
    const auto start = Clock::now();
    for (int i = 0; i < iterations; ++i) {
#ifdef USE_EXPLICIT_ENV
      throwPendingJniExceptionAsCppException(env);
#else
      throwPendingJniExceptionAsCppException();
#endif
    }
    const auto end = Clock::now();
    return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
  }

  if (scenario == 1) {
    const auto method = wrap_alias(self)->getClass()->getMethod<double(double, double)>("add");
    double checksum = 0;
    const auto start = Clock::now();
    for (int i = 0; i < iterations; ++i) {
      checksum += method(wrap_alias(self), double(i & 1023), double(i & 255));
    }
    const auto end = Clock::now();
    const double expected = sumMasked(iterations, 1023) + sumMasked(iterations, 255) + iterations * 0.5;
    if (checksum != expected || env->ExceptionCheck()) {
      throw std::runtime_error("method checksum/exception validation failed");
    }
    return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
  }
  throw std::invalid_argument("unknown scenario");
}

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void*) {
  return initialize(vm, [] {
    registerNatives("org/fbjni/bench/EnvBenchmark", {makeNativeMethod("measure", measure)});
  });
}
