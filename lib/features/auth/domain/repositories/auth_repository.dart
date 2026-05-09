import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register({required UserEntity user});

  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity?>> getSavedSession();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> updateProfile({required UserEntity user});

  bool isFirstTimeOpen();

  Future<void> completeOnboarding();
}
