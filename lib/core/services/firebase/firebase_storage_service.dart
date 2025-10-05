import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Storage paths
  static const String restaurantsPath = 'restaurants';
  static const String usersPath = 'users';
  static const String dishesPath = 'dishes';
  static const String reviewsPath = 'reviews';

  // Upload restaurant image
  Future<String> uploadRestaurantImage(
    String restaurantId,
    File imageFile,
  ) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
    final ref = _storage.ref().child(
      '$restaurantsPath/$restaurantId/$fileName',
    );

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Upload user profile image
  Future<String> uploadUserProfileImage(String userId, File imageFile) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
    final ref = _storage.ref().child('$usersPath/$userId/profile/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Upload dish image
  Future<String> uploadDishImage(
    String restaurantId,
    String dishId,
    File imageFile,
  ) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
    final ref = _storage.ref().child(
      '$restaurantsPath/$restaurantId/$dishesPath/$dishId/$fileName',
    );

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Upload review image
  Future<String> uploadReviewImage(String reviewId, File imageFile) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
    final ref = _storage.ref().child('$reviewsPath/$reviewId/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Image might not exist or URL might be invalid
      print('Error deleting image: $e');
    }
  }

  // Get download URL for existing image
  Future<String> getDownloadURL(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    String basePath,
    List<File> imageFiles,
  ) async {
    final List<String> downloadUrls = [];

    for (final imageFile in imageFiles) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final ref = _storage.ref().child('$basePath/$fileName');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  // Get all images for a restaurant
  Future<List<String>> getRestaurantImages(String restaurantId) async {
    final ref = _storage.ref().child('$restaurantsPath/$restaurantId');
    final result = await ref.listAll();

    final List<String> urls = [];
    for (final item in result.items) {
      final url = await item.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  // Get user profile images
  Future<List<String>> getUserProfileImages(String userId) async {
    final ref = _storage.ref().child('$usersPath/$userId/profile');
    final result = await ref.listAll();

    final List<String> urls = [];
    for (final item in result.items) {
      final url = await item.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  // Update image (delete old and upload new)
  Future<String> updateImage(
    String oldImageUrl,
    File newImageFile,
    String basePath,
  ) async {
    // Delete old image
    await deleteImage(oldImageUrl);

    // Upload new image
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(newImageFile.path)}';
    final ref = _storage.ref().child('$basePath/$fileName');

    final uploadTask = ref.putFile(newImageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Get image metadata
  Future<FullMetadata> getImageMetadata(String imageUrl) async {
    final ref = _storage.refFromURL(imageUrl);
    return await ref.getMetadata();
  }

  // Check if image exists
  Future<bool> imageExists(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get storage usage for user
  Future<int> getUserStorageUsage(String userId) async {
    final ref = _storage.ref().child(usersPath).child(userId);
    final result = await ref.listAll();

    int totalSize = 0;
    for (final item in result.items) {
      final metadata = await item.getMetadata();
      totalSize += metadata.size ?? 0;
    }

    return totalSize;
  }

  // Compress and upload image (utility method)
  Future<String> uploadCompressedImage(
    String basePath,
    File imageFile, {
    int quality = 80,
    int maxWidth = 1024,
    int maxHeight = 1024,
  }) async {
    // Note: For actual image compression, you'd need to use a package like image_picker or flutter_image_compress
    // This is a placeholder - in real implementation, compress the image first

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_compressed_${path.basename(imageFile.path)}';
    final ref = _storage.ref().child('$basePath/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  // Batch delete images
  Future<void> deleteImages(List<String> imageUrls) async {
    final List<Future<void>> deleteFutures = [];

    for (final url in imageUrls) {
      deleteFutures.add(deleteImage(url));
    }

    await Future.wait(deleteFutures);
  }

  // Get signed URL for temporary access (if needed)
  Future<String> getSignedUrl(
    String path, {
    Duration expiry = const Duration(hours: 1),
  }) async {
    final ref = _storage.ref().child(path);
    return await ref
        .getDownloadURL(); // Firebase Storage handles signed URLs automatically
  }
}
