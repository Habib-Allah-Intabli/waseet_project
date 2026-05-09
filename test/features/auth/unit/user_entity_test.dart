import 'package:flutter_test/flutter_test.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';

void main() {
  group('UserEntity', () {
    test('should create UserEntity with correct values', () {
      // Arrange
      const user = UserEntity(
        uId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        password: 'password123',
        fcmToken: 'token123',
      );

      // Assert
      expect(user.uId, '123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '1234567890');
      expect(user.password, 'password123');
      expect(user.fcmToken, 'token123');
    });

    test('should create UserEntity without fcmToken', () {
      // Arrange
      const user = UserEntity(
        uId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        password: 'password123',
      );

      // Assert
      expect(user.fcmToken, null);
    });

    test('copyWith should update specific fields', () {
      // Arrange
      const user = UserEntity(
        uId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        password: 'password123',
      );

      // Act
      final updatedUser = user.copyWith(fullName: 'Jane Doe');

      // Assert
      expect(updatedUser.fullName, 'Jane Doe');
      expect(updatedUser.email, 'john@example.com');
      expect(updatedUser.uId, '123');
    });

    test('props should contain all fields', () {
      // Arrange
      const user1 = UserEntity(
        uId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        password: 'password123',
      );
      const user2 = UserEntity(
        uId: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        password: 'password123',
      );

      // Assert
      expect(user1, user2);
    });
  });
}
