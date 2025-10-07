import 'dart:async';
import '../../domain/entities/restaurant_status.dart';
import '../../domain/entities/restaurant_status_type.dart';
import '../../domain/entities/working_hours.dart';
import '../../domain/repositories/restaurant_status_repository.dart';

class RestaurantStatusService {
  RestaurantStatusService(this._repository) {
    _startPeriodicStatusCheck();
  }

  final RestaurantStatusRepository _repository;

  // Cache for restaurant statuses
  final Map<String, RestaurantStatus> _statusCache = {};
  final Map<String, Timer> _statusTimers = {};

  // Stream controllers for real-time updates
  final Map<String, StreamController<RestaurantStatus>> _statusControllers = {};

  /// Get cached status or fetch from repository
  Future<RestaurantStatus> getRestaurantStatus(String restaurantId) async {
    // Return cached status if available and not expired
    final cachedStatus = _statusCache[restaurantId];
    if (cachedStatus != null && !_isStatusExpired(cachedStatus)) {
      return cachedStatus;
    }

    // Fetch fresh status from repository
    final status = await _repository.getRestaurantStatus(restaurantId);
    _statusCache[restaurantId] = status;

    return status;
  }

  /// Check if a restaurant is currently open
  Future<bool> isRestaurantOpen(String restaurantId) async {
    final status = await getRestaurantStatus(restaurantId);
    return status.isCurrentlyOpen;
  }

  /// Get restaurants that are currently open
  Future<List<String>> getCurrentlyOpenRestaurants() async {
    return _repository.getCurrentlyOpenRestaurants();
  }

  /// Get restaurants by status type
  Future<List<String>> getRestaurantsByStatusType(RestaurantStatusType statusType) async {
    return _repository.getRestaurantsByStatusType(statusType);
  }

  /// Update restaurant status
  Future<void> updateRestaurantStatus({
    required String restaurantId,
    required RestaurantStatusType statusType,
    String? reason,
    DateTime? estimatedReopening,
    String? updatedBy,
  }) async {
    await _repository.updateRestaurantStatus(
      restaurantId: restaurantId,
      statusType: statusType,
      reason: reason,
      estimatedReopening: estimatedReopening,
      updatedBy: updatedBy,
    );

    // Clear cache for this restaurant
    _statusCache.remove(restaurantId);

    // Notify listeners
    _notifyStatusUpdate(restaurantId);
  }

  /// Update working hours for a restaurant
  Future<void> updateWorkingHours({
    required String restaurantId,
    required WorkingHours workingHours,
  }) async {
    await _repository.updateWorkingHours(
      restaurantId: restaurantId,
      workingHours: workingHours,
    );

    // Clear cache for this restaurant
    _statusCache.remove(restaurantId);

    // Notify listeners
    _notifyStatusUpdate(restaurantId);
  }

  /// Subscribe to real-time status updates for a restaurant
  Stream<RestaurantStatus> watchRestaurantStatus(String restaurantId) {
    // Return existing stream if already created
    if (_statusControllers.containsKey(restaurantId)) {
      return _statusControllers[restaurantId]!.stream;
    }

    // Create new stream controller
    final controller = StreamController<RestaurantStatus>.broadcast();
    _statusControllers[restaurantId] = controller;

    // Listen to repository stream and forward updates
    final repositoryStream = _repository.watchRestaurantStatus(restaurantId);
    repositoryStream.listen((status) {
      _statusCache[restaurantId] = status;
      controller.add(status);
    });

    return controller.stream;
  }

  /// Subscribe to status updates for multiple restaurants
  Stream<Map<String, RestaurantStatus>> watchMultipleRestaurantStatuses(
    List<String> restaurantIds,
  ) {
    final controller = StreamController<Map<String, RestaurantStatus>>.broadcast();

    // Subscribe to each restaurant individually
    final subscriptions = <String, StreamSubscription>{};

    for (final restaurantId in restaurantIds) {
      final subscription = watchRestaurantStatus(restaurantId).listen((status) {
        // Update the map and emit new state
        final updatedStatuses = Map<String, RestaurantStatus>.from(_statusCache);
        controller.add(updatedStatuses);
      });
      subscriptions[restaurantId] = subscription;
    }

    return controller.stream;
  }

