import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'bindings.dart';
import 'timezone_interface.dart';

/// Factory used by the conditional import in `timezone_platform.dart`.
TimezonePlatform createPlatform() => TimezoneFfi();

class TimezoneFfi implements TimezonePlatform {
  static TimezoneFfi? _instance;
  late final TimezoneBindings _bindings;

  TimezoneFfi._() {
    final DynamicLibrary dylib = _loadLibrary();
    _bindings = TimezoneBindings(dylib);
  }

  factory TimezoneFfi() {
    return _instance ??= TimezoneFfi._();
  }

  DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libflutter_timezone_ffi.so');
    } else if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('flutter_timezone_ffi.framework/flutter_timezone_ffi');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('flutter_timezone_ffi.dll');
    }
    throw UnsupportedError('Platform not supported');
  }

  @override
  String getLocalTimezone() {
    return _readAndFree(_bindings.get_local_timezone());
  }

  @override
  String getTimezoneAbbreviation() {
    return _readAndFree(_bindings.get_timezone_abbreviation());
  }

  /// Copies the native string into a Dart string and frees the native buffer.
  ///
  /// The native functions transfer ownership of a heap-allocated buffer; we
  /// must release it with [TimezoneBindings.free_timezone_string] after
  /// copying. Returns an empty string if the native side returned NULL.
  String _readAndFree(Pointer<Char> result) {
    if (result == nullptr) return '';
    try {
      return result.cast<Utf8>().toDartString();
    } finally {
      _bindings.free_timezone_string(result);
    }
  }

  @override
  int getUtcOffsetSeconds() {
    return _bindings.get_utc_offset_seconds();
  }
}
