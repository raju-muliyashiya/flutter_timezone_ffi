// Integration tests for flutter_timezone_ffi.
//
// These exercise the real native library, so they must run on a device,
// emulator, or desktop host (not the plain `flutter test` Dart VM):
//
//   cd example
//   flutter test integration_test
//
// On web, run with: flutter test integration_test -d chrome

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_timezone_ffi/flutter_timezone_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getLocalTimezone returns a non-empty identifier',
      (WidgetTester tester) async {
    final tz = FlutterTimezoneFfi.getLocalTimezone();
    expect(tz, isNotEmpty);
  });

  testWidgets('getTimezoneAbbreviation returns a string',
      (WidgetTester tester) async {
    final abbr = FlutterTimezoneFfi.getTimezoneAbbreviation();
    expect(abbr, isA<String>());
  });

  testWidgets('UTC offset is within the valid range',
      (WidgetTester tester) async {
    final offset = FlutterTimezoneFfi.getUtcOffsetSeconds();
    // Real-world offsets span UTC-12 to UTC+14.
    expect(offset, inInclusiveRange(-12 * 3600, 14 * 3600));
  });

  testWidgets('getUtcOffset is consistent with getUtcOffsetSeconds',
      (WidgetTester tester) async {
    expect(
      FlutterTimezoneFfi.getUtcOffset().inSeconds,
      FlutterTimezoneFfi.getUtcOffsetSeconds(),
    );
  });

  testWidgets('repeated calls are stable (no buffer corruption)',
      (WidgetTester tester) async {
    final first = FlutterTimezoneFfi.getLocalTimezone();
    for (var i = 0; i < 100; i++) {
      expect(FlutterTimezoneFfi.getLocalTimezone(), first);
    }
  });
}
