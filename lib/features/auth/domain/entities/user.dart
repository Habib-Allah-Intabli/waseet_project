import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uId;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? fcmToken;
  const UserEntity({
    required this.uId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [uId, email, fullName, phone, password, fcmToken];

  UserEntity copyWith({
    String? uId,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? fcmToken,
  }) {
    return UserEntity(
      uId: uId ?? this.uId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
