import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String tripId;
  final String passengerId;
  final String passengerName;
  final String passengerPhone;
  final String driverId;
  final String driverName;
  final int seatsCount;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final DateTime createdAt;
  final String fromCity;
  final String toCity;
  final DateTime tripDate;

  const BookingEntity({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.driverId,
    required this.driverName,
    required this.seatsCount,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.fromCity,
    required this.toCity,
    required this.tripDate,
  });

  @override
  List<Object?> get props => [
        id,
        tripId,
        passengerId,
        passengerName,
        passengerPhone,
        driverId,
        driverName,
        seatsCount,
        totalPrice,
        status,
        createdAt,
        fromCity,
        toCity,
        tripDate,
      ];
}
