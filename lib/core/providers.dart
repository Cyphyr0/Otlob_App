import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otlob_app/core/config/app_config.dart';
import 'package:otlob_app/core/services/database.dart';
import 'package:otlob_app/core/services/service_locator.dart';
import 'package:otlob_app/core/services/unsplash_service.dart';
import 'package:otlob_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:otlob_app/features/auth/domain/repositories/auth_repository.dart';

export '../features/cart/presentation/providers/cart_provider.dart';
export '../features/favorites/presentation/providers/favorites_provider.dart';
export '../features/home/presentation/providers/home_provider.dart';
export '../features/auth/presentation/providers/auth_provider.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<FirebaseAuthRepository>();
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return dio;
});

final unsplashServiceProvider = Provider<UnsplashService>((ref) {
  final dio = ref.watch(dioProvider);
  return UnsplashService(dio, AppConfig.unsplashAccessKey);
});

final navigationIndexProvider = StateProvider<int>((ref) => 0);
