import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:titan_talk/widgets/meeting_option.dart';

void main() {
  testWidgets('MeetingOption Widget Test', (WidgetTester tester) async {
    // Define initial state
    bool isMute = true;

    // Build the MeetingOption widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingOption(
            text: 'Mute Audio',
            isMute: isMute,
            onChange: (value) {
              isMute = value;
            },
          ),
        ),
      ),
    );

    // Verify that the MeetingOption widget renders correctly
    expect(find.byType(MeetingOption), findsOneWidget);
    expect(find.text('Mute Audio'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Verify initial state of the Switch widget
    Switch switchWidget = tester.widget(find.byType(Switch));
    expect(switchWidget.value, isMute);

    // Simulate tapping the Switch widget to change state
    await tester.tap(find.byType(Switch));
    await tester.pump();

    // Verify that onChange callback was triggered and state was updated
    expect(isMute, false);
  });

  testWidgets('MeetingOption Widget Text Style Test', (WidgetTester tester) async {
    // Build the MeetingOption widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingOption(
            text: 'Mute Audio',
            isMute: true,
            onChange: (value) {},
          ),
        ),
      ),
    );

    // Verify text style of the text widget
    final textWidget = find.text('Mute Audio');
    final textStyle = tester.widget<Text>(textWidget).style!;
    expect(textStyle.fontSize, 16);
  });
}
