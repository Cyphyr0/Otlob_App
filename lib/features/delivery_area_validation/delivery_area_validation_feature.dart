/// Delivery Area Validation Feature
/// Provides comprehensive delivery area validation system
/// to show users if they're in a restaurant's delivery area before ordering

export 'domain/entities/delivery_area_validation.dart';
export 'domain/entities/delivery_area_status.dart';
export 'domain/repositories/delivery_area_repository.dart';
export 'domain/usecases/validate_user_location.dart';
export 'domain/usecases/get_delivery_areas_for_restaurant.dart';
export 'domain/usecases/calculate_delivery_fee.dart';
export 'domain/services/delivery_area_validation_service.dart';

export 'presentation/widgets/delivery_area_status_widget.dart';
export 'presentation/widgets/delivery_area_map_widget.dart';
export 'presentation/widgets/delivery_area_alert_dialog.dart';

export 'data/repositories/firebase_delivery_area_repository.dart';
export 'data/models/delivery_area_model.dart';