/// Google Maps widget for displaying restaurants with location-based features
library;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../../../core/config/app_config.dart';
import '../../../home/domain/entities/restaurant.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/map_marker.dart' as app_marker;
import '../providers/map_provider.dart';

/// Main map widget for restaurant discovery
class RestaurantMapWidget extends ConsumerStatefulWidget {
  const RestaurantMapWidget({
    super.key,
    this.initialLocation,
    this.initialZoom = 15.0,
    this.onRestaurantTap,
    this.showUserLocation = true,
    this.showDeliveryAreas = false,
  });

  final Location? initialLocation;
  final double initialZoom;
  final Function(Restaurant)? onRestaurantTap;
  final bool showUserLocation;
  final bool showDeliveryAreas;

  @override
  ConsumerState<RestaurantMapWidget> createState() => _RestaurantMapWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Location?>('initialLocation', initialLocation));
    properties.add(DoubleProperty('initialZoom', initialZoom));
    properties.add(ObjectFlagProperty<Function(Restaurant p1)?>.has('onRestaurantTap', onRestaurantTap));
    properties.add(DiagnosticsProperty<bool>('showUserLocation', showUserLocation));
    properties.add(DiagnosticsProperty<bool>('showDeliveryAreas', showDeliveryAreas));
  }
}

class _RestaurantMapWidgetState extends ConsumerState<RestaurantMapWidget> {
  gmaps.GoogleMapController? _mapController;
  final Set<gmaps.Marker> _markers = {};
  final Set<gmaps.Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: widget.initialLocation != null
            ? gmaps.LatLng(widget.initialLocation!.latitude, widget.initialLocation!.longitude)
            : const gmaps.LatLng(30.0444, 31.2357), // Default to Cairo
        zoom: widget.initialZoom,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        ref.read(mapProvider.notifier).setMapController(controller);
        _onMapCreated();
      },
      markers: _markers,
      circles: _circles,
      myLocationEnabled: widget.showUserLocation,
      myLocationButtonEnabled: widget.showUserLocation,
      zoomControlsEnabled: true,
      compassEnabled: true,
      mapToolbarEnabled: false,
      onCameraMove: _onCameraMove,
      onTap: _onMapTap,
    );
  }

  /// Initialize the map with restaurants and user location
  Future<void> _initializeMap() async {
    final mapNotifier = ref.read(mapProvider.notifier);

    // Initialize map with current location if available
    if (widget.initialLocation == null) {
      await mapNotifier.initializeMap();
    } else {
      await mapNotifier.loadRestaurantsInRadius(
        center: widget.initialLocation!,
        radiusKm: 5, // Default 5km radius
      );
    }

    _updateMarkers();
  }

  /// Handle map creation
  void _onMapCreated() {
    _updateMarkers();
    if (widget.showDeliveryAreas) {
      _updateDeliveryAreas();
    }
  }

  /// Handle camera movement to load restaurants in new viewport
  void _onCameraMove(gmaps.CameraPosition position) {
    // Debounce camera movements to avoid excessive API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadRestaurantsInViewport(position);
      }
    });
  }

  /// Handle map tap
  void _onMapTap(gmaps.LatLng position) {
    final mapNotifier = ref.read(mapProvider.notifier);

    // Handle manual location selection if in selection mode
    if (ref.read(mapProvider).isManualLocationSelectionMode) {
      final location = Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      mapNotifier.selectLocationFromMap(location);
    }
  }

  /// Load restaurants in current viewport
  void _loadRestaurantsInViewport(gmaps.CameraPosition position) {
    final bounds = _getVisibleBounds(position);
    if (bounds != null) {
      ref.read(mapProvider.notifier).loadRestaurantsInBounds(
        northeast: Location(
          latitude: bounds.northeast.latitude,
          longitude: bounds.northeast.longitude,
        ),
        southwest: Location(
          latitude: bounds.southwest.latitude,
          longitude: bounds.southwest.longitude,
        ),
      );
    }
  }

  /// Update map markers based on current state
  void _updateMarkers() {
    final mapState = ref.watch(mapProvider);

    setState(() {
      _markers.clear();

      // Add restaurant markers
      for (final marker in mapState.markers) {
        _markers.add(_createGoogleMarker(marker));
      }

      // Add user location marker if available
      if (mapState.currentLocation != null) {
        _markers.add(
          gmaps.Marker(
            markerId: const gmaps.MarkerId('user_location'),
            position: gmaps.LatLng(
              mapState.currentLocation!.latitude,
              mapState.currentLocation!.longitude,
            ),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueBlue),
            infoWindow: const gmaps.InfoWindow(title: 'Your Location'),
          ),
        );
      }
    });
  }

  /// Update delivery area circles
  void _updateDeliveryAreas() {
    final mapState = ref.watch(mapProvider);

    setState(() {
      _circles.clear();

      if (widget.showDeliveryAreas) {
        for (final restaurant in mapState.restaurants) {
          _circles.add(
            gmaps.Circle(
              circleId: gmaps.CircleId('delivery_${restaurant.id}'),
              center: gmaps.LatLng(restaurant.latitude, restaurant.longitude),
              radius: restaurant.deliveryRadius * 1000, // Convert km to meters
              fillColor: Colors.green.withOpacity(0.2),
              strokeColor: Colors.green,
              strokeWidth: 2,
            ),
          );
        }
      }
    });
  }

  /// Create Google Maps marker from app MapMarker
  gmaps.Marker _createGoogleMarker(app_marker.MapMarker marker) => gmaps.Marker(
      markerId: gmaps.MarkerId(marker.id),
      position: gmaps.LatLng(marker.position.latitude, marker.position.longitude),
      icon: _getMarkerIcon(marker.markerType),
      infoWindow: gmaps.InfoWindow(
        title: marker.title,
        snippet: marker.snippet,
        onTap: () {
          if (marker.restaurant != null && widget.onRestaurantTap != null) {
            widget.onRestaurantTap!(marker.restaurant!);
          }
        },
      ),
      onTap: marker.onTap,
    );

  /// Get appropriate marker icon based on type
  gmaps.BitmapDescriptor _getMarkerIcon(app_marker.MarkerType type) {
    switch (type) {
      case app_marker.MarkerType.restaurant:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueRed);
      case app_marker.MarkerType.userLocation:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueBlue);
      case app_marker.MarkerType.deliveryArea:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueGreen);
      case app_marker.MarkerType.favorite:
        return gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.hueRose);
    }
  }

  /// Get visible bounds from camera position
  gmaps.LatLngBounds? _getVisibleBounds(gmaps.CameraPosition position) {
    if (_mapController == null) return null;

    // This is a simplified calculation
    // In a real implementation, you'd calculate the actual viewport bounds
    const offset = 0.01; // Approximate offset for zoom level 15
    return gmaps.LatLngBounds(
      northeast: gmaps.LatLng(
        position.target.latitude + offset,
        position.target.longitude + offset,
      ),
      southwest: gmaps.LatLng(
        position.target.latitude - offset,
        position.target.longitude - offset,
      ),
    );
  }

  /// Public method to animate camera to location
  void animateToLocation(Location location, {double zoom = 15.0}) {
    _mapController?.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: gmaps.LatLng(location.latitude, location.longitude),
          zoom: zoom,
        ),
      ),
    );
  }

  /// Public method to show restaurant info window
  void showRestaurantInfo(Restaurant restaurant) {
    // Find and show the marker's info window
    final markerId = 'restaurant_${restaurant.id}';
    // Implementation would depend on Google Maps API capabilities
  }
}

