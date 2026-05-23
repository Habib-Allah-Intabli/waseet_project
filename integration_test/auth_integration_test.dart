import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:waseet_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Tests', () {
    testWidgets('should navigate through auth flow', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Assert - Check if app starts
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should find auth button on screen', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Assert - Look for ElevatedButton (AuthButton uses ElevatedButton)
      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsWidgets);
    });

    testWidgets('should find text input fields', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Assert - Look for TextFormField (AuthTextField uses TextFormField)
      final textFields = find.byType(TextFormField);
      expect(textFields, findsWidgets);
    });

    testWidgets('should tap on auth button', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Find and tap the first button
      final button = find.byType(ElevatedButton).first;
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Assert - Button should be tappable
      expect(button, findsOneWidget);
    });

    testWidgets('should enter text in text field', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Find and enter text in the first text field
      final textField = find.byType(TextFormField).first;
      await tester.enterText(textField, 'test@example.com');
      await tester.pumpAndSettle();

      // Assert - Text should be entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should scroll if content is scrollable', (WidgetTester tester) async {
      // Act
      app.main();
      await tester.pumpAndSettle();

      // Try to scroll
      await tester.fling(find.byType(Scrollable), const Offset(0, -300), 1000);
      await tester.pumpAndSettle();

      // Assert - Scrollable should exist
      expect(find.byType(Scrollable), findsWidgets);
    });
  });
}
