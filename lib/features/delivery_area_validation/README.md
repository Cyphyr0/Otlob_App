# Delivery Area Validation System

A comprehensive delivery area validation system that shows users if they're in a restaurant's delivery area before ordering, preventing order cancellations and improving user experience.

## Features

- ✅ **Real-time Location Validation**: Check if user location is within restaurant delivery areas
- ✅ **Visual Status Indicators**: Clear visual feedback for delivery availability
- ✅ **Distance Calculation**: Accurate distance calculation using Haversine formula
- ✅ **Delivery Fee Calculation**: Dynamic delivery fee based on distance
- ✅ **Estimated Delivery Time**: Time estimation based on distance and restaurant factors
- ✅ **Error Handling**: Comprehensive error handling for location permissions and services
- ✅ **Caching**: Optional caching for improved performance
- ✅ **Multiple Restaurant Support**: Validate multiple restaurants simultaneously

## Architecture

### Core Components

1. **Entities**
   - `DeliveryAreaStatus` - Enumeration of validation states
   - `DeliveryAreaValidation` - Validation result with details

2. **Repositories**
   - `DeliveryAreaRepository` - Abstract interface for data operations
   - `FirebaseDeliveryAreaRepository` - Firebase implementation

3. **Services**
   - `DeliveryAreaValidationService` - Core business logic service

4. **Use Cases**
   - `ValidateUserLocation` - Main validation use case

5. **UI Components**
   - `DeliveryAreaStatusWidget` - Visual status indicator
   - `DeliveryAreaIntegrationExample` - Integration example

## Usage

### Basic Integration

```dart
import 'package:otlob_app/features/delivery_area_validation/delivery_area_validation_feature.dart';

// 1. Create validation service
final validationService = DeliveryAreaValidationService(
  FirebaseDeliveryAreaRepository(firestoreService),
);

// 2. Validate user location for restaurant
final validation = await validationService.validateUserLocation(
  userLocation: userLocation,
  restaurant: restaurant,
);

// 3. Check if user can order
if (validation.canOrder) {
  // Show delivery details
  print('Distance: ${validation.formattedDistance}');
  print('Delivery Fee: ${validation.formattedDeliveryFee}');
  print('Delivery Time: ${validation.formattedDeliveryTime}');
} else {
  // Show why user cannot order
  print('Status: ${validation.status.displayName}');
  print('Message: ${validation.message}');
}
```

### Using the Status Widget

```dart
// In your restaurant detail screen
DeliveryAreaStatusWidget(
  validation: validation,
  showDetails: true,
  onRetry: () => _retryValidation(),
)
```

### Provider Integration

```dart
// In your widget
final validationProvider = DeliveryAreaValidationProvider(
  validationService: validationService,
  repository: repository,
);

// Watch validation state
final state = ref.watch(deliveryAreaValidationProvider);

// Validate restaurant
await ref.read(deliveryAreaValidationProvider.notifier)
    .validateRestaurant(
      userLocation: userLocation,
      restaurant: restaurant,
    );
```

## Status Types

| Status | Description | Can Order | Color |
|--------|-------------|-----------|-------|
| `withinArea` | User is within delivery area | ✅ Yes | Green |
| `outsideArea` | User is outside delivery area | ❌ No | Red |
| `permissionDenied` | Location permission denied | ❌ No | Orange |
| `locationDisabled` | Location services disabled | ❌ No | Orange |
| `determining` | Checking location | ❌ No | Blue |
| `error` | Validation error | ❌ No | Orange |

## Integration Points

### 1. Restaurant Detail Screen
- Show delivery area status prominently
- Display delivery fee and estimated time
- Disable/enable order button based on validation

### 2. Cart/Checkout Flow
- Validate delivery area before allowing checkout
- Show delivery fee in order summary
- Prevent order submission if outside area

### 3. Home Screen
- Filter restaurants by delivery availability
- Show delivery status badges on restaurant cards

### 4. Map Screen
- Visualize delivery areas on map
- Show available restaurants based on location

## Configuration

### Delivery Fee Calculation
```dart
// Base fee + distance-based fee
const baseFee = 10.0; // EGP
const perKmFee = 3.0; // EGP per km

deliveryFee = baseFee + (distance * perKmFee);
```

### Delivery Time Calculation
```dart
// Base time + distance-based time
const baseTime = 15; // minutes
const perKmTime = 3; // minutes per km

deliveryTime = baseTime + (distance * perKmTime).round();
```

## Error Handling

The system handles various error scenarios:

1. **Location Permission Denied**
   - Shows clear message to enable location
   - Provides actionable guidance

2. **Location Services Disabled**
   - Prompts user to enable location services
   - Explains why location is needed

3. **Network/Connectivity Issues**
   - Graceful fallback to cached data
   - Retry mechanisms for failed requests

4. **Invalid Restaurant Data**
   - Validates restaurant coordinates
   - Handles missing delivery radius

## Performance Considerations

- **Caching**: Optional caching of validation results
- **Batch Validation**: Validate multiple restaurants efficiently
- **Location Updates**: Debounced location updates to avoid excessive API calls
- **Background Processing**: Non-blocking validation operations

## Testing

The system includes comprehensive testing support:

- Unit tests for validation logic
- Widget tests for UI components
- Integration tests for repository operations
- Mock services for testing without location permissions

## Future Enhancements

- **Polygon Support**: Support for complex delivery area shapes
- **Real-time Updates**: Live delivery area changes
- **Advanced Routing**: Optimal delivery route calculation
- **Predictive Analytics**: ML-based delivery time prediction
- **Multi-language Support**: Localized status messages

## Dependencies

- Flutter 3.0+
- Geolocator (for location services)
- Google Maps (for visualization)
- Firebase Firestore (for restaurant data)

## Contributing

When extending the delivery area validation system:

1. Follow the existing architecture patterns
2. Add comprehensive error handling
3. Include unit tests for new functionality
4. Update documentation for API changes
5. Consider performance implications

## Support

For issues and questions:
- Check existing documentation
- Review integration examples
- Test with provided mock services
- Report issues with detailed reproduction steps