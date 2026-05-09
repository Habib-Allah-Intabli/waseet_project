import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.userId,
    required super.fromCity,
    required super.toCity,
    required super.date,
    required super.availableSeats,
    required super.allowParcel,
    required super.notes,
    required super.status,
    required super.createdAt,
    required super.price,
    required super.driverName,
  });

  factory TripModel.fromMap(Map<String, dynamic> map, String docId) {
    return TripModel(
      id: docId,
      userId: map['userId'] ?? '',
      fromCity: map['fromCity'] ?? '',
      toCity: map['toCity'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      availableSeats: map['availableSeats'] ?? 0,
      allowParcel: map['allowParcel'] ?? false,
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'active',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      driverName: map['driverName'] ?? 'غير معروف',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fromCity': fromCity,
      'toCity': toCity,
      'date': Timestamp.fromDate(date),
      'availableSeats': availableSeats,
      'allowParcel': allowParcel,
      'notes': notes,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
      'driverName': driverName,
    };
  }
}
