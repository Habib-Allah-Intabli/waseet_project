import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

abstract class TripsRepository {
  Future<Either<Failure, void>> createTrip(TripEntity trip);
  Future<Either<Failure, List<TripEntity>>> getTrips({
    String? fromCity,
    String? toCity,
  });
  Future<Either<Failure, List<TripEntity>>> getMyTrips(String userId);
}
