import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waseet_project/features/trips/data/models/trip_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<void> addToFavorites(String userId, TripModel trip);
  Future<void> removeFromFavorites(String userId, String tripId);
  Future<List<TripModel>> getFavorites(String userId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String _collection = 'favorites';

  FavoriteRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addToFavorites(String userId, TripModel trip) async {
    await firestore
        .collection(_collection)
        .doc(userId)
        .collection('user_favorites')
        .doc(trip.id)
        .set(trip.toMap());
  }

  @override
  Future<void> removeFromFavorites(String userId, String tripId) async {
    await firestore
        .collection(_collection)
        .doc(userId)
        .collection('user_favorites')
        .doc(tripId)
        .delete();
  }

  @override
  Future<List<TripModel>> getFavorites(String userId) async {
    final snapshot = await firestore
        .collection(_collection)
        .doc(userId)
        .collection('user_favorites')
        .get();
    
    return snapshot.docs
        .map((doc) => TripModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