/// Floating action button for location-related actions
class MapActionButton extends ConsumerWidget {
  const MapActionButton({
    required this.icon, required this.onPressed, super.key,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) => FloatingActionButton(
      mini: true,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(StringProperty('tooltip', tooltip));
  }
}

/// Location filter controls overlay
class MapFilterControls extends ConsumerWidget {
  const MapFilterControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Radius filter
          Row(
            children: [
              const Text('Radius: '),
              Text('${mapState.selectedRadius.toStringAsFixed(1)} km'),
              Expanded(
                child: Slider(
                  value: mapState.selectedRadius,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  onChanged: (value) {
                    ref.read(mapProvider.notifier).updateFilters(radius: value);
                  },
                ),
              ),
            ],
          ),

          // Delivery areas toggle
          SwitchListTile(
            title: const Text('Show Delivery Areas'),
            value: mapState.showDeliveryAreas,
            onChanged: (value) {
              ref.read(mapProvider.notifier).toggleDeliveryAreas();
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

/// Restaurant info card for map overlay
class RestaurantMapCard extends StatelessWidget {
  const RestaurantMapCard({
    required this.restaurant, super.key,
    this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Restaurant image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: restaurant.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          restaurant.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.restaurant,
                        color: Colors.grey[400],
                      ),
              ),

              const SizedBox(width: 12),

              // Restaurant details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      restaurant.cuisine,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(
                          '${restaurant.rating}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${restaurant.distance.toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite indicator
              if (restaurant.isFavorite)
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Restaurant>('restaurant', restaurant));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}