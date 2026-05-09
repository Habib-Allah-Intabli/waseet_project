import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.tripId,
    required super.passengerId,
    required super.passengerName,
    required super.passengerPhone,
    required super.driverId,
    required super.driverName,
    required super.seatsCount,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
    required super.fromCity,
    required super.toCity,
    required super.tripDate,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      tripId: map['tripId'] ?? '',
      passengerId: map['passengerId'] ?? '',
      passengerName: map['passengerName'] ?? 'غير معروف',
      passengerPhone: map['passengerPhone'] ?? '',
      driverId: map['driverId'] ?? '',
      driverName: map['driverName'] ?? 'غير معروف',
      seatsCount: map['seatsCount'] ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fromCity: map['fromCity'] ?? '',
      toCity: map['toCity'] ?? '',
      tripDate: (map['tripDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'driverId': driverId,
      'driverName': driverName,
      'seatsCount': seatsCount,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'fromCity': fromCity,
      'toCity': toCity,
      'tripDate': Timestamp.fromDate(tripDate),
    };
  }
}
