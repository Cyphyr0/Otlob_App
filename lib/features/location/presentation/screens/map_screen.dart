/// Map screen for restaurant discovery with location-based features
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/map_provider.dart';
import '../widgets/restaurant_map_widget.dart';
import '../widgets/location_filter_widget.dart';
import '../widgets/delivery_area_visualization.dart';
import '../widgets/location_selection_widget.dart';
import '../../domain/entities/location.dart';
import '../../../home/domain/entities/restaurant.dart';

/// Main map screen for restaurant discovery
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final GlobalKey _mapKey = GlobalKey();
  bool _showFilters = true;
  bool _showDeliveryAreas = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Main map widget
          RestaurantMapWidget(
            key: _mapKey,
            showUserLocation: true,
            showDeliveryAreas: _showDeliveryAreas,
            onRestaurantTap: _handleRestaurantTap,
          ),

          // Loading overlay
          if (mapState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Error display
          if (mapState.error != null)
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: _ErrorBanner(
                error: mapState.error!,
                onDismiss: () => ref.read(mapProvider.notifier).clearError(),
              ),
            ),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back button
                _ActionButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),

                const Spacer(),

                // Filter toggle
                _ActionButton(
                  icon: _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  onTap: () => setState(() => _showFilters = !_showFilters),
                  tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
                ),

                const SizedBox(width: 8),

                // Delivery areas toggle
                _ActionButton(
                  icon: Icons.local_shipping,
                  onTap: () => setState(() => _showDeliveryAreas = !_showDeliveryAreas),
                  tooltip: _showDeliveryAreas ? 'Hide Delivery Areas' : 'Show Delivery Areas',
                  isSelected: _showDeliveryAreas,
                ),

                const SizedBox(width: 8),

                // Manual location selection toggle
                _ActionButton(
                  icon: Icons.location_on,
                  onTap: () {
                    if (mapState.isManualLocationSelectionMode) {
                      ref.read(mapProvider.notifier).cancelManualLocationSelection();
                    } else {
                      ref.read(mapProvider.notifier).enableManualLocationSelection();
                    }
                  },
                  tooltip: mapState.isManualLocationSelectionMode
                      ? 'Cancel location selection'
                      : 'Select location manually',
                  isSelected: mapState.isManualLocationSelectionMode,
                ),
              ],
            ),
          ),

          // Bottom sheet for filters
          if (_showFilters)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _FilterBottomSheet(
                onClose: () => setState(() => _showFilters = false),
              ),
            ),

          // Restaurant details overlay
          if (mapState.restaurants.isNotEmpty)
            Positioned(
              bottom: _showFilters ? 280 : 16,
              left: 16,
              right: 16,
              child: _RestaurantListOverlay(
                restaurants: mapState.restaurants,
                onRestaurantTap: _handleRestaurantTap,
              ),
            ),

          // Location selection overlay
          const LocationSelectionWidget(),

          // Location selection marker
          const LocationSelectionMarker(),
        ],
      ),
    );
  }

  /// Initialize the map
  Future<void> _initializeMap() async {
    try {
      await ref.read(mapProvider.notifier).initializeMap();
    } catch (e) {
      // Handle initialization error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Handle restaurant tap
  void _handleRestaurantTap(Restaurant restaurant) {
    // Navigate to restaurant details screen
    // This would be implemented based on the app's navigation system
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${restaurant.name}'),
        action: SnackBarAction(
          label: 'View Details',
          onPressed: () {
            // Navigate to restaurant details
          },
        ),
      ),
    );
  }
}

/// Action button for map controls
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.isSelected = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.blue : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

/// Error banner for displaying errors
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.error,
    required this.onDismiss,
  });

  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for filters
class _FilterBottomSheet extends ConsumerWidget {
  const _FilterBottomSheet({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Location filter widget
                  const LocationFilterWidget(),

                  const SizedBox(height: 16),

                  // Quick radius filters
                  const QuickRadiusFilters(),

                  const SizedBox(height: 16),

                  // Delivery area legend
                  if (ref.watch(mapProvider).showDeliveryAreas)
                    const DeliveryAreaLegend(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Restaurant list overlay
class _RestaurantListOverlay extends StatelessWidget {
  const _RestaurantListOverlay({
    required this.restaurants,
    required this.onRestaurantTap,
  });

  final List<Restaurant> restaurants;
  final Function(Restaurant) onRestaurantTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${restaurants.length} Restaurants Found',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to list view
                  },
                  child: const Text('View All'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          // Restaurant list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 12),
                  child: RestaurantMapCard(
                    restaurant: restaurant,
                    onTap: () => onRestaurantTap(restaurant),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating action button for current location
class MapLocationButton extends ConsumerWidget {
  const MapLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        // Center map on current location
        ref.read(mapProvider.notifier).centerOnCurrentLocation();
      },
      child: const Icon(Icons.my_location),
      tooltip: 'Go to current location',
    );
  }
}

/// Map screen with all features integrated
class MapDiscoveryScreen extends StatelessWidget {
  const MapDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Discovery'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Open filter screen
            },
          ),
        ],
      ),
      body: const MapScreen(),
      floatingActionButton: const MapLocationButton(),
    );
  }
}

/// Compact map view for embedding in other screens
class CompactMapView extends ConsumerWidget {
  const CompactMapView({
    super.key,
    this.height = 300,
    this.onRestaurantTap,
  });

  final double height;
  final Function(Restaurant)? onRestaurantTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: RestaurantMapWidget(
          initialLocation: const Location(
            latitude: 30.0444,
            longitude: 31.2357,
          ),
          initialZoom: 13.0,
          showUserLocation: true,
          onRestaurantTap: onRestaurantTap,
        ),
      ),
    );
  }
}