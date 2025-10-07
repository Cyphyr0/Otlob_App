import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_status.dart';
import '../../domain/entities/restaurant_status_type.dart';

class RestaurantStatusIndicator extends StatelessWidget {
  const RestaurantStatusIndicator({
    required this.status, super.key,
    this.size = 16,
    this.showText = true,
    this.textStyle,
  });

  final RestaurantStatus status;
  final double size;
  final bool showText;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusIcon(
          statusType: status.statusType,
          size: size,
        ),
        if (showText) ...[
          const SizedBox(width: 6),
          _StatusText(
            status: status,
            style: textStyle ?? theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantStatus>('status', status));
    properties.add(DoubleProperty('size', size));
    properties.add(DiagnosticsProperty<bool>('showText', showText));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
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
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case RestaurantStatusType.closed:
        iconData = Icons.cancel;
        color = Colors.grey;
        break;
      case RestaurantStatusType.renovation:
        iconData = Icons.construction;
        color = Colors.orange;
        break;
      case RestaurantStatusType.repairs:
        iconData = Icons.build;
        color = Colors.orange;
        break;
      case RestaurantStatusType.maintenance:
        iconData = Icons.settings;
        color = Colors.blue;
        break;
      case RestaurantStatusType.permanentlyClosed:
        iconData = Icons.block;
        color = Colors.red;
        break;
    }

    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<RestaurantStatusType>('statusType', statusType));
    properties.add(DoubleProperty('size', size));
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({
    required this.status,
    required this.style,
  });

  final RestaurantStatus status;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final message = status.getDisplayMessage('en'); // TODO: Use proper localization

    return Text(
      message,
      style: style?.copyWith(
        color: _getTextColor(status.statusType),
      ),
    );
  }

  Color _getTextColor(RestaurantStatusType statusType) {
    switch (statusType) {
      case RestaurantStatusType.open:
        return Colors.green;
      case RestaurantStatusType.closed:
        return Colors.grey;
      case RestaurantStatusType.renovation:
      case RestaurantStatusType.repairs:
        return Colors.orange;
      case RestaurantStatusType.maintenance:
        return Colors.blue;
      case RestaurantStatusType.permanentlyClosed:
        return Colors.red;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RestaurantStatus>('status', status));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
  }
}