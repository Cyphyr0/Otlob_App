import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_status.dart';
import '../../domain/entities/restaurant_status_type.dart';

class RestaurantStatusBadge extends StatelessWidget {
  const RestaurantStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
    this.elevation = 0,
  });

  final RestaurantStatus status;
  final bool compact;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(compact ? 12 : 16),
      color: _getBackgroundColor(status.statusType),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusIcon(
              statusType: status.statusType,
              size: compact ? 14 : 16,
            ),
            if (!compact) ...[
              const SizedBox(width: 6),
              _StatusText(
                status: status,
                compact: compact,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(RestaurantStatusType statusType) {
    switch (statusType) {
      case RestaurantStatusType.open:
        return Colors.green.withOpacity(0.1);
      case RestaurantStatusType.closed:
        return Colors.grey.withOpacity(0.1);
      case RestaurantStatusType.renovation:
      case RestaurantStatusType.repairs:
        return Colors.orange.withOpacity(0.1);
      case RestaurantStatusType.maintenance:
        return Colors.blue.withOpacity(0.1);
      case RestaurantStatusType.permanentlyClosed:
        return Colors.red.withOpacity(0.1);
    }
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.statusType,
    required this.size,
  });

  final RestaurantStatusType statusType;
  final double size;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;

    switch (statusType) {
      case RestaurantStatusType.open:
        iconData = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case RestaurantStatusType.closed:
        iconData = Icons.cancel_outlined;
        color = Colors.grey;
        break;
      case RestaurantStatusType.renovation:
        iconData = Icons.construction_outlined;
        color = Colors.orange;
        break;
      case RestaurantStatusType.repairs:
        iconData = Icons.build_outlined;
        color = Colors.orange;
        break;
      case RestaurantStatusType.maintenance:
        iconData = Icons.settings_outlined;
        color = Colors.blue;
        break;
      case RestaurantStatusType.permanentlyClosed:
        iconData = Icons.block_outlined;
        color = Colors.red;
        break;
    }

    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({
    required this.status,
    required this.compact,
  });

  final RestaurantStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = status.getDisplayMessage('en'); // TODO: Use proper localization

    return Text(
      message,
      style: (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)?.copyWith(
        color: _getTextColor(status.statusType),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getTextColor(RestaurantStatusType statusType) {
    switch (statusType) {
      case RestaurantStatusType.open:
        return Colors.green.shade700;
      case RestaurantStatusType.closed:
        return Colors.grey.shade700;
      case RestaurantStatusType.renovation:
      case RestaurantStatusType.repairs:
        return Colors.orange.shade700;
      case RestaurantStatusType.maintenance:
        return Colors.blue.shade700;
      case RestaurantStatusType.permanentlyClosed:
        return Colors.red.shade700;
    }
  }
}