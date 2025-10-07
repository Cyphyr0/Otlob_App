import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../domain/entities/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    required this.transactions, super.key,
    this.onViewAll,
  });

  final List<Transaction> transactions;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ...transactions.map((transaction) => _TransactionItem(transaction: transaction)),
        if (onViewAll != null) ...[
          const SizedBox(height: 16),
          Center(
            child: ShadButton.outline(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Transaction>('transactions', transactions));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onViewAll', onViewAll));
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTransactionColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTransactionIcon(),
              color: _getTransactionColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTransactionTitle(),
                  style: ShadTheme.of(context).textTheme.p.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _getFormattedDate(),
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getAmountText(),
            style: ShadTheme.of(context).textTheme.p.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTransactionColor(),
            ),
          ),
        ],
      ),
    );

  String _getTransactionTitle() {
    switch (transaction.type) {
      case TransactionType.topUp:
        return 'Top Up';
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.subscription:
        return 'Subscription';
      case TransactionType.cashback:
        return 'Cashback';
    }
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.topUp:
        return Icons.add;
      case TransactionType.payment:
        return Icons.remove;
      case TransactionType.refund:
        return Icons.undo;
      case TransactionType.subscription:
        return Icons.subscriptions;
      case TransactionType.cashback:
        return Icons.redeem;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.type) {
      case TransactionType.topUp:
      case TransactionType.refund:
      case TransactionType.cashback:
        return Colors.green;
      case TransactionType.payment:
      case TransactionType.subscription:
        return Colors.red;
    }
  }

  String _getAmountText() {
    final prefix = transaction.type == TransactionType.topUp ||
                   transaction.type == TransactionType.refund ||
                   transaction.type == TransactionType.cashback
        ? '+' : '-';

    return '$prefix${transaction.amount.toStringAsFixed(2)} ${transaction.currency}';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(transaction.createdAt);

    if (difference.inDays == 0) {
      return 'Today ${transaction.createdAt.hour.toString().padLeft(2, '0')}:${transaction.createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Transaction>('transaction', transaction));
  }
}