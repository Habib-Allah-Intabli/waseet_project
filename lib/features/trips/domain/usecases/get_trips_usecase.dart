import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/domain/repositories/trips_repository.dart';

class GetTripsUseCase {
  final TripsRepository repository;
  GetTripsUseCase(this.repository);

  Future<Either<Failure, List<TripEntity>>> call({
    String? fromCity,
    String? toCity,
  }) {
    return repository.getTrips(fromCity: fromCity, toCity: toCity);
  }
}
