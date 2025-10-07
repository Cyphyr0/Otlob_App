import '../entities/restaurant_status.dart';
import '../entities/restaurant_status_type.dart';
import '../entities/working_hours.dart';

abstract class RestaurantStatusRepository {
  /// Get the current status for a restaurant
  Future<RestaurantStatus> getRestaurantStatus(String restaurantId);

  /// Update the status of a restaurant
  Future<void> updateRestaurantStatus({
    required String restaurantId,
    required RestaurantStatusType statusType,
    String? reason,
    DateTime? estimatedReopening,
    String? updatedBy,
  });

  /// Update working hours for a restaurant
  Future<void> updateWorkingHours({
    required String restaurantId,
    required WorkingHours workingHours,
  });

  /// Get status for multiple restaurants
  Future<Map<String, RestaurantStatus>> getMultipleRestaurantStatuses(
    List<String> restaurantIds,
  );

  /// Subscribe to real-time status updates for a restaurant
  Stream<RestaurantStatus> watchRestaurantStatus(String restaurantId);

  /// Subscribe to status updates for multiple restaurants
  Stream<Map<String, RestaurantStatus>> watchMultipleRestaurantStatuses(
    List<String> restaurantIds,
  );

  /// Check if a restaurant is currently open
  Future<bool> isRestaurantOpen(String restaurantId);

  /// Get restaurants that are currently open
  Future<List<String>> getCurrentlyOpenRestaurants();

  /// Get restaurants by status type
  Future<List<String>> getRestaurantsByStatusType(RestaurantStatusType statusType);

  /// Get restaurants that will open next
  Future<List<String>> getRestaurantsOpeningNext();

  /// Bulk update status for multiple restaurants
  Future<void> bulkUpdateRestaurantStatuses(
    Map<String, RestaurantStatusType> statusUpdates, {
    String? reason,
    String? updatedBy,
  });

  /// Get status update history for a restaurant
  Future<List<RestaurantStatus>> getStatusHistory(String restaurantId);

  /// Set temporary closure with automatic reopening
  Future<void> setTemporaryClosure({
    required String restaurantId,
    required RestaurantStatusType statusType,
    required DateTime estimatedReopening,
    String? reason,
    String? updatedBy,
  });

  /// Mark restaurant as permanently closed
  Future<void> markPermanentlyClosed({
    required String restaurantId,
    String? reason,
    String? updatedBy,
  });
}