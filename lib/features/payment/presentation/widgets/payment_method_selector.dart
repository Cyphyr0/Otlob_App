import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment.dart';
import '../providers/payment_provider.dart';

class PaymentMethodSelector extends ConsumerStatefulWidget {

  const PaymentMethodSelector({
    required this.amount, required this.currency, required this.onPaymentMethodSelected, super.key,
  });
  final double amount;
  final String currency;
  final Function(PaymentProvider) onPaymentMethodSelected;

  @override
  ConsumerState<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('amount', amount));
    properties.add(StringProperty('currency', currency));
    properties.add(ObjectFlagProperty<Function(PaymentProvider p1)>.has('onPaymentMethodSelected', onPaymentMethodSelected));
  }
}

class _PaymentMethodSelectorState extends ConsumerState<PaymentMethodSelector> {
  PaymentProvider? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _loadSupportedProviders();
  }

  Future<void> _loadSupportedProviders() async {
    final paymentNotifier = ref.read(paymentProvider.notifier);
    final providers = await paymentNotifier.getSupportedProviders();

    // Set default to first available provider
    if (providers.isNotEmpty && _selectedMethod == null) {
      setState(() {
        _selectedMethod = providers.first;
      });
      widget.onPaymentMethodSelected(providers.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (paymentState.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ...PaymentProvider.values.map(_buildPaymentMethodTile),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentProvider provider) {
    final isSelected = _selectedMethod == provider;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: _getPaymentMethodIcon(provider),
        title: Text(_getPaymentMethodTitle(provider)),
        subtitle: Text(_getPaymentMethodDescription(provider)),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              )
            : null,
        onTap: () {
          setState(() {
            _selectedMethod = provider;
          });
          widget.onPaymentMethodSelected(provider);
        },
      ),
    );
  }

  Widget _getPaymentMethodIcon(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return const Icon(Icons.credit_card, color: Colors.purple);
      case PaymentProvider.fawry:
        return const Icon(Icons.store, color: Colors.orange);
      case PaymentProvider.vodafoneCash:
        return const Icon(Icons.phone_android, color: Colors.red);
      case PaymentProvider.meeza:
        return const Icon(Icons.account_balance_wallet, color: Colors.blue);
    }
  }

  String _getPaymentMethodTitle(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return 'Credit/Debit Card';
      case PaymentProvider.fawry:
        return 'Fawry';
      case PaymentProvider.vodafoneCash:
        return 'Vodafone CASH';
      case PaymentProvider.meeza:
        return 'Meeza';
    }
  }

  String _getPaymentMethodDescription(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return 'Pay securely with your card';
      case PaymentProvider.fawry:
        return 'Pay at any Fawry outlet';
      case PaymentProvider.vodafoneCash:
        return 'Pay with your Vodafone wallet';
      case PaymentProvider.meeza:
        return 'Pay with Meeza digital wallet';
    }
  }
}