import 'package:equatable/equatable.dart';

class TripEntity extends Equatable {
  final String id;
  final String userId;
  final String fromCity;
  final String toCity;
  final DateTime date;
  final int availableSeats;
  final bool allowParcel;
  final String notes;
  final String status; // e.g., 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final double price;
  final String driverName;

  const TripEntity({
    required this.id,
    required this.userId,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.availableSeats,
    required this.allowParcel,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.price,
    required this.driverName,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    fromCity,
    toCity,
    date,
    availableSeats,
    allowParcel,
    notes,
    status,
    createdAt,
    price,
    driverName,
  ];
}
