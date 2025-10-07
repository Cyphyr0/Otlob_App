import "package:get_it/get_it.dart";
import "../../features/auth/data/datasources/firebase_auth_datasource.dart";
import "../../features/auth/data/repositories/firebase_auth_repository.dart";
import "../../features/cart/data/repositories/firebase_cart_repository.dart";
import "../../features/cart/data/repositories/firebase_order_repository.dart";
import "../../features/home/data/repositories/firebase_home_repository.dart";
import "../../features/home/data/repositories/mock_home_repository.dart";
import "../../features/payment/data/repositories/firebase_payment_repository.dart";
import "../../features/tawseya/data/repositories/firebase_tawseya_repository.dart";
import "../../features/profile/data/datasources/firebase_profile_datasource.dart";
import "../../features/profile/data/repositories/firebase_profile_repository.dart";
import "../../features/profile/domain/repositories/profile_repository.dart";
import "firebase/firebase_auth_service.dart";
import "firebase/firebase_data_seeder.dart";
import "firebase/firebase_firestore_service.dart";
import "firebase/firebase_storage_service.dart";
import "unsplash_service.dart";
import "../config/app_config.dart";

final getIt = GetIt.instance;

void setupFirebaseServices() {
  // Firebase Services
  getIt.registerLazySingleton<FirebaseAuthService>(FirebaseAuthService.new);
  getIt.registerLazySingleton<FirebaseFirestoreService>(
    FirebaseFirestoreService.new,
  );
  getIt.registerLazySingleton<FirebaseStorageService>(
    FirebaseStorageService.new,
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
  getIt.registerLazySingleton<FirebaseOrderRepository>(
    () => FirebaseOrderRepository(getIt.get<FirebaseFirestoreService>()),
  );
  getIt.registerLazySingleton<FirebasePaymentRepository>(
    () => FirebasePaymentRepository(),
  );
  getIt.registerLazySingleton<FirebaseTawseyaRepository>(
    () => FirebaseTawseyaRepository(),
  );

  // Profile Services
  getIt.registerLazySingleton<FirebaseProfileDataSource>(
    () => FirebaseProfileDataSource(getIt.get<FirebaseFirestoreService>()),
  );
  getIt.registerLazySingleton<FirebaseProfileRepository>(
    () => FirebaseProfileRepository(getIt.get<FirebaseProfileDataSource>()),
  );

  // Firebase Data Seeder
  getIt.registerLazySingleton<FirebaseDataSeeder>(FirebaseDataSeeder.new);

  // TODO: Register other Firebase repositories as needed
}

void setupMockServices() {
  // Mock Repositories for development
  getIt.registerLazySingleton<MockHomeRepository>(MockHomeRepository.new);

  // TODO: Create mock auth and cart repositories when needed
}
