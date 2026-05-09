import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/auth/data/datasources/local_data_source.dart';
import 'package:waseet_project/features/auth/data/datasources/remote_data_source.dart';
import 'package:waseet_project/features/auth/data/models/user_model.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';

class RepositoriesImplement implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  RepositoriesImplement({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> register({
    required UserEntity user,
  }) async {
    try {
      final model = UserModel(
        uId: user.uId,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: user.password,
      );
      final resultUser = await remoteDataSource.register(user: model);
      await localDataSource.saveSession(resultUser.uId);
      return Right(resultUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveSession(user.uId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSavedSession() async {
    try {
      if (!localDataSource.hasSession()) return const Right(null);
      final uId = localDataSource.getSession()!;
      final user = await remoteDataSource.getUserById(uId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({required UserEntity user}) async {
    try {
      final model = UserModel(
        uId: user.uId,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: user.password,
        fcmToken: user.fcmToken,
      );
      await remoteDataSource.updateUser(user: model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  bool isFirstTimeOpen() {
    return localDataSource.isFirstTimeOpen();
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.completeOnboarding();
  }
}
