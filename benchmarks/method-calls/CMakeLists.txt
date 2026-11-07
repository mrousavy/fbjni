cmake_minimum_required(VERSION 3.22)
project(fbjni_call_benchmark LANGUAGES CXX)

add_subdirectory("${FBJNI_ROOT}" fbjni)
add_library(call-bench SHARED Probe.cpp)
target_compile_features(call-bench PRIVATE cxx_std_20)
target_link_libraries(call-bench PRIVATE fbjni)
