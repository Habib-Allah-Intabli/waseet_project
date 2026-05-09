import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> bookTrip(BookingEntity booking);
  Future<Either<Failure, List<BookingEntity>>> getMyBookings(String userId);
}
