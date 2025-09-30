import 'package:otlob_app/core/services/database.dart';
import 'package:otlob_app/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AppDatabase _database;

  FirebaseAuthRepository(this._database);

  @override
  Future<void> saveUser(User user) async {
    await _database.into(_database.users).insert(user);
  }
}