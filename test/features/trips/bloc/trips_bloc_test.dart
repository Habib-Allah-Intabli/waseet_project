import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/domain/usecases/create_trip_usecase.dart';
import 'package:waseet_project/features/trips/domain/usecases/get_trips_usecase.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';

class MockCreateTripUseCase extends Mock implements CreateTripUseCase {}

class MockGetTripsUseCase extends Mock implements GetTripsUseCase {}

void main() {
  late TripsBloc tripsBloc;
  late MockCreateTripUseCase mockCreateTripUseCase;
  late MockGetTripsUseCase mockGetTripsUseCase;

  final testTrip = TripEntity(
    id: 'trip123',
    userId: 'user456',
    fromCity: 'دمشق',
    toCity: 'حلب',
    date: DateTime(2026, 6, 1),
    availableSeats: 4,
    allowParcel: true,
    notes: 'لا يوجد',
    status: 'active',
    createdAt: DateTime(2026, 5, 23),
    price: 15000,
    driverName: 'سليم منصور',
  );

  setUpAll(() {
    registerFallbackValue(
      TripEntity(
        id: '',
        userId: '',
        fromCity: '',
        toCity: '',
        date: DateTime.now(),
        availableSeats: 0,
        allowParcel: false,
        notes: '',
        status: '',
        createdAt: DateTime.now(),
        price: 0,
        driverName: '',
      ),
    );
  });

  setUp(() {
    mockCreateTripUseCase = MockCreateTripUseCase();
    mockGetTripsUseCase = MockGetTripsUseCase();
    tripsBloc = TripsBloc(
      createTripUseCase: mockCreateTripUseCase,
      getTripsUseCase: mockGetTripsUseCase,
    );
  });

  tearDown(() {
    tripsBloc.close();
  });

  test('initial state should be TripsInitial', () {
    expect(tripsBloc.state, isA<TripsInitial>());
  });

  group('LoadTrips', () {
    test('should emit [TripsLoading, TripsLoaded] when loading succeeds', () async {
      // Arrange
      when(
        () => mockGetTripsUseCase(
          fromCity: any(named: 'fromCity'),
          toCity: any(named: 'toCity'),
        ),
      ).thenAnswer((_) async => Right([testTrip]));

      // Act
      tripsBloc.add(const LoadTrips(fromCity: 'دمشق', toCity: 'حلب'));

      // Assert
      await expectLater(
        tripsBloc.stream,
        emitsInOrder([
          isA<TripsLoading>(),
          TripsLoaded([testTrip]),
        ]),
      );
    });

    test('should emit [TripsLoading, TripsError] when loading fails', () async {
      // Arrange
      when(
        () => mockGetTripsUseCase(
          fromCity: any(named: 'fromCity'),
          toCity: any(named: 'toCity'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure('تعذر تحميل الرحلات')));

      // Act
      tripsBloc.add(const LoadTrips(fromCity: 'دمشق', toCity: 'حلب'));

      // Assert
      await expectLater(
        tripsBloc.stream,
        emitsInOrder([
          isA<TripsLoading>(),
          const TripsError('تعذر تحميل الرحلات'),
        ]),
      );
    });
  });

  group('AddTrip', () {
    test('should emit [TripsLoading, TripAddedSuccessfully] when adding succeeds', () async {
      // Arrange
      when(
        () => mockCreateTripUseCase(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      tripsBloc.add(AddTrip(testTrip));

      // Assert
      await expectLater(
        tripsBloc.stream,
        emitsInOrder([
          isA<TripsLoading>(),
          isA<TripAddedSuccessfully>(),
        ]),
      );
    });

    test('should emit [TripsLoading, TripsError] when adding fails', () async {
      // Arrange
      when(
        () => mockCreateTripUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('فشل إضافة الرحلة')));

      // Act
      tripsBloc.add(AddTrip(testTrip));

      // Assert
      await expectLater(
        tripsBloc.stream,
        emitsInOrder([
          isA<TripsLoading>(),
          const TripsError('فشل إضافة الرحلة'),
        ]),
      );
    });
  });
}
