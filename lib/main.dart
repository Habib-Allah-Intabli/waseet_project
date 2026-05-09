import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/core/config/di.dart';
import 'package:waseet_project/core/services/notification_service.dart';
import 'package:waseet_project/core/theme/app_theme.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/views/onboading_view.dart';
import 'package:waseet_project/features/auth/presentation/views/sign_in_view.dart';
import 'package:waseet_project/features/auth/presentation/views/sign_up_view.dart';
import 'package:waseet_project/features/auth/presentation/views/splash_view.dart';
import 'package:waseet_project/features/home/presentation/views/home_view.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/views/add_trip_view.dart';
import 'package:waseet_project/features/trips/presentation/views/search_trips_view.dart';
import 'package:waseet_project/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:waseet_project/core/theme/theme_bloc.dart';
import 'package:waseet_project/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dependency Injection
  await configureDependencies();

  // Initialize Notifications
  await getIt<NotificationService>().initialize();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth_box');
  // var box = Hive.box('auth_box');
  // await box.clear();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<TripsBloc>(create: (context) => getIt<TripsBloc>()),
        BlocProvider<BookingBloc>(create: (context) => getIt<BookingBloc>()),
        BlocProvider<ThemeBloc>(
          create: (context) => getIt<ThemeBloc>()..add(LoadTheme()),
        ),
        BlocProvider<FavoriteBloc>(create: (context) => getIt<FavoriteBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Waseet - وسيط',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashView(),
              '/onboarding': (context) => const OnboardingView(),
              '/login': (context) => const SignInView(),
              '/register': (context) => const SignUpView(),
              '/home': (context) => const HomeView(),
              '/add-trip': (context) => const AddTripView(),
              '/search-trips': (context) => const SearchTripsView(),
            },
          );
        },
      ),
    );
  }
}
