/// Delivery area visualization component for displaying restaurant coverage areas
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../domain/entities/location.dart';
import '../../domain/entities/map_marker.dart';

/// Widget for visualizing delivery areas on the map
class DeliveryAreaVisualization extends StatefulWidget {
  const DeliveryAreaVisualization({
    super.key,
    required this.deliveryAreas,
    this.showLabels = true,
    this.fillOpacity = 0.2,
    this.strokeWidth = 2.0,
    this.onAreaTap,
  });

  final List<DeliveryArea> deliveryAreas;
  final bool showLabels;
  final double fillOpacity;
  final double strokeWidth;
  final Function(DeliveryArea)? onAreaTap;

  @override
  State<DeliveryAreaVisualization> createState() => _DeliveryAreaVisualizationState();
}

class _DeliveryAreaVisualizationState extends State<DeliveryAreaVisualization> {
  final Set<gmaps.Circle> _circles = {};
  final Set<gmaps.Marker> _areaMarkers = {};

  @override
  void didUpdateWidget(DeliveryAreaVisualization oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveryAreas != widget.deliveryAreas) {
      _updateVisualization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // This widget manages the visualization data
  }

  /// Get the circles for Google Maps
  Set<gmaps.Circle> getCircles() {
    _updateVisualization();
    return _circles;
  }

  /// Get the area markers for Google Maps
  Set<gmaps.Marker> getAreaMarkers() {
    _updateVisualization();
    return _areaMarkers;
  }

  /// Update the visualization based on delivery areas
  void _updateVisualization() {
    _circles.clear();
    _areaMarkers.clear();

    for (final area in widget.deliveryAreas) {
      // Add circle for delivery area
      _circles.add(
        gmaps.Circle(
          circleId: gmaps.CircleId('delivery_area_${area.center.latitude}_${area.center.longitude}'),
          center: gmaps.LatLng(area.center.latitude, area.center.longitude),
          radius: area.radius * 1000, // Convert km to meters
          fillColor: _getAreaColor(area).withOpacity(widget.fillOpacity),
          strokeColor: _getAreaColor(area),
          strokeWidth: widget.strokeWidth,
          onTap: () {
            if (widget.onAreaTap != null) {
              widget.onAreaTap!(area);
            }
          },
        ),
      );

      // Add marker for area center if labels are enabled
      if (widget.showLabels) {
        _areaMarkers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId('delivery_center_${area.center.latitude}_${area.center.longitude}'),
            position: gmaps.LatLng(area.center.latitude, area.center.longitude),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueGreen),
            infoWindow: gmaps.InfoWindow(
              title: area.name ?? 'Delivery Area',
              snippet: '${area.radius} km radius${area.description != null ? '\n${area.description}' : ''}',
            ),
          ),
        );
      }
    }
  }

  /// Get color for delivery area based on radius
  Color _getAreaColor(DeliveryArea area) {
    // Different colors based on delivery radius
    if (area.radius <= 2.0) {
      return Colors.green; // Small area - fast delivery
    } else if (area.radius <= 5.0) {
      return Colors.orange; // Medium area
    } else {
      return Colors.red; // Large area - extended delivery
    }
  }
}

/// Widget for displaying delivery area information
class DeliveryAreaInfoCard extends StatelessWidget {
  const DeliveryAreaInfoCard({
    super.key,
    required this.area,
    this.onTap,
  });

  final DeliveryArea area;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: _getAreaColor(area),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      area.name ?? 'Delivery Area',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAreaColor(area).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getAreaColor(area),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${area.radius} km',
                      style: TextStyle(
                        color: _getAreaColor(area),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              if (area.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  area.description!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Location info
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      area.center.address ?? '${area.center.latitude}, ${area.center.longitude}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get color for delivery area based on radius
  Color _getAreaColor(DeliveryArea area) {
    if (area.radius <= 2.0) {
      return Colors.green;
    } else if (area.radius <= 5.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

/// Legend for delivery area visualization
class DeliveryAreaLegend extends StatelessWidget {
  const DeliveryAreaLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Areas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          // Legend items
          _LegendItem(
            color: Colors.green,
            text: 'Fast Delivery (≤2 km)',
            radius: 2.0,
          ),
          _LegendItem(
            color: Colors.orange,
            text: 'Standard Delivery (2-5 km)',
            radius: 3.5,
          ),
          _LegendItem(
            color: Colors.red,
            text: 'Extended Delivery (>5 km)',
            radius: 7.0,
          ),
        ],
      ),
    );
  }
}

/// Legend item widget
class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
    required this.radius,
  });

  final Color color;
  final String text;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// Utility class for delivery area calculations
class DeliveryAreaUtils {
  /// Check if a location is within any of the provided delivery areas
  static bool isLocationInAnyDeliveryArea(
    Location location,
    List<DeliveryArea> deliveryAreas,
  ) {
    return deliveryAreas.any((area) => area.containsLocation(location));
  }

  /// Get the delivery area that contains a specific location
  static DeliveryArea? getDeliveryAreaForLocation(
    Location location,
    List<DeliveryArea> deliveryAreas,
  ) {
    try {
      return deliveryAreas.firstWhere((area) => area.containsLocation(location));
    } catch (e) {
      return null;
    }
  }

  /// Calculate the total coverage area in square kilometers
  static double calculateTotalCoverageArea(List<DeliveryArea> deliveryAreas) {
    // Simplified calculation - in reality, you'd need to handle overlapping areas
    return deliveryAreas.fold(0.0, (total, area) {
      // Area of circle = π * r²
      return total + (3.14159 * area.radius * area.radius);
    });
  }

  /// Find the best delivery area for a location (closest center)
  static DeliveryArea? findBestDeliveryArea(
    Location location,
    List<DeliveryArea> deliveryAreas,
  ) {
    DeliveryArea? bestArea;
    double shortestDistance = double.infinity;

    for (final area in deliveryAreas) {
      final distance = _calculateDistance(location, area.center);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        bestArea = area;
      }
    }

    return bestArea;
  }

  /// Calculate distance between two locations using Haversine formula
  static double _calculateDistance(Location from, Location to) {
    const earthRadius = 6371; // Earth's radius in kilometers

    final lat1Rad = from.latitude * (3.14159 / 180);
    final lon1Rad = from.longitude * (3.14159 / 180);
    final lat2Rad = to.latitude * (3.14159 / 180);
    final lon2Rad = to.longitude * (3.14159 / 180);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}