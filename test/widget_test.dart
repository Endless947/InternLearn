import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_learn/screens/tabs/widgets/profile_email_card.dart';

void main() {
  testWidgets('Profile email card renders user email', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileEmailCard(email: 'student@example.com'),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('student@example.com'), findsOneWidget);
  });
}
