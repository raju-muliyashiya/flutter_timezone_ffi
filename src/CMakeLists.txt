# The Flutter tooling requires that developers have CMake 3.10 or later
cmake_minimum_required(VERSION 3.10)

project(flutter_timezone_ffi_library VERSION 0.0.1 LANGUAGES C CXX)

if(WIN32)
  add_library(flutter_timezone_ffi SHARED "timezone_windows.cpp")
else()
  # Android is handled via android/CMakeLists.txt now, but just in case:
  add_library(flutter_timezone_ffi SHARED "timezone_android.c")
endif()

set_target_properties(flutter_timezone_ffi PROPERTIES
  PUBLIC_HEADER timezone.h
  OUTPUT_NAME "flutter_timezone_ffi"
)

target_compile_definitions(flutter_timezone_ffi PUBLIC DART_SHARED_LIB)

if (WIN32)
  # Link the ICU library shipped with the Windows 10 SDK (icu.lib / icu.dll),
  # used to map Windows zone keys to IANA ids and compute DST-aware offsets.
  target_link_libraries(flutter_timezone_ffi icu)
endif()

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(flutter_timezone_ffi PRIVATE "-Wl,-z,max-page-size=16384")
endif()