  /// Set temporary closure with automatic reopening
  Future<void> setTemporaryClosure({
    required String restaurantId,
    required RestaurantStatusType statusType,
    required DateTime estimatedReopening,
    String? reason,
    String? updatedBy,
  }) async {
    await _repository.setTemporaryClosure(
      restaurantId: restaurantId,
      statusType: statusType,
      estimatedReopening: estimatedReopening,
      reason: reason,
      updatedBy: updatedBy,
    );

    // Schedule automatic reopening
    _scheduleAutomaticReopening(restaurantId, estimatedReopening);

    // Clear cache and notify
    _statusCache.remove(restaurantId);
    _notifyStatusUpdate(restaurantId);
  }

  /// Mark restaurant as permanently closed
  Future<void> markPermanentlyClosed({
    required String restaurantId,
    String? reason,
    String? updatedBy,
  }) async {
    await _repository.markPermanentlyClosed(
      restaurantId: restaurantId,
      reason: reason,
      updatedBy: updatedBy,
    );

    // Clear cache and cancel any scheduled timers
    _statusCache.remove(restaurantId);
    _statusTimers.remove(restaurantId)?.cancel();

    // Notify listeners
    _notifyStatusUpdate(restaurantId);
  }

  /// Get status update history for a restaurant
  Future<List<RestaurantStatus>> getStatusHistory(String restaurantId) async {
    return _repository.getStatusHistory(restaurantId);
  }

  /// Clean up resources
  void dispose() {
    // Cancel all timers
    for (final timer in _statusTimers.values) {
      timer.cancel();
    }
    _statusTimers.clear();

    // Close all stream controllers
    for (final controller in _statusControllers.values) {
      controller.close();
    }
    _statusControllers.clear();

    // Clear cache
    _statusCache.clear();
  }

  // Private methods

  void _startPeriodicStatusCheck() {
    // Check for status updates every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkForStatusUpdates();
    });
  }

  void _checkForStatusUpdates() {
    final now = DateTime.now();

    // Check if any cached statuses need updating based on time
    for (final entry in _statusCache.entries.toList()) {
      final restaurantId = entry.key;
      final status = entry.value;

      // If restaurant was temporarily closed and reopening time has passed
      if (status.statusType.isTemporarilyUnavailable &&
          status.estimatedReopening != null &&
          now.isAfter(status.estimatedReopening!)) {
        // Automatically reopen the restaurant
        _autoReopenRestaurant(restaurantId);
      }
    }
  }

  void _scheduleAutomaticReopening(String restaurantId, DateTime reopeningTime) {
    // Cancel existing timer if any
    _statusTimers[restaurantId]?.cancel();

    final delay = reopeningTime.difference(DateTime.now());
    if (delay.isNegative) return; // Already past reopening time

    _statusTimers[restaurantId] = Timer(delay, () {
      _autoReopenRestaurant(restaurantId);
    });
  }

  void _autoReopenRestaurant(String restaurantId) async {
    try {
      await updateRestaurantStatus(
        restaurantId: restaurantId,
        statusType: RestaurantStatusType.open,
        reason: 'Automatically reopened after temporary closure',
      );

      // Cancel the timer
      _statusTimers.remove(restaurantId)?.cancel();
    } catch (e) {
      // Handle error silently or log it
      print('Failed to auto-reopen restaurant $restaurantId: $e');
    }
  }

  void _notifyStatusUpdate(String restaurantId) {
    final controller = _statusControllers[restaurantId];
    if (controller != null && !controller.isClosed) {
      // Fetch fresh status and notify listeners
      getRestaurantStatus(restaurantId).then((status) {
        if (!controller.isClosed) {
          controller.add(status);
        }
      });
    }
  }

  bool _isStatusExpired(RestaurantStatus status) {
    if (status.lastUpdated == null) return true;

    // Consider status expired after 5 minutes
    final expiryTime = status.lastUpdated!.add(const Duration(minutes: 5));
    return DateTime.now().isAfter(expiryTime);
  }
}