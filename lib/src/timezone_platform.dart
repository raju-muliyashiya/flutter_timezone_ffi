import 'timezone_interface.dart';

// Pick the backend at compile time. Web builds get `timezone_web.dart` (no
// `dart:ffi`); native builds get the FFI backend; anything else gets the stub.
import 'timezone_stub.dart'
    if (dart.library.io) 'timezone_ffi.dart'
    if (dart.library.js_interop) 'timezone_web.dart';

export 'timezone_interface.dart';

/// Returns the timezone backend appropriate for the current platform.
TimezonePlatform getTimezonePlatform() => createPlatform();
