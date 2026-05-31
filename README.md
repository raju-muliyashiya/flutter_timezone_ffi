# flutter_timezone_ffi

A high-performance, synchronous Flutter plugin to get device timezone information using `dart:ffi`.

[![pub package](https://img.shields.io/pub/v/flutter_timezone_ffi.svg)](https://pub.dev/packages/flutter_timezone_ffi)

Unlike platform channels that require asynchronous calls (`Future`), this package uses Foreign Function Interfaces (FFI) to retrieve timezone data synchronously. This provides instant results and reduces bridge overhead, making it ideal for performance-critical applications.

## Features

- **Synchronous Execution**: No `async`/`await` overhead.
- **Cross-Platform**: Supports Android, iOS, macOS, Windows, and Web.
- **Native Precision**: Directly queries the underlying operating system for exact timezone information.

## Getting Started

Add `flutter_timezone_ffi` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_timezone_ffi: ^0.0.1
```

## Usage

Import the package in your Dart code:

```dart
import 'package:flutter_timezone_ffi/flutter_timezone_ffi.dart';
```

Retrieve timezone information synchronously:

```dart
// Get the local timezone identifier (e.g., "America/New_York", "Asia/Kolkata")
String timezone = FlutterTimezoneFfi.getLocalTimezone();

// Get the timezone abbreviation (e.g., "EST", "IST")
String abbreviation = FlutterTimezoneFfi.getTimezoneAbbreviation();

// Get UTC offset in seconds
int offsetSeconds = FlutterTimezoneFfi.getUtcOffsetSeconds();

// Get UTC offset as a convenient Duration object
Duration offset = FlutterTimezoneFfi.getUtcOffset();

print('Timezone: $timezone');
print('Abbreviation: $abbreviation');
print('Offset: ${offset.inHours}h ${offset.inMinutes.remainder(60)}m');
```

## Platform-Specific Implementation Details

This plugin relies on the following APIs to fetch timezone details accurately on each platform:

- **Android**: Reads the `persist.sys.timezone` system property for the IANA id, and the C library (`localtime_r` / `tm_gmtoff`) for the abbreviation and offset. No JNI is required, so it works from a pure `dart:ffi`-loaded library.
- **iOS & macOS**: Objective-C `NSTimeZone` from Foundation.
- **Windows**: `GetDynamicTimeZoneInformation` combined with ICU (`ucal_*`, shipped with Windows 10) to map the OS zone key to an IANA id and compute a DST-aware offset.
- **Web**: Uses the browser's `Intl.DateTimeFormat().resolvedOptions().timeZone` for the IANA id, and `DateTime` for the offset and abbreviation.

### A note on `getTimezoneAbbreviation()`

The abbreviation comes from each operating system's own timezone data, so its **format can differ by platform for some zones**. The IANA identifier (`getLocalTimezone()`) and the offset (`getUtcOffsetSeconds()` / `getUtcOffset()`) are consistent everywhere; only the abbreviation string varies.

- **Android, iOS, macOS** read the tz-database abbreviation, e.g. `Asia/Kolkata` → `IST`, `America/New_York` → `EST`/`EDT`.
- **Windows** uses ICU/CLDR. Well-known zones still return short codes (`EST`, `CET`, …), but zones that CLDR has no recognized short code for fall back to a GMT-offset form, e.g. `Asia/Kolkata` → `GMT+5:30`. (CLDR avoids `IST` because it is ambiguous between India, Israel, and Ireland.)
- **Web** returns whatever the browser provides via `DateTime.timeZoneName`, which is often a longer descriptive name, e.g. `India Standard Time`.

If you need a value you can rely on across every platform, prefer the IANA identifier or the numeric UTC offset rather than the abbreviation.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you'd like to contribute code, feel free to open a pull request.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
