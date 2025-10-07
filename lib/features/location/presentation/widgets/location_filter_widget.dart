/// Location filter widget for radius/distance filtering and location-based search
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/map_provider.dart';
import '../../domain/entities/location.dart';

/// Main location filter widget with radius slider and search
class LocationFilterWidget extends ConsumerStatefulWidget {
  const LocationFilterWidget({
    super.key,
    this.initialRadius = 5.0,
    this.onLocationChanged,
    this.onRadiusChanged,
    this.showSearchBar = true,
    this.showCurrentLocationButton = true,
  });

  final double initialRadius;
  final Function(Location)? onLocationChanged;
  final Function(double)? onRadiusChanged;
  final bool showSearchBar;
  final bool showCurrentLocationButton;

  @override
  ConsumerState<LocationFilterWidget> createState() => _LocationFilterWidgetState();
}

class _LocationFilterWidgetState extends ConsumerState<LocationFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  double _currentRadius = 5.0;

  @override
  void initState() {
    super.initState();
    _currentRadius = widget.initialRadius;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Search bar
          if (widget.showSearchBar) ...[
            _SearchBar(
              controller: _searchController,
              onSearch: _handleSearch,
              onLocationTap: _handleLocationTap,
            ),
            const SizedBox(height: 16),
          ],

          // Radius filter
          _RadiusFilter(
            currentRadius: _currentRadius,
            onRadiusChanged: _handleRadiusChanged,
          ),

          // Current location button
          if (widget.showCurrentLocationButton) ...[
            const SizedBox(height: 12),
            _CurrentLocationButton(
              onLocationFound: _handleCurrentLocationFound,
            ),
          ],

          // Filter summary
          if (mapState.selectedCuisineTypes.isNotEmpty || mapState.minRating != null) ...[
            const SizedBox(height: 12),
            _FilterSummary(
              selectedCuisines: mapState.selectedCuisineTypes,
              minRating: mapState.minRating,
              onClearFilters: _handleClearFilters,
            ),
          ],
        ],
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      ref.read(mapProvider.notifier).searchRestaurants(query);
    }
  }

  void _handleLocationTap() {
    // Handle manual location selection
    // This could open a location picker or address search
  }

  void _handleRadiusChanged(double radius) {
    setState(() {
      _currentRadius = radius;
    });

    ref.read(mapProvider.notifier).updateFilters(radius: radius);

    if (widget.onRadiusChanged != null) {
      widget.onRadiusChanged!(radius);
    }
  }

  void _handleCurrentLocationFound(Location location) {
    ref.read(mapProvider.notifier).loadRestaurantsInRadius(
      center: location,
      radiusKm: _currentRadius,
    );

    if (widget.onLocationChanged != null) {
      widget.onLocationChanged!(location);
    }
  }

  void _handleClearFilters() {
    ref.read(mapProvider.notifier).updateFilters(
      cuisineTypes: [],
      minRating: null,
    );
  }
}

/// Search bar with location selection
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onSearch,
    required this.onLocationTap,
  });

  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search restaurants or locations...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: onLocationTap,
                tooltip: 'Use current location',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onSubmitted: onSearch,
          ),
        ),
      ],
    );
  }
}

/// Radius filter slider
class _RadiusFilter extends StatelessWidget {
  const _RadiusFilter({
    required this.currentRadius,
    required this.onRadiusChanged,
  });

  final double currentRadius;
  final Function(double) onRadiusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Search Radius',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${currentRadius.toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Slider
        Slider(
          value: currentRadius,
          min: 1.0,
          max: 20.0,
          divisions: 19,
          label: '${currentRadius.toStringAsFixed(1)} km',
          onChanged: onRadiusChanged,
        ),

        // Distance indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              '10 km',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              '20 km',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Current location button
class _CurrentLocationButton extends ConsumerWidget {
  const _CurrentLocationButton({
    required this.onLocationFound,
  });

  final Function(Location) onLocationFound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _handleCurrentLocation(ref, context),
        icon: const Icon(Icons.my_location),
        label: const Text('Use Current Location'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCurrentLocation(WidgetRef ref, BuildContext context) async {
    try {
      // Show loading state
      // In a real implementation, you'd show a loading indicator

      // Get current location using the location service
      // This would be implemented with the actual location service
      final location = await _getCurrentLocation();

      onLocationFound(location);
    } catch (e) {
      // Handle location error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get current location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<Location> _getCurrentLocation() async {
    // This would use the actual location service
    // For now, return a placeholder location
    return const Location(
      latitude: 30.0444,
      longitude: 31.2357,
      address: 'Cairo, Egypt',
      city: 'Cairo',
      country: 'Egypt',
    );
  }
}

/// Filter summary showing active filters
class _FilterSummary extends StatelessWidget {
  const _FilterSummary({
    required this.selectedCuisines,
    required this.minRating,
    required this.onClearFilters,
  });

  final List<String> selectedCuisines;
  final double? minRating;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Clear All'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          if (selectedCuisines.isNotEmpty || minRating != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Cuisine filters
                ...selectedCuisines.map((cuisine) => _FilterChip(
                  label: cuisine,
                  onRemove: () {
                    // Remove specific cuisine filter
                  },
                )),

                // Rating filter
                if (minRating != null) _FilterChip(
                  label: '${minRating!.toStringAsFixed(1)}★+',
                  onRemove: () {
                    // Remove rating filter
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Filter chip for displaying individual filters
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

/// Quick filter buttons for common radius values
class QuickRadiusFilters extends StatelessWidget {
  const QuickRadiusFilters({
    super.key,
    required this.onRadiusSelected,
    this.selectedRadius = 5.0,
  });

  final Function(double) onRadiusSelected;
  final double selectedRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickFilterButton(
          label: '1 km',
          value: 1.0,
          isSelected: selectedRadius == 1.0,
          onTap: () => onRadiusSelected(1.0),
        ),
        _QuickFilterButton(
          label: '3 km',
          value: 3.0,
          isSelected: selectedRadius == 3.0,
          onTap: () => onRadiusSelected(3.0),
        ),
        _QuickFilterButton(
          label: '5 km',
          value: 5.0,
          isSelected: selectedRadius == 5.0,
          onTap: () => onRadiusSelected(5.0),
        ),
        _QuickFilterButton(
          label: '10 km',
          value: 10.0,
          isSelected: selectedRadius == 10.0,
          onTap: () => onRadiusSelected(10.0),
        ),
      ],
    );
  }
}

/// Quick filter button
class _QuickFilterButton extends StatelessWidget {
  const _QuickFilterButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final double value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}