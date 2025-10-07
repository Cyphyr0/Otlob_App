import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TopUpButton extends StatelessWidget {
  const TopUpButton({
    required this.onTopUp, super.key,
  });

  final Function(double amount, String paymentMethod) onTopUp;

  @override
  Widget build(BuildContext context) => ShadButton(
      onPressed: () {
        _showTopUpDialog(context);
      },
      child: const Text('Top Up'),
    );

  void _showTopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const _TopUpDialog(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Function(double amount, String paymentMethod)>.has('onTopUp', onTopUp));
  }
}

class _TopUpDialog extends StatefulWidget {
  const _TopUpDialog();

  @override
  State<_TopUpDialog> createState() => _TopUpDialogState();
}

class _TopUpDialogState extends State<_TopUpDialog> {
  double selectedAmount = 50;
  String selectedPaymentMethod = 'card';

  final List<double> topUpAmounts = [25.0, 50.0, 100.0, 200.0, 500.0];

  @override
  Widget build(BuildContext context) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Up Wallet',
                  style: ShadTheme.of(context).textTheme.h4,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount Selection
            Text(
              'Select Amount',
              style: ShadTheme.of(context).textTheme.p,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topUpAmounts.map((amount) => ShadButton.outline(
                  onPressed: () {
                    setState(() {
                      selectedAmount = amount;
                    });
                  },
                  child: Text('${amount.toStringAsFixed(0)} EGP'),
                )).toList(),
            ),

            const SizedBox(height: 24),

            // Payment Method Selection
            Text(
              'Payment Method',
              style: ShadTheme.of(context).textTheme.p,
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _PaymentMethodOption(
                  title: 'Credit/Debit Card',
                  subtitle: 'Visa, Mastercard, Meeza',
                  value: 'card',
                  selectedValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const SizedBox(height: 8),
                _PaymentMethodOption(
                  title: 'Vodafone Cash',
                  subtitle: 'Mobile wallet',
                  value: 'vodafone_cash',
                  selectedValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const SizedBox(height: 8),
                _PaymentMethodOption(
                  title: ' Fawry',
                  subtitle: 'Cash payment network',
                  value: 'fawry',
                  selectedValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ShadButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // This would be handled by the parent widget
                    },
                    child: Text('Top Up ${selectedAmount.toStringAsFixed(0)} EGP'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('selectedAmount', selectedAmount));
    properties.add(StringProperty('selectedPaymentMethod', selectedPaymentMethod));
    properties.add(IterableProperty<double>('topUpAmounts', topUpAmounts));
  }
}

class _PaymentMethodOption extends StatelessWidget {
  const _PaymentMethodOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final String value;
  final String selectedValue;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: value == selectedValue
              ? const Color(0xFFDC2626)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ShadTheme.of(context).textTheme.p.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Radio<String>(
            value: value,
            groupValue: selectedValue,
            onChanged: onChanged,
            activeColor: const Color(0xFFDC2626),
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('subtitle', subtitle));
    properties.add(StringProperty('value', value));
    properties.add(StringProperty('selectedValue', selectedValue));
    properties.add(ObjectFlagProperty<Function(String? p1)>.has('onChanged', onChanged));
  }
}