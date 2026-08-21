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

# ── 16 KB page-size alignment (required for Android 15+ / Google Play) ────────
# Aligns ELF load segments to 16 KB so the .so works on devices with a 16 KB
# memory page size (Pixel 8+, future Android hardware). Without this flag the
# linker defaults to 4 KB alignment and Google Play Console shows a warning.
target_link_options(flutter_timezone_ffi PRIVATE
    "-Wl,-z,max-page-size=16384"
)

# Link against NDK log library (standard for all Android native code)
find_library(log-lib log)
target_link_libraries(flutter_timezone_ffi
    ${log-lib}
)
