import 'package:otlob_app/core/services/database.dart';

abstract class AuthRepository {
  Future<void> saveUser(User user);
}