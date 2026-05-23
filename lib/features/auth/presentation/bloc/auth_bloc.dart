import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/signup_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/is_first_time_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/complete_onboarding_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUsecase logoutUsecase;
  final GetSavedSessionUsecase getSavedSessionUsecase;
  final UpdateProfileUseCase updateProfileUseCase;
  final IsFirstTimeUseCase isFirstTimeUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUsecase,
    required this.getSavedSessionUsecase,
    required this.updateProfileUseCase,
    required this.isFirstTimeUseCase,
    required this.completeOnboardingUseCase,
  }) : super(AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<CompleteOnboardingRequested>(_onCompleteOnboardingRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    if (isFirstTimeUseCase()) {
      emit(AuthState.onboarding());
      return;
    }

    emit(AuthState.loading());
    final result = await getSavedSessionUsecase();
    result.fold((failure) => emit(AuthState.unauthenticated()), (user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    final result = await signupUseCase(event.user);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    await logoutUsecase();
    emit(AuthState.unauthenticated());
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, user: event.user));
    final result = await updateProfileUseCase(user: event.user);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: event.user,
      )),
    );
  }

  Future<void> _onCompleteOnboardingRequested(
    CompleteOnboardingRequested event,
    Emitter<AuthState> emit,
  ) async {
    await completeOnboardingUseCase();
    emit(AuthState.unauthenticated());
  }
}
