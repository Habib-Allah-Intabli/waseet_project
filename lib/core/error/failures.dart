import 'exceptions.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع']);
}

Failure handleException(Object e) {
  if (e is ServerException) {
    return ServerFailure(e.message);
  } else if (e is NetworkException) {
    return NetworkFailure(e.message);
  } else if (e is CacheException) {
    return CacheFailure(e.message);
  } else if (e is AuthException) {
    return AuthFailure(e.message);
  } else if (e is ValidationException) {
    return ValidationFailure(e.message);
  }

  String message = e.toString();
  if (message.startsWith('Exception: ')) {
    message = message.substring('Exception: '.length);
  }
  return UnexpectedFailure(message);
}
