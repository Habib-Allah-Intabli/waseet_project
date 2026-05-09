import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waseet_project/core/error/failures.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/domain/usecases/complete_onboarding_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/is_first_time_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/signup_usecase.dart';
import 'package:waseet_project/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupUseCase extends Mock implements SignupUseCase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockGetSavedSessionUsecase extends Mock
    implements GetSavedSessionUsecase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockIsFirstTimeUseCase extends Mock implements IsFirstTimeUseCase {}

class MockCompleteOnboardingUseCase extends Mock
    implements CompleteOnboardingUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetSavedSessionUsecase mockGetSavedSessionUsecase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockIsFirstTimeUseCase mockIsFirstTimeUseCase;
  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;

  const testUser = UserEntity(
    uId: '123',
    fullName: 'John Doe',
    email: 'john@example.com',
    phone: '1234567890',
    password: 'password123',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetSavedSessionUsecase = MockGetSavedSessionUsecase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockIsFirstTimeUseCase = MockIsFirstTimeUseCase();
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      signupUseCase: mockSignupUseCase,
      logoutUsecase: mockLogoutUsecase,
      getSavedSessionUsecase: mockGetSavedSessionUsecase,
      updateProfileUseCase: mockUpdateProfileUseCase,
      isFirstTimeUseCase: mockIsFirstTimeUseCase,
      completeOnboardingUseCase: mockCompleteOnboardingUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AuthState.initial()', () {
    expect(authBloc.state, AuthState.initial());
  });

  group('AppStarted', () {
    test('should emit onboarding state when first time', () {
      // Arrange
      when(() => mockIsFirstTimeUseCase()).thenReturn(true);

      // Act
      authBloc.add(AppStarted());

      // Assert
      expectLater(authBloc.stream, emits(AuthState.onboarding()));
    });

    test('should emit authenticated state when session exists', () {
      // Arrange
      when(() => mockIsFirstTimeUseCase()).thenReturn(false);
      when(
        () => mockGetSavedSessionUsecase(),
      ).thenAnswer((_) async => const Right(testUser));

      // Act
      authBloc.add(AppStarted());

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([AuthState.loading(), AuthState.authenticated(testUser)]),
      );
    });

    test('should emit unauthenticated state when no session', () {
      // Arrange
      when(() => mockIsFirstTimeUseCase()).thenReturn(false);
      when(
        () => mockGetSavedSessionUsecase(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      authBloc.add(AppStarted());

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([AuthState.loading(), AuthState.unauthenticated()]),
      );
    });
  });

  group('LoginRequested', () {
    test('should emit loading then authenticated when login succeeds', () {
      // Arrange
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(testUser));

      // Act
      authBloc.add(
        const LoginRequested(
          email: 'john@example.com',
          password: 'password123',
        ),
      );

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([AuthState.loading(), AuthState.authenticated(testUser)]),
      );
    });

    test('should emit loading then error when login fails', () {
      // Arrange
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('Invalid credentials')),
      );

      // Act
      authBloc.add(
        const LoginRequested(
          email: 'john@example.com',
          password: 'wrongpassword',
        ),
      );

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthState.loading(),
          AuthState.error('Invalid credentials'),
        ]),
      );
    });
  });

  group('SignupRequested', () {
    test('should emit loading then authenticated when signup succeeds', () {
      // Arrange
      when(
        () => mockSignupUseCase(any()),
      ).thenAnswer((_) async => const Right(testUser));

      // Act
      authBloc.add(const SignupRequested(user: testUser));

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([AuthState.loading(), AuthState.authenticated(testUser)]),
      );
    });

    test('should emit loading then error when signup fails', () {
      // Arrange
      when(() => mockSignupUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure('Email already exists')),
      );

      // Act
      authBloc.add(const SignupRequested(user: testUser));

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthState.loading(),
          AuthState.error('Email already exists'),
        ]),
      );
    });
  });

  group('LogoutRequested', () {
    test('should emit loading then unauthenticated when logout succeeds', () {
      // Arrange
      when(
        () => mockLogoutUsecase(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      authBloc.add(LogoutRequested());

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([AuthState.loading(), AuthState.unauthenticated()]),
      );
    });
  });

  group('UpdateProfileRequested', () {
    test('should emit loading then authenticated when update succeeds', () {
      // Arrange
      when(
        () => mockUpdateProfileUseCase(user: any(named: 'user')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      authBloc.add(const UpdateProfileRequested(user: testUser));

      // Assert
      expectLater(
        authBloc.stream,
        emitsInOrder([
          AuthState(status: AuthStatus.loading, user: testUser),
          AuthState(status: AuthStatus.authenticated, user: testUser),
        ]),
      );
    });

    test('should emit error when update fails', () {
      // Arrange
      when(
        () => mockUpdateProfileUseCase(user: any(named: 'user')),
      ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));

      // Act
      authBloc.add(const UpdateProfileRequested(user: testUser));

      // Assert
      expectLater(
        authBloc.stream,
        emits(
          AuthState(
            status: AuthStatus.error,
            user: testUser,
            errorMessage: 'Update failed',
          ),
        ),
      );
    });
  });

  group('CompleteOnboardingRequested', () {
    test('should emit unauthenticated when onboarding completes', () {
      // Arrange
      when(
        () => mockCompleteOnboardingUseCase(),
      ).thenAnswer((_) async => Future.value());

      // Act
      authBloc.add(CompleteOnboardingRequested());

      // Assert
      expectLater(authBloc.stream, emits(AuthState.unauthenticated()));
    });
  });
}
