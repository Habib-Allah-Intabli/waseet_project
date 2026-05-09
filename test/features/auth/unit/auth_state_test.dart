import 'package:flutter_test/flutter_test.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';

void main() {
  group('AuthState', () {
    const testUser = UserEntity(
      uId: '123',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '1234567890',
      password: 'password123',
    );

    test('initial state should have initial status', () {
      // Act
      final state = AuthState.initial();

      // Assert
      expect(state.status, AuthStatus.initial);
      expect(state.user, null);
      expect(state.errorMessage, null);
    });

    test('onboarding state should have onboarding status', () {
      // Act
      final state = AuthState.onboarding();

      // Assert
      expect(state.status, AuthStatus.onboarding);
    });

    test('authenticated state should have user', () {
      // Act
      final state = AuthState.authenticated(testUser);

      // Assert
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, testUser);
    });

    test('unauthenticated state should have unauthenticated status', () {
      // Act
      final state = AuthState.unauthenticated();

      // Assert
      expect(state.status, AuthStatus.unauthenticated);
    });

    test('loading state should have loading status', () {
      // Act
      final state = AuthState.loading();

      // Assert
      expect(state.status, AuthStatus.loading);
    });

    test('error state should have error message', () {
      // Act
      final state = AuthState.error('Invalid credentials');

      // Assert
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });

    test('isLoading should return true when status is loading', () {
      // Arrange
      final loadingState = AuthState.loading();
      final authenticatedState = AuthState.authenticated(testUser);

      // Assert
      expect(loadingState.isLoading, true);
      expect(authenticatedState.isLoading, false);
    });

    test('copyWith should update specific fields', () {
      // Arrange
      final state = AuthState.authenticated(testUser);

      // Act
      final updatedState = state.copyWith(
        status: AuthStatus.loading,
        errorMessage: 'Error',
      );

      // Assert
      expect(updatedState.status, AuthStatus.loading);
      expect(updatedState.errorMessage, 'Error');
      expect(updatedState.user, testUser);
    });

    test('props should contain all fields', () {
      // Arrange
      final state1 = AuthState.authenticated(testUser);
      final state2 = AuthState.authenticated(testUser);

      // Assert
      expect(state1, state2);
    });
  });
}
