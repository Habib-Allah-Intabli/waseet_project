import 'package:equatable/equatable.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final UserEntity user;

  const SignupRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class UpdateProfileRequested extends AuthEvent {
  final UserEntity user;
  const UpdateProfileRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

class CompleteOnboardingRequested extends AuthEvent {
  const CompleteOnboardingRequested();
}
