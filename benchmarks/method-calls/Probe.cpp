#include <fbjni/fbjni.h>

#include <chrono>
#include <cstdint>
#include <stdexcept>
#include <string>

using namespace facebook::jni;

namespace {

using Clock = std::chrono::steady_clock;
using Object = alias_ref<jobject>;

// Each iteration varies one argument over 0..255.
int64_t sumIndices(int n) {
  int64_t remainder = n % 256;
  return int64_t(n / 256) * 255 * 128 + remainder * (remainder - 1) / 2;
}

template <class F>
jlong measure(int n, int64_t expected, F&& invoke) {
  int64_t checksum = 0;
  const auto start = Clock::now();
  for (int i = 0; i < n; ++i) {
    checksum += invoke(i & 255);
  }
  const auto stop = Clock::now();
  if (checksum != expected) {
    throw std::runtime_error("checksum " + std::to_string(checksum) +
        ", expected " + std::to_string(expected));
  }
  return std::chrono::duration_cast<std::chrono::nanoseconds>(stop - start).count();
}

jlong sample(alias_ref<jclass> cls, Object target, int which, int n) {
  const int64_t count = n;
  switch (which) {
    case 0: {
      static const auto method = cls->getMethod<jint()>("zero");
      return measure(n, count * 41, [&](int) { return method(target); });
    }
    case 1: {
      static const auto method =
          cls->getMethod<jint(jint, jint, jint, jint)>("four");
      return measure(n, sumIndices(n) + count * 6, [&](int i) {
        return method(target, i, 1, 2, 3);
      });
    }
    case 2: {
      static const auto method = cls->getStaticMethod<jlong(
          jboolean, jbyte, jchar, jshort, jint, jlong, jfloat, jdouble, Object)>(
          "mixed");
      constexpr jlong kWide = 1LL << 33;
      constexpr jlong kOffset = 10 - 3 + 65 - 1000 + kWide + 5 + 5 + 5;
      return measure(n, sumIndices(n) + count * kOffset, [&](int i) {
        return method(cls, JNI_TRUE, -3, u'A', -1000, i, kWide, 1.25f, 2.5, target);
      });
    }
    case 3: {
      static const auto method =
          cls->getNonvirtualMethod<jdouble(jdouble, jdouble)>("add");
      return measure(n, sumIndices(n) + count * 7, [&](int i) {
        return static_cast<jlong>(method(target, cls, i + 0.5, 6.5));
      });
    }
    case 4: {
      static const auto method = cls->getMethod<void(jint)>("set");
      static const auto field = cls->getField<jint>("value");
      target->setFieldValue(field, jint(-1));
      const auto elapsed = measure(n, count, [&](int i) {
        method(target, i);
        return 1;
      });
      if (target->getFieldValue(field) != ((n - 1) & 255)) {
        throw std::runtime_error("wrong field value after set");
      }
      return elapsed;
    }
    case 5: {
      static const auto method =
          cls->getMethod<local_ref<jobject>(Object)>("identity");
      if (method(target, target) != target) {
        throw std::runtime_error("object identity mismatch");
      }
      return measure(n, count, [&](int) {
        return static_cast<bool>(method(target, target));
      });
    }
    case 6: {
      static const auto ctor = cls->getConstructor<jobject(jint, Object)>();
      static const auto value = cls->getField<jint>("value");
      static const auto tag = cls->getField<jobject>("tag");
      auto check = cls->newObject(ctor, jint(42), target);
      if (check->getFieldValue(value) != 42 || check->getFieldValue(tag) != target) {
        throw std::runtime_error("incorrect constructor fields");
      }
      return measure(n, count, [&](int i) {
        return static_cast<bool>(cls->newObject(ctor, i, target));
      });
    }
    case 7: {
      static const auto method =
          cls->getStaticMethod<jint(const std::string&)>("length");
      const std::string text = "hello";
      return measure(n, count * 5, [&](int) { return method(cls, text); });
    }
    case 8: {
      static const auto id = cls->getMethod<jint(jint, jint, jint, jint)>("four").getId();
      return measure(n, sumIndices(n) + count * 6, [&](int i) {
        auto* env = Environment::current();
        const jvalue args[] = {{.i = i}, {.i = 1}, {.i = 2}, {.i = 3}};
        jint result = env->CallIntMethodA(target.get(), id, args);
        FACEBOOK_JNI_THROW_PENDING_EXCEPTION(env);
        return result;
      });
    }
  }
  throw std::runtime_error("unknown case");
}

} // namespace

extern "C" JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  // This probe only needs fbjni's thread environment. All fixtures are local to
  // this dex, and libfbjni is loaded as a native dependency.
  return initialize(vm, [] {});
}

extern "C" JNIEXPORT jlong JNICALL Java_bench_Probe_sample(
    JNIEnv* env, jclass, jobject target, jclass type, jint which, jint n) {
  try {
    detail::JniEnvCacher cache(env);
    return sample(wrap_alias(type), wrap_alias(target), which, n);
  } catch (const std::exception& e) {
    env->ThrowNew(env->FindClass("java/lang/AssertionError"), e.what());
    return 0;
  }
}
