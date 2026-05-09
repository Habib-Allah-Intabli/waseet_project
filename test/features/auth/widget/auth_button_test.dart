import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_button.dart';

void main() {
  group('AuthButton Widget Tests', () {
    testWidgets('should display text and icon', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Login';
      const buttonIcon = Icons.login;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: buttonText,
              icon: buttonIcon,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byIcon(buttonIcon), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: 'Login',
              icon: Icons.login,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AuthButton));
      await tester.pump();

      // Assert
      expect(pressed, true);
    });

    testWidgets('should have correct background color', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: 'Login',
              icon: Icons.login,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(
        button.style?.backgroundColor?.resolve({}),
        const Color(0xFF0A1D70),
      );
    });

    testWidgets('should center text and icon', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: 'Login',
              icon: Icons.login,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });
  });
}
