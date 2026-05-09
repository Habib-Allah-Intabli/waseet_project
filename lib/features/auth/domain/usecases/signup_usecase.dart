import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return repository.register(user: user);
  }
}
