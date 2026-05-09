import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/domain/repositories/trips_repository.dart';

class CreateTripUseCase {
  final TripsRepository repository;
  CreateTripUseCase(this.repository);

  Future<Either<Failure, void>> call(TripEntity trip) {
    return repository.createTrip(trip);
  }
}
