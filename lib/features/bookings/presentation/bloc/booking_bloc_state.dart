import 'package:equatable/equatable.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object> get props => [];
}

class BookTripRequested extends BookingEvent {
  final BookingEntity booking;
  const BookTripRequested(this.booking);
  @override
  List<Object> get props => [booking];
}

class LoadMyBookings extends BookingEvent {
  final String userId;
  const LoadMyBookings(this.userId);
  @override
  List<Object> get props => [userId];
}

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {}
class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const BookingsLoaded(this.bookings);
  @override
  List<Object> get props => [bookings];
}
class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object> get props => [message];
}
