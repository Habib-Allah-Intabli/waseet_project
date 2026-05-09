import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';
import 'package:waseet_project/features/bookings/domain/repositories/booking_repository.dart';

class BookTripUseCase {
  final BookingRepository repository;
  BookTripUseCase(this.repository);

  Future<Either<Failure, void>> call(BookingEntity booking) {
    return repository.bookTrip(booking);
  }
}

class GetMyBookingsUseCase {
  final BookingRepository repository;
  GetMyBookingsUseCase(this.repository);

  Future<Either<Failure, List<BookingEntity>>> call(String userId) {
    return repository.getMyBookings(userId);
  }
}
