import 'src/timezone_platform.dart';

/// Convenience class for accessing timezone information.
///
/// Backed by FFI on native platforms and by the browser's `Intl` API on web,
/// selected automatically via conditional imports.
class FlutterTimezoneFfi {
  static final TimezonePlatform _platform = getTimezonePlatform();

  /// Get the local timezone identifier (e.g., "America/New_York").
  ///
  /// This is a synchronous call that returns immediately.
  static String getLocalTimezone() {
    return _platform.getLocalTimezone();
  }

  /// Get timezone abbreviation (e.g., "EST", "PST").
  ///
  /// Format varies a bit by platform (Windows may give "GMT+5:30", web a long
  /// name). Use [getLocalTimezone] or [getUtcOffsetSeconds] if you need
  /// something consistent.
  static String getTimezoneAbbreviation() {
    return _platform.getTimezoneAbbreviation();
  }

  /// Get UTC offset in seconds.
  static int getUtcOffsetSeconds() {
    return _platform.getUtcOffsetSeconds();
  }

  /// Get UTC offset as Duration.
  static Duration getUtcOffset() {
    return Duration(seconds: _platform.getUtcOffsetSeconds());
  }
}
