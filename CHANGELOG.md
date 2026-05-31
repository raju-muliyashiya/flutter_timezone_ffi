## 0.0.1

* Initial release of the `flutter_timezone_ffi` plugin.
* Synchronous device timezone access via `dart:ffi`:
  `getLocalTimezone()`, `getTimezoneAbbreviation()`, `getUtcOffsetSeconds()`, and `getUtcOffset()`.
* Support for Android, iOS, macOS, Windows, and Web (via the browser `Intl` API).
