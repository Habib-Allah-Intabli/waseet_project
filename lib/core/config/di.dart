import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:waseet_project/core/network/network_info.dart';
import 'package:waseet_project/features/auth/data/datasources/local_data_source.dart';
import 'package:waseet_project/features/auth/data/datasources/remote_data_source.dart';
import 'package:waseet_project/features/auth/data/repositories/repositories_implement.dart';
import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:waseet_project/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/signup_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/is_first_time_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/complete_onboarding_usecase.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:waseet_project/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:waseet_project/features/bookings/domain/repositories/booking_repository.dart';
import 'package:waseet_project/features/bookings/domain/usecases/booking_usecases.dart';
import 'package:waseet_project/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:waseet_project/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:waseet_project/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:waseet_project/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:waseet_project/features/trips/data/datasources/trips_remote_data_source.dart';
import 'package:waseet_project/features/trips/data/repositories/trips_repository_impl.dart';
import 'package:waseet_project/features/trips/domain/repositories/trips_repository.dart';
import 'package:waseet_project/features/trips/domain/usecases/create_trip_usecase.dart';
import 'package:waseet_project/features/trips/domain/usecases/get_trips_usecase.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/core/theme/theme_bloc.dart';
import 'package:waseet_project/core/services/notification_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  getIt.registerLazySingleton(() => NotificationService());
  // External
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton(() => InternetConnectionChecker.instance);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        firestore: getIt(),
        auth: getIt(),
        messaging: getIt(),
      ));
  getIt.registerLazySingleton<TripsRemoteDataSource>(
      () => TripsRemoteDataSourceImpl(firestore: getIt()));
  getIt.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(firestore: getIt()));
  getIt.registerLazySingleton<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(firestore: getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => RepositoriesImplement(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ));
  getIt.registerLazySingleton<TripsRepository>(
      () => TripsRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(
        remoteDataSource: getIt(),
        tripsRemoteDataSource: getIt(),
      ));
  getIt.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(remoteDataSource: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => SignupUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogoutUsecase(getIt()));
  getIt.registerLazySingleton(() => GetSavedSessionUsecase(getIt()));
  getIt.registerLazySingleton(() => CreateTripUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTripsUseCase(getIt()));
  getIt.registerLazySingleton(() => BookTripUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMyBookingsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => IsFirstTimeUseCase(getIt()));
  getIt.registerLazySingleton(() => CompleteOnboardingUseCase(getIt()));

  // Blocs
  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt(),
        signupUseCase: getIt(),
        logoutUsecase: getIt(),
        getSavedSessionUsecase: getIt(),
        updateProfileUseCase: getIt(),
        isFirstTimeUseCase: getIt(),
        completeOnboardingUseCase: getIt(),
      ));
  getIt.registerFactory(() => TripsBloc(
        createTripUseCase: getIt(),
        getTripsUseCase: getIt(),
      ));
  getIt.registerFactory(() => BookingBloc(
        bookTripUseCase: getIt(),
        getMyBookingsUseCase: getIt(),
      ));
  getIt.registerFactory(() => FavoriteBloc(repository: getIt()));
  getIt.registerFactory(() => ThemeBloc());
}
