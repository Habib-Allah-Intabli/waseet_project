import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:waseet_project/features/trips/data/models/trip_model.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addToFavorites(String userId, TripEntity trip);
  Future<Either<Failure, void>> removeFromFavorites(String userId, String tripId);
  Future<Either<Failure, List<TripEntity>>> getFavorites(String userId);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addToFavorites(String userId, TripEntity trip) async {
    try {
      final model = TripModel(
        id: trip.id,
        userId: trip.userId,
        driverName: trip.driverName,
        fromCity: trip.fromCity,
        toCity: trip.toCity,
        date: trip.date,
        price: trip.price,
        availableSeats: trip.availableSeats,
        allowParcel: trip.allowParcel,
        notes: trip.notes,
        status: trip.status,
        createdAt: trip.createdAt,
      );
      await remoteDataSource.addToFavorites(userId, model);
      return const Right(null);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String userId, String tripId) async {
    try {
      await remoteDataSource.removeFromFavorites(userId, tripId);
      return const Right(null);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getFavorites(String userId) async {
    try {
      final result = await remoteDataSource.getFavorites(userId);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
