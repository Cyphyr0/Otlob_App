import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../../domain/entities/location.dart';
import '../providers/map_provider.dart';

/// Widget for manual location selection with visual feedback
class LocationSelectionWidget extends ConsumerWidget {
  const LocationSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    if (!mapState.isManualLocationSelectionMode) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 100,
      left: 16,
      right: 16,
      child: _LocationSelectionOverlay(
        selectedLocation: mapState.selectedLocation,
        selectedAddress: mapState.selectedLocationAddress,
        onCancel: () => ref.read(mapProvider.notifier).cancelManualLocationSelection(),
        onConfirm: () => ref.read(mapProvider.notifier).confirmManualLocationSelection(),
      ),
    );
  }
}

/// Overlay widget for location selection mode
class _LocationSelectionOverlay extends StatelessWidget {
  const _LocationSelectionOverlay({
    required this.selectedLocation,
    required this.selectedAddress,
    required this.onCancel,
    required this.onConfirm,
  });

  final Location? selectedLocation;
  final String? selectedAddress;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Instructions
          const Text(
            'Tap on the map to select your location',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          // Selected location info
          if (selectedLocation != null && selectedAddress != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Location:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedAddress!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text('Confirm'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Loading indicator
          if (selectedLocation == null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Getting location details...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Location?>('selectedLocation', selectedLocation));
    properties.add(StringProperty('selectedAddress', selectedAddress));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCancel', onCancel));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onConfirm', onConfirm));
  }
}

/// Floating action button for manual location selection
class ManualLocationSelectionButton extends ConsumerWidget {
  const ManualLocationSelectionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final isSelectionMode = mapState.isManualLocationSelectionMode;

    return FloatingActionButton(
      onPressed: () {
        if (isSelectionMode) {
          ref.read(mapProvider.notifier).cancelManualLocationSelection();
        } else {
          ref.read(mapProvider.notifier).enableManualLocationSelection();
        }
      },
      backgroundColor: isSelectionMode ? Colors.orange : Colors.blue,
      tooltip: isSelectionMode ? 'Cancel location selection' : 'Select location manually',
      child: Icon(
        isSelectionMode ? Icons.close : Icons.location_on,
      ),
    );
  }
}

/// Visual indicator for selected location on map
class LocationSelectionMarker extends ConsumerWidget {
  const LocationSelectionMarker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

    if (!mapState.isManualLocationSelectionMode || mapState.selectedLocation == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}