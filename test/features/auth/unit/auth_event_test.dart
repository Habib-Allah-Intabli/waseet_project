import 'package:flutter_test/flutter_test.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';

void main() {
  group('AuthEvent', () {
    final testUser = UserEntity(
      uId: '123',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      password: 'password123',
    );

    test('AppStarted should have empty props', () {
      // Arrange
      const event = AppStarted();

      // Assert
      expect(event.props, []);
    });

    test('LoginRequested should have email and password in props', () {
      // Arrange
      final event = LoginRequested(
        email: 'john@example.com',
        password: 'password123',
      );

      // Assert
      expect(event.email, 'john@example.com');
      expect(event.password, 'password123');
      expect(event.props, ['john@example.com', 'password123']);
    });

    test('SignupRequested should have user in props', () {
      // Arrange
      final event = SignupRequested(user: testUser);

      // Assert
      expect(event.user, testUser);
      expect(event.props, [testUser]);
    });

    test('LogoutRequested should have empty props', () {
      // Arrange
      const event = LogoutRequested();

      // Assert
      expect(event.props, []);
    });

    test('UpdateProfileRequested should have user in props', () {
      // Arrange
      final event = UpdateProfileRequested(user: testUser);

      // Assert
      expect(event.user, testUser);
      expect(event.props, [testUser]);
    });

    test('CompleteOnboardingRequested should have empty props', () {
      // Arrange
      const event = CompleteOnboardingRequested();

      // Assert
      expect(event.props, []);
    });

    test('LoginRequested with same values should be equal', () {
      // Arrange
      const event1 = LoginRequested(
        email: 'john@example.com',
        password: 'password123',
      );
      const event2 = LoginRequested(
        email: 'john@example.com',
        password: 'password123',
      );

      // Assert
      expect(event1, event2);
    });
  });
}
