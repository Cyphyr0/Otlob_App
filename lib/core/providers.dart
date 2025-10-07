import "package:dio/dio.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "config/app_config.dart";
import "services/database.dart";
import "services/service_locator.dart";
import "services/unsplash_service.dart";
import "services/firebase/firebase_firestore_service.dart";
import "../features/auth/data/repositories/firebase_auth_repository.dart";
import "../features/auth/domain/repositories/auth_repository.dart";

export "../features/cart/presentation/providers/cart_provider.dart";
export "../features/favorites/presentation/providers/favorites_provider.dart";
export "../features/home/presentation/providers/home_provider.dart";
export "../features/auth/presentation/providers/auth_provider.dart";

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final authRepositoryProvider = Provider<AuthRepository>((ref) => getIt<FirebaseAuthRepository>());

final firestoreServiceProvider = Provider<FirebaseFirestoreService>((ref) => getIt<FirebaseFirestoreService>());

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final dioProvider = Provider<Dio>((ref) {
  var dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  return dio;
});

final unsplashServiceProvider = Provider<UnsplashService>((ref) {
  var dio = ref.watch(dioProvider);
  return UnsplashService(dio, AppConfig.unsplashAccessKey);
});

final navigationIndexProvider = StateProvider<int>((ref) => 0);
