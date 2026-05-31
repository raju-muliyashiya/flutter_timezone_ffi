cmake_minimum_required(VERSION 3.10)

project(flutter_timezone_ffi VERSION 0.0.1 LANGUAGES C)

add_library(flutter_timezone_ffi SHARED
    ../src/timezone_android.c
)

set_target_properties(flutter_timezone_ffi PROPERTIES
    PUBLIC_HEADER ../src/timezone.h
    OUTPUT_NAME "flutter_timezone_ffi"
)

target_compile_definitions(flutter_timezone_ffi PUBLIC DART_SHARED_LIB)

# Link against NDK log library (standard for all Android native code)
find_library(log-lib log)
target_link_libraries(flutter_timezone_ffi
    ${log-lib}
)
