import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otlob_app/core/services/database.dart';
import 'package:otlob_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:otlob_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:otlob_app/features/auth/domain/repositories/auth_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = FirebaseAuthDataSource();
  return FirebaseAuthRepository(dataSource);
});

final navigationIndexProvider = StateProvider<int>((ref) => 0);
