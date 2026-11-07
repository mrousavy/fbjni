# ARM64 call sites

`fbjni_nonvirtual_two_doubles` calls a Java base method with two `jdouble` arguments. The baseline also calls the NDK's variadic `CallNonvirtualDoubleMethod` wrapper. That wrapper allocates a 240-byte frame, saves the argument registers and constructs the `va_list` used by `CallNonvirtualDoubleMethodV`. The candidate stores the two doubles with `stp d9, d8, [sp]` and passes their address to `CallNonvirtualDoubleMethodA`. Both versions call `Environment::current()` and `throwPendingJniExceptionAsCppException(env)`.

`fbjni_static_zero` shows the null argument pointer for an empty pack. `fbjni_virtual_mixed` includes a float, a byte, a long and an object reference.

To regenerate these listings, set `CXX` to the `aarch64-linux-android21-clang++` driver from NDK 29.0.14206865 and point `BEFORE` and `AFTER` to checkouts of the two [benchmarked commits](../README.md).

```sh
"$CXX" -std=c++20 -O3 -DNDEBUG -fPIC -S -I"$BEFORE/cxx" jvalue-wrapper-assembly.cpp -o before-arm64.s
"$CXX" -std=c++20 -O3 -DNDEBUG -fPIC -S -I"$AFTER/cxx" jvalue-wrapper-assembly.cpp -o after-arm64.s
```
