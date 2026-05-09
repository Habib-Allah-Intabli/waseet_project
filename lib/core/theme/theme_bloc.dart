import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent {}
class ToggleTheme extends ThemeEvent {}
class LoadTheme extends ThemeEvent {}

// State
class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';

  ThemeBloc() : super(ThemeState(ThemeMode.light)) {
    on<LoadTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    });

    on<ToggleTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDark = state.themeMode == ThemeMode.dark;
      await prefs.setBool(_themeKey, !isDark);
      emit(ThemeState(!isDark ? ThemeMode.dark : ThemeMode.light));
    });
  }
}
