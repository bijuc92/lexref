sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Check your connection.']);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class RateLimitFailure extends AuthFailure {
  const RateLimitFailure()
      : super('Too many requests. Please wait a moment and try again.');
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A local database error occurred.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
