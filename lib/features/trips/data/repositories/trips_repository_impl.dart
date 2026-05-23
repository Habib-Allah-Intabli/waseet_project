import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/trips/data/datasources/trips_remote_data_source.dart';
import 'package:waseet_project/features/trips/data/models/trip_model.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/domain/repositories/trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remoteDataSource;

  TripsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createTrip(TripEntity trip) async {
    try {
      final model = TripModel(
        id: trip.id,
        userId: trip.userId,
        fromCity: trip.fromCity,
        toCity: trip.toCity,
        date: trip.date,
        availableSeats: trip.availableSeats,
        allowParcel: trip.allowParcel,
        notes: trip.notes,
        status: trip.status,
        createdAt: trip.createdAt,
        price: trip.price,
        driverName: trip.driverName,
      );
      await remoteDataSource.createTrip(model);
      return const Right(null);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getTrips({
    String? fromCity,
    String? toCity,
  }) async {
    try {
      final result = await remoteDataSource.getTrips(
        fromCity: fromCity,
        toCity: toCity,
      );
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<TripEntity>>> getMyTrips(String userId) async {
    try {
      final result = await remoteDataSource.getMyTrips(userId);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
