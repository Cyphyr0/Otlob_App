/// Example integration of delivery area validation in restaurant detail screen
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/delivery_area_status.dart';
import '../../../../features/home/domain/entities/restaurant.dart';
import '../../../../features/location/domain/entities/location.dart';
import '../widgets/delivery_area_status_widget.dart';
import '../../domain/entities/delivery_area_validation.dart';

/// Example widget showing how to integrate delivery area validation
/// into a restaurant detail screen
class DeliveryAreaIntegrationExample extends StatefulWidget {
  const DeliveryAreaIntegrationExample({
    super.key,
    required this.restaurant,
    required this.userLocation,
    this.onValidationComplete,
  });

  final Restaurant restaurant;
  final Location userLocation;
  final Function(DeliveryAreaValidation)? onValidationComplete;

  @override
  State<DeliveryAreaIntegrationExample> createState() => _DeliveryAreaIntegrationExampleState();
}

class _DeliveryAreaIntegrationExampleState extends State<DeliveryAreaIntegrationExample> {
  DeliveryAreaValidation? _validation;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _validateDeliveryArea();
  }

  Future<void> _validateDeliveryArea() async {
    setState(() {
      _isValidating = true;
    });

    try {
      // In a real implementation, you would use the provider or service
      // For this example, we'll simulate the validation
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation logic
      final distance = _calculateDistance(
        widget.userLocation.latitude,
        widget.userLocation.longitude,
        widget.restaurant.latitude,
        widget.restaurant.longitude,
      );

      final isWithinArea = distance <= widget.restaurant.deliveryRadius;

      if (isWithinArea) {
        final validation = DeliveryAreaValidation.withinArea(
          restaurant: widget.restaurant,
          userLocation: widget.userLocation,
          distance: distance,
          deliveryFee: 15.0, // Example delivery fee
          estimatedDeliveryTime: 25, // Example delivery time
        );

        setState(() {
          _validation = validation;
        });

        widget.onValidationComplete?.call(validation);
      } else {
        final validation = DeliveryAreaValidation.outsideArea(
          restaurant: widget.restaurant,
          userLocation: widget.userLocation,
          distance: distance,
        );

        setState(() {
          _validation = validation;
        });

        widget.onValidationComplete?.call(validation);
      }
    } catch (e) {
      final validation = DeliveryAreaValidation.error(
        restaurant: widget.restaurant,
        message: 'Failed to validate delivery area',
      );

      setState(() {
        _validation = validation;
      });

      widget.onValidationComplete?.call(validation);
    } finally {
      setState(() {
        _isValidating = false;
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simplified distance calculation for example
    return ((lat2 - lat1).abs() + (lon2 - lon1).abs()) * 111; // Rough km conversion
  }

  @override
  Widget build(BuildContext context) {
    if (_isValidating) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: const Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: AppSpacing.sm),
            Text('Checking delivery area...'),
          ],
        ),
      );
    }

    if (_validation == null) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        child: const Text('Unable to validate delivery area'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Delivery area status widget
        DeliveryAreaStatusWidget(
          validation: _validation!,
          showDetails: true,
          onRetry: _validateDeliveryArea,
        ),

        SizedBox(height: AppSpacing.md),

        // Action button based on validation result
        if (_validation!.canOrder)
          ElevatedButton(
            onPressed: () {
              // Proceed with order
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proceeding with order...')),
              );
            },
            child: const Text('Order from Restaurant'),
          )
        else
          OutlinedButton(
            onPressed: null, // Disabled when cannot order
            child: Text(_getDisabledButtonText()),
          ),
      ],
    );
  }

  String _getDisabledButtonText() {
    switch (_validation!.status) {
      case DeliveryAreaStatus.outsideArea:
        return 'Cannot Deliver to Your Area';
      case DeliveryAreaStatus.permissionDenied:
        return 'Enable Location to Order';
      case DeliveryAreaStatus.locationDisabled:
        return 'Location Services Required';
      case DeliveryAreaStatus.determining:
        return 'Checking Location...';
      case DeliveryAreaStatus.error:
        return 'Try Again';
      case DeliveryAreaStatus.withinArea:
        return 'Order Available';
    }
  }
}