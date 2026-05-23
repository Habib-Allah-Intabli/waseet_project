import 'package:dartz/dartz.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:waseet_project/features/bookings/data/models/booking_model.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';
import 'package:waseet_project/features/bookings/domain/repositories/booking_repository.dart';
import 'package:waseet_project/features/trips/data/datasources/trips_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final TripsRemoteDataSource tripsRemoteDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.tripsRemoteDataSource,
  });

  @override
  Future<Either<Failure, void>> bookTrip(BookingEntity booking) async {
    try {
      final model = BookingModel(
        id: booking.id,
        tripId: booking.tripId,
        passengerId: booking.passengerId,
        passengerName: booking.passengerName,
        passengerPhone: booking.passengerPhone,
        driverId: booking.driverId,
        driverName: booking.driverName,
        seatsCount: booking.seatsCount,
        totalPrice: booking.totalPrice,
        status: booking.status,
        createdAt: booking.createdAt,
        fromCity: booking.fromCity,
        toCity: booking.toCity,
        tripDate: booking.tripDate,
      );
      
      // 1. Create the booking
      await remoteDataSource.createBooking(model);
      
      // 2. Decrease available seats in the trip
      await tripsRemoteDataSource.updateTripSeats(booking.tripId, booking.seatsCount);
      
      return const Right(null);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings(String userId) async {
    try {
      final result = await remoteDataSource.getMyBookings(userId);
      return Right(result);
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
