# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-05-23

### Added
- Standardized Clean Architecture custom exceptions: `ServerException`, `CacheException`, `NetworkException`, `AuthException`, and `ValidationException` in `core/error/exceptions.dart`.
- Domain-level UI-safe failures: `ServerFailure`, `CacheFailure`, `NetworkFailure`, `AuthFailure`, `ValidationFailure`, and `UnexpectedFailure` in `core/error/failures.dart`.
- Standardized error helper function `handleException(Object e)` in `core/error/failures.dart` to centrally handle data-source exceptions.
- Added explicit dependency `intl: ^0.20.2` to `pubspec.yaml` to ensure build environment stability.
- Created `integration_test/auth_integration_test.dart` for E2E flow testing.

### Fixed
- Updated all repository implementations to catch raw errors and return clean domain `Failure` instances using `handleException(e)`.
- Fixed `AuthBloc` starting state to emit `AuthState.loading()` before verifying saved sessions.
- Added `registerFallbackValue` in `auth_bloc_test.dart` for mocktail setup, fixing unit test compiler and execution errors.
- Resolved test runner failures by moving E2E tests from `test/` folder to `integration_test/` directory.
- Resolved unit test suite errors, achieving 100% test success.

### Improved
- Completely redesigned `README.md` to describe the Clean Architecture layout, directory structure, setup instructions, and testing strategies.

## [1.0.0] - 2026-05-23

### Added
- Initial codebase upload containing core setup, auth feature, home feature, bookings feature, favorites feature, and trips feature.
- Multi-bloc configuration supporting localization and theme switches.
