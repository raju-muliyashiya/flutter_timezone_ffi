import 'dart:js_interop';
import 'timezone_interface.dart';

/// Factory used by the conditional import in `timezone_platform.dart`.
TimezonePlatform createPlatform() => TimezoneWeb();

// Minimal interop binding for `new Intl.DateTimeFormat().resolvedOptions()`,
// which exposes the IANA timezone id reported by the browser.
@JS('Intl.DateTimeFormat')
extension type _IntlDateTimeFormat._(JSObject _) implements JSObject {
  external factory _IntlDateTimeFormat();
  external _ResolvedOptions resolvedOptions();
}

extension type _ResolvedOptions._(JSObject _) implements JSObject {
  external String get timeZone;
}

class TimezoneWeb implements TimezonePlatform {
  @override
  String getLocalTimezone() {
    final String? tz = _intlTimeZone();
    if (tz != null && tz.isNotEmpty) return tz;
    // Fallback: browser-provided name (may be an abbreviation or long name).
    return DateTime.now().timeZoneName;
  }

  @override
  String getTimezoneAbbreviation() => DateTime.now().timeZoneName;

  @override
  int getUtcOffsetSeconds() => DateTime.now().timeZoneOffset.inSeconds;

  String? _intlTimeZone() {
    try {
      return _IntlDateTimeFormat().resolvedOptions().timeZone;
    } catch (_) {
      return null;
    }
  }
}
