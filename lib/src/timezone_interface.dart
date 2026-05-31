/// Common interface implemented by each platform-specific backend.
///
/// The concrete implementation is chosen at compile time via conditional
/// imports in `timezone_platform.dart`, so that `dart:ffi` is only referenced
/// on platforms where it exists.
abstract class TimezonePlatform {
  /// Get the local timezone identifier (e.g. "America/New_York").
  String getLocalTimezone();

  /// Get the timezone abbreviation (e.g. "EST", "PST").
  String getTimezoneAbbreviation();

  /// Get the UTC offset in seconds (east of UTC is positive).
  int getUtcOffsetSeconds();
}
