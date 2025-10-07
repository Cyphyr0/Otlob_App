import 'package:get_it/get_it.dart';
import 'package:otlob_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:otlob_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:otlob_app/features/cart/data/repositories/firebase_cart_repository.dart';
import 'package:otlob_app/features/home/data/repositories/firebase_home_repository.dart';
import 'package:otlob_app/features/home/data/repositories/mock_home_repository.dart';
import 'package:otlob_app/core/services/firebase/firebase_auth_service.dart';
import 'package:otlob_app/core/services/firebase/firebase_data_seeder.dart';
import 'package:otlob_app/core/services/firebase/firebase_firestore_service.dart';
import 'package:otlob_app/core/services/firebase/firebase_storage_service.dart';
import 'package:otlob_app/core/services/unsplash_service.dart';
import 'package:otlob_app/core/config/app_config.dart';

final getIt = GetIt.instance;

void setupFirebaseServices() {
  // Firebase Services
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<FirebaseFirestoreService>(
    () => FirebaseFirestoreService(),
  );
  getIt.registerLazySingleton<FirebaseStorageService>(
    () => FirebaseStorageService(),
  );

  // External Services
  getIt.registerLazySingleton<UnsplashService>(
    () => UnsplashService(
      getIt.get(), // Dio instance
      AppConfig.unsplashAccessKey,
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(getIt.get<FirebaseAuthService>()),
  );

  // Firebase Repositories
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepository(getIt.get<FirebaseAuthDataSource>()),
  );
  getIt.registerLazySingleton<FirebaseHomeRepository>(
    () => FirebaseHomeRepository(getIt.get<FirebaseFirestoreService>()),
  );
  getIt.registerLazySingleton<FirebaseCartRepository>(
    () => FirebaseCartRepository(getIt.get<FirebaseFirestoreService>()),
  );

  // Firebase Data Seeder
  getIt.registerLazySingleton<FirebaseDataSeeder>(() => FirebaseDataSeeder());

  // TODO: Register other Firebase repositories as needed
}

void setupMockServices() {
  // Mock Repositories for development
  getIt.registerLazySingleton<MockHomeRepository>(() => MockHomeRepository());

  // TODO: Create mock auth and cart repositories when needed
}
