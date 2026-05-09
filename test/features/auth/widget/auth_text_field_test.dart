import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  group('AuthTextField Widget Tests', () {
    testWidgets('should display label and hint', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(label: 'Email', hint: 'Enter your email'),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should display prefix icon when provided', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('should display password field when isPassword is true', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Password',
              hint: 'Enter your password',
              isPassword: true,
              prefixIcon: Icons.lock,
            ),
          ),
        ),
      );

      // Assert - Check if the field exists
      final textFieldFinder = find.byType(TextFormField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should display regular field when isPassword is false', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              hint: 'Enter your email',
              isPassword: false,
              prefixIcon: Icons.email,
            ),
          ),
        ),
      );

      // Assert
      final textFieldFinder = find.byType(TextFormField);
      expect(textFieldFinder, findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should use controller when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'test@example.com');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              hint: 'Enter your email',
              controller: controller,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller, controller);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should apply validator when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AuthTextField(
                label: 'Email',
                hint: 'Enter your email',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState?.validate();
      await tester.pump();

      // Assert
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('should display label and hint correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(label: 'Email', hint: 'Enter your email'),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });
  });
}
