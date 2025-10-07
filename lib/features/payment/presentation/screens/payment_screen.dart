import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../domain/entities/payment.dart";
import "../providers/payment_provider.dart";
import "../widgets/payment_method_selector.dart";
import "../widgets/payment_processing_widget.dart";
import "../widgets/payment_result_widget.dart";

class PaymentScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double amount;
  final String currency;
  final String? customerEmail;
  final String? customerPhone;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.currency,
    this.customerEmail,
    this.customerPhone,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentProvider? _selectedProvider;

  @override
  void initState() {
    super.initState();
    // Reset payment state when entering payment screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentProvider.notifier).resetPayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    // Show payment result if payment is completed
    if (paymentState.currentPayment != null) {
      return PaymentResultWidget(
        payment: paymentState.currentPayment!,
        onContinue: () => Navigator.of(context).pop(),
      );
    }

    // Show payment processing if payment intent exists
    if (paymentState.paymentIntent != null) {
      return PaymentProcessingWidget(
        orderId: widget.orderId,
        selectedProvider: paymentState.selectedProvider!,
        amount: widget.amount,
        currency: widget.currency,
      );
    }

    // Show payment method selection
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order summary
            _buildOrderSummary(),

            const SizedBox(height: 16),

            // Payment method selector
            PaymentMethodSelector(
              amount: widget.amount,
              currency: widget.currency,
              onPaymentMethodSelected: (provider) {
                setState(() {
                  _selectedProvider = provider;
                });
              },
            ),

            const SizedBox(height: 32),

            // Pay button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _selectedProvider == null || paymentState.isLoading
                    ? null
                    : _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: paymentState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Pay ${widget.amount} ${widget.currency}",
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),

            // Error display
            if (paymentState.error != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  paymentState.error!,
                  style: TextStyle(color: Colors.red.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            "Order Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Order ID:",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                widget.orderId,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Amount:",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "${widget.amount} ${widget.currency}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToPayment() async {
    if (_selectedProvider == null) return;

    final paymentNotifier = ref.read(paymentProvider.notifier);

    // Initialize payment with selected provider
    await paymentNotifier.initializePayment(
      orderId: widget.orderId,
      provider: _selectedProvider!,
      amount: widget.amount,
      currency: widget.currency,
      metadata: {
        "customerEmail": widget.customerEmail ?? "customer@example.com",
        "customerPhone": widget.customerPhone ?? "+20123456789",
      },
    );
  }
}