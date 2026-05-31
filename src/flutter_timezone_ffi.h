#ifndef FLUTTER_TIMEZONE_FFI_H
#define FLUTTER_TIMEZONE_FFI_H

// Cross-platform export macro for symbols exposed to Dart via FFI.
#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default")))
#endif

#endif  // FLUTTER_TIMEZONE_FFI_H
