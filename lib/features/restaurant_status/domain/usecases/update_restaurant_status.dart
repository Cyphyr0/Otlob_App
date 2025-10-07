import '../entities/restaurant_status_type.dart';
import '../repositories/restaurant_status_repository.dart';

class UpdateRestaurantStatus {
  const UpdateRestaurantStatus(this._repository);

  final RestaurantStatusRepository _repository;

  Future<void> call({
    required String restaurantId,
    required RestaurantStatusType statusType,
    String? reason,
    DateTime? estimatedReopening,
    String? updatedBy,
  }) {
    return _repository.updateRestaurantStatus(
      restaurantId: restaurantId,
      statusType: statusType,
      reason: reason,
      estimatedReopening: estimatedReopening,
      updatedBy: updatedBy,
    );
  }
}