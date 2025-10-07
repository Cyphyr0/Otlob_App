import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../domain/entities/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getSubscriptionTitle(),
                style: ShadTheme.of(context).textTheme.p?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subscription.status.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.attach_money, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${subscription.amount.toStringAsFixed(2)} ${subscription.currency}',
                style: ShadTheme.of(context).textTheme.p?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                _getBillingCycle(),
                style: ShadTheme.of(context).textTheme.small?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date',
                      style: ShadTheme.of(context).textTheme.small?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _formatDate(subscription.startDate),
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Billing',
                      style: ShadTheme.of(context).textTheme.small?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      subscription.nextBillingDate != null
                          ? _formatDate(subscription.nextBillingDate!)
                          : 'N/A',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (subscription.isCancelled && subscription.cancelledAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.cancel, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  'Cancelled on ${_formatDate(subscription.cancelledAt!)}',
                  style: ShadTheme.of(context).textTheme.small?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],

          if (subscription.isExpired) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Expired on ${_formatDate(subscription.endDate)}',
                  style: ShadTheme.of(context).textTheme.small?.copyWith(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getSubscriptionTitle() {
    switch (subscription.type) {
      case SubscriptionType.monthly:
        return 'Monthly Subscription';
      case SubscriptionType.yearly:
        return 'Yearly Subscription';
      case SubscriptionType.weekly:
        return 'Weekly Subscription';
    }
  }

  String _getBillingCycle() {
    switch (subscription.type) {
      case SubscriptionType.monthly:
        return 'Monthly';
      case SubscriptionType.yearly:
        return 'Yearly';
      case SubscriptionType.weekly:
        return 'Weekly';
    }
  }

  Color _getStatusColor() {
    switch (subscription.status) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.pending:
        return Colors.orange;
      case SubscriptionStatus.cancelled:
        return Colors.red;
      case SubscriptionStatus.expired:
        return Colors.grey;
      case SubscriptionStatus.paused:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}