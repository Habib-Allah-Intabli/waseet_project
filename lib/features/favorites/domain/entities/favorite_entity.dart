import 'package:equatable/equatable.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class FavoriteEntity extends Equatable {
  final String userId;
  final TripEntity trip;

  const FavoriteEntity({
    required this.userId,
    required this.trip,
  });

  @override
  List<Object?> get props => [userId, trip];
}
