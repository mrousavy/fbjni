#include <fbjni/fbjni.h>

using namespace facebook::jni;

extern "C" jdouble fbjni_nonvirtual_two_doubles(
    const JNonvirtualMethod<jdouble(jdouble, jdouble)>& method,
    jobject receiver,
    jclass cls,
    jdouble first,
    jdouble second) {
  return method(wrap_alias(receiver), wrap_alias(cls), first, second);
}

extern "C" jint fbjni_static_zero(const JStaticMethod<jint()>& method, jclass cls) {
  return method(wrap_alias(cls));
}

extern "C" jlong fbjni_virtual_mixed(
    const JMethod<jlong(jfloat, jbyte, jlong, alias_ref<jobject>)>& method,
    jobject receiver,
    jfloat fraction,
    jbyte small,
    jlong wide,
    jobject other) {
  return method(wrap_alias(receiver), fraction, small, wide, wrap_alias(other));
}
