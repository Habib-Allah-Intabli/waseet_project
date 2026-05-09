import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/bookings/domain/usecases/booking_usecases.dart';
import 'booking_bloc_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookTripUseCase bookTripUseCase;
  final GetMyBookingsUseCase getMyBookingsUseCase;

  BookingBloc({
    required this.bookTripUseCase,
    required this.getMyBookingsUseCase,
  }) : super(BookingInitial()) {
    on<BookTripRequested>((event, emit) async {
      emit(BookingLoading());
      final result = await bookTripUseCase(event.booking);
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (_) => emit(BookingSuccess()),
      );
    });

    on<LoadMyBookings>((event, emit) async {
      emit(BookingLoading());
      final result = await getMyBookingsUseCase(event.userId);
      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (bookings) => emit(BookingsLoaded(bookings)),
      );
    });
  }
}
