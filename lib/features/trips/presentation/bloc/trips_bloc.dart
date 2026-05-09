import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/trips/domain/usecases/create_trip_usecase.dart';
import 'package:waseet_project/features/trips/domain/usecases/get_trips_usecase.dart';
import 'trips_event.dart';
import 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final CreateTripUseCase createTripUseCase;
  final GetTripsUseCase getTripsUseCase;

  TripsBloc({required this.createTripUseCase, required this.getTripsUseCase})
    : super(TripsInitial()) {
    on<LoadTrips>(_onLoadTrips);
    on<AddTrip>(_onAddTrip);
  }

  Future<void> _onLoadTrips(LoadTrips event, Emitter<TripsState> emit) async {
    emit(TripsLoading());
    final result = await getTripsUseCase(
      fromCity: event.fromCity,
      toCity: event.toCity,
    );
    result.fold(
      (failure) => emit(TripsError(failure.message)),
      (trips) => emit(TripsLoaded(trips)),
    );
  }

  Future<void> _onAddTrip(AddTrip event, Emitter<TripsState> emit) async {
    emit(TripsLoading());
    final result = await createTripUseCase(event.trip);
    result.fold(
      (failure) => emit(TripsError(failure.message)),
      (_) => emit(TripAddedSuccessfully()),
    );
  }
}
