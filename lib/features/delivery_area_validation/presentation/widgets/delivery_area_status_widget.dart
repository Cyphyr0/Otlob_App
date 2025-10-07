/// Widget to display delivery area status with visual indicators
library;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/delivery_area_status.dart';
import '../../domain/entities/delivery_area_validation.dart';

class DeliveryAreaStatusWidget extends StatelessWidget {
  const DeliveryAreaStatusWidget({
    required this.validation, super.key,
    this.showDetails = true,
    this.compact = false,
    this.onRetry,
  });

  final DeliveryAreaValidation validation;
  final bool showDetails;
  final bool compact;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: validation.statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status header
          Row(
            children: [
              Icon(
                _getStatusIcon(),
                color: validation.statusColor,
                size: compact ? 16 : 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  validation.status.displayName,
                  style: (compact ? AppTypography.bodySmall : AppTypography.bodyMedium).copyWith(
                    color: validation.statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onRetry != null && validation.status == DeliveryAreaStatus.error)
                IconButton(
                  onPressed: onRetry,
                  icon: Icon(
                    Icons.refresh,
                    size: compact ? 16 : 20,
                    color: validation.statusColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          if (showDetails && !compact) ...[
            SizedBox(height: AppSpacing.sm),
            // Status description
            Text(
              validation.status.description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray,
              ),
            ),

            // Additional details for within area status
            if (validation.status == DeliveryAreaStatus.withinArea &&
                (validation.distance != null || validation.deliveryFee != null || validation.estimatedDeliveryTime != null))
              SizedBox(height: AppSpacing.md),
            if (validation.status == DeliveryAreaStatus.withinArea)
              _buildDeliveryDetails(context),

            // Additional details for outside area status
            if (validation.status == DeliveryAreaStatus.outsideArea && validation.distance != null)
              SizedBox(height: AppSpacing.sm),
            if (validation.status == DeliveryAreaStatus.outsideArea)
              _buildOutsideAreaDetails(context),
          ],
        ],
      ),
    );

  Widget _buildDeliveryDetails(BuildContext context) => Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        if (validation.distance != null)
          _buildDetailChip(
            context,
            icon: Icons.location_on,
            text: validation.formattedDistance,
          ),
        if (validation.deliveryFee != null)
          _buildDetailChip(
            context,
            icon: Icons.delivery_dining,
            text: validation.formattedDeliveryFee,
          ),
        if (validation.estimatedDeliveryTime != null)
          _buildDetailChip(
            context,
            icon: Icons.access_time,
            text: validation.formattedDeliveryTime,
          ),
      ],
    );

  Widget _buildOutsideAreaDetails(BuildContext context) => Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_off,
            size: 16,
            color: AppColors.error,
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              '${validation.formattedDistance} away from delivery area',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildDetailChip(BuildContext context, {required IconData icon, required String text}) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: validation.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: validation.statusColor,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: validation.statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

  Color _getBackgroundColor(BuildContext context) {
    switch (validation.status) {
      case DeliveryAreaStatus.withinArea:
        return AppColors.success.withOpacity(0.1);
      case DeliveryAreaStatus.outsideArea:
        return AppColors.error.withOpacity(0.1);
      case DeliveryAreaStatus.permissionDenied:
      case DeliveryAreaStatus.locationDisabled:
        return AppColors.warning.withOpacity(0.1);
      case DeliveryAreaStatus.determining:
        return AppColors.info.withOpacity(0.1);
      case DeliveryAreaStatus.error:
        return AppColors.error.withOpacity(0.1);
    }
  }

  IconData _getStatusIcon() {
    switch (validation.status) {
      case DeliveryAreaStatus.withinArea:
        return Icons.check_circle;
      case DeliveryAreaStatus.outsideArea:
        return Icons.cancel;
      case DeliveryAreaStatus.permissionDenied:
        return Icons.location_disabled;
      case DeliveryAreaStatus.locationDisabled:
        return Icons.location_off;
      case DeliveryAreaStatus.determining:
        return Icons.location_searching;
      case DeliveryAreaStatus.error:
        return Icons.error;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DeliveryAreaValidation>('validation', validation));
    properties.add(DiagnosticsProperty<bool>('showDetails', showDetails));
    properties.add(DiagnosticsProperty<bool>('compact', compact));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
  }
}