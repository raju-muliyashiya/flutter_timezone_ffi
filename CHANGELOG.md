## 0.0.2

* Android: added `-Wl,-z,max-page-size=16384` linker flag to align ELF load
  segments to 16 KB, satisfying the Android 15+ / Google Play 16 KB page-size
  requirement (Pixel 8 and future hardware).

## 0.0.1

* Initial release of the `flutter_timezone_ffi` plugin.
* Synchronous device timezone access via `dart:ffi`:
  `getLocalTimezone()`, `getTimezoneAbbreviation()`, `getUtcOffsetSeconds()`, and `getUtcOffset()`.
* Support for Android, iOS, macOS, Windows, and Web (via the browser `Intl` API).
