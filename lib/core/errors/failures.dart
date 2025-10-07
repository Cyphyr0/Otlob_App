abstract class Failure {

  const Failure({required this.message, this.error});
  final String message;
  final dynamic error;
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.error});
}

class ServerFailure extends Failure {

  const ServerFailure({required super.message, this.statusCode, super.error});
  final int? statusCode;
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.error});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.error});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = "Unauthorized access",
    super.error,
  });
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message, super.error});
}

class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.error});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.error});
}
