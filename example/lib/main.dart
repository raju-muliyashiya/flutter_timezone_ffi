import 'package:flutter/material.dart';
import 'package:flutter_timezone_ffi/flutter_timezone_ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Timezone FFI Example')),
        body: Center(child: TimezoneInfo()),
      ),
    );
  }
}

class TimezoneInfo extends StatelessWidget {
  const TimezoneInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // Synchronous calls - no await needed!
    final timezone = FlutterTimezoneFfi.getLocalTimezone();
    final abbr = FlutterTimezoneFfi.getTimezoneAbbreviation();
    final offset = FlutterTimezoneFfi.getUtcOffset();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Timezone: $timezone',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          'Abbreviation: $abbr',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'UTC Offset: ${offset.inHours}h ${offset.inMinutes.remainder(60)}m',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
