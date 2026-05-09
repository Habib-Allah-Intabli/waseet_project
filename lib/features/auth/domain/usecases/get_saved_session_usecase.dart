import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';

class GetSavedSessionUsecase {
  final AuthRepository repository;
  GetSavedSessionUsecase(this.repository);

  Future<Either<Failure, UserEntity?>> call() {
    return repository.getSavedSession();
  }
}
