import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waseet_project/features/bookings/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getMyBookings(String userId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String _collection = 'bookings';

  BookingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createBooking(BookingModel booking) async {
    // 1. Create the booking document
    await firestore.collection(_collection).add(booking.toMap());

    // 2. Create a notification for the driver
    await firestore.collection('notifications').add({
      'targetUserId': booking.driverId,
      'title': 'حجز جديد للرحلة!',
      'body': 'قام ${booking.passengerName} بحجز ${booking.seatsCount} مقاعد لرحلتك من ${booking.fromCity} إلى ${booking.toCity}',
      'type': 'new_booking',
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'bookingId': booking.id,
    });
  }

  @override
  Future<List<BookingModel>> getMyBookings(String userId) async {
    final result = await firestore
        .collection(_collection)
        .where('passengerId', isEqualTo: userId)
        .get();
    
    final bookings = result.docs
        .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
        .toList();
        
    // Sort locally to avoid needing a composite index
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return bookings;
  }
}
