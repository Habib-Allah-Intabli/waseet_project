import 'package:equatable/equatable.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

abstract class TripsEvent extends Equatable {
  const TripsEvent();
  @override
  List<Object?> get props => [];
}

class LoadTrips extends TripsEvent {
  final String? fromCity;
  final String? toCity;

  const LoadTrips({this.fromCity, this.toCity});

  @override
  List<Object?> get props => [fromCity, toCity];
}

class AddTrip extends TripsEvent {
  final TripEntity trip;

  const AddTrip(this.trip);

  @override
  List<Object?> get props => [trip];
}

class SearchTrips extends TripsEvent {
  final String query;

  const SearchTrips(this.query);

  @override
  List<Object?> get props => [query];
}
