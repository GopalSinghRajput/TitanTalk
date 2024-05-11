import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Integration Test', () {
    late driver.FlutterDriver flutterDriver;
    setUpAll(() async {
      flutterDriver = await driver.FlutterDriver.connect();
    });
    tearDownAll(() async {
      await flutterDriver.close();
    });

    test('Example Test', () async {
      final buttonFinder = driver.find.byValueKey('myButton');
      await flutterDriver.tap(buttonFinder);
      await flutterDriver
          .waitFor(find.text('Button tapped') as driver.SerializableFinder);
    });
  });
}
