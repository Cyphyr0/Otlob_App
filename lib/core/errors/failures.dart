/// Base failure class for handling different types of failures in the app
abstract class Failure {
  const Failure(this.message, [this.code]);

  final String message;
  final String? code;
}

/// Network failure when API calls fail
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

/// Server failure when backend returns error
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

/// Cache failure when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

/// Validation failure for input validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

/// Unauthorized failure for authentication issues
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, [super.code]);
}

/// Location permission failure
class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure(super.message, [super.code]);
}

/// Location service failure
class LocationServiceFailure extends Failure {
  const LocationServiceFailure(super.message, [super.code]);
}

/// Payment failure for transaction errors
class PaymentFailure extends Failure {
  const PaymentFailure(super.message, [super.code]);
}

/// Authentication failure for auth operations
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}
