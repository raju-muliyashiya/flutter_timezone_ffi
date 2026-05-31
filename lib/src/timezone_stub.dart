import 'timezone_interface.dart';

/// Factory used by the conditional import in `timezone_platform.dart` when
/// neither `dart:io` nor `dart:js_interop` is available.
TimezonePlatform createPlatform() => throw UnsupportedError(
      'flutter_timezone_ffi is not supported on this platform.',
    );
