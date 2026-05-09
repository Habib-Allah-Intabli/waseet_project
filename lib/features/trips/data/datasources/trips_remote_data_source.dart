import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waseet_project/features/trips/data/models/trip_model.dart';

abstract class TripsRemoteDataSource {
  Future<void> createTrip(TripModel trip);
  Future<List<TripModel>> getTrips({String? fromCity, String? toCity});
  Future<List<TripModel>> getMyTrips(String userId);
  Future<void> updateTripSeats(String tripId, int seatsToSubtract);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String _collection = 'trips';

  TripsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createTrip(TripModel trip) async {
    await firestore.collection(_collection).add(trip.toMap());
  }

  @override
  Future<List<TripModel>> getTrips({String? fromCity, String? toCity}) async {
    Query query = firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true);

    if (fromCity != null && fromCity.isNotEmpty) {
      query = query.where('fromCity', isEqualTo: fromCity);
    }
    if (toCity != null && toCity.isNotEmpty) {
      query = query.where('toCity', isEqualTo: toCity);
    }

    final result = await query.get();
    return result.docs
        .map(
          (doc) =>
              TripModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  @override
  Future<List<TripModel>> getMyTrips(String userId) async {
    final result = await firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return result.docs
        .map((doc) => TripModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> updateTripSeats(String tripId, int seatsToSubtract) async {
    await firestore.collection(_collection).doc(tripId).update({
      'availableSeats': FieldValue.increment(-seatsToSubtract),
    });
  }
}
