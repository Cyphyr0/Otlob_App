import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment.dart';
import '../providers/payment_provider.dart';

class PaymentProcessingWidget extends ConsumerStatefulWidget {

  const PaymentProcessingWidget({
    required this.orderId, required this.selectedProvider, required this.amount, required this.currency, super.key,
  });
  final String orderId;
  final PaymentProvider selectedProvider;
  final double amount;
  final String currency;

  @override
  ConsumerState<PaymentProcessingWidget> createState() => _PaymentProcessingWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('orderId', orderId));
    properties.add(EnumProperty<PaymentProvider>('selectedProvider', selectedProvider));
    properties.add(DoubleProperty('amount', amount));
    properties.add(StringProperty('currency', currency));
  }
}

class _PaymentProcessingWidgetState extends ConsumerState<PaymentProcessingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _initializePayment();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializePayment() async {
    final paymentNotifier = ref.read(paymentProvider.notifier);

    // Initialize payment intent
    await paymentNotifier.initializePayment(
      orderId: widget.orderId,
      provider: widget.selectedProvider,
      amount: widget.amount,
      currency: widget.currency,
      metadata: {
        'customerEmail': 'customer@example.com', // Would come from user data
        'customerPhone': '+20123456789', // Would come from user data
      },
    );

    // Check if payment intent was created successfully
    final paymentState = ref.read(paymentProvider);
    if (paymentState.paymentIntent != null) {
      _processPayment();
    }
  }

  Future<void> _processPayment() async {
    final paymentState = ref.read(paymentProvider);

    if (paymentState.paymentIntent == null) {
      _showError('Payment initialization failed');
      return;
    }

    final paymentNotifier = ref.read(paymentProvider.notifier);

    try {
      // Process payment based on provider
      switch (widget.selectedProvider) {
        case PaymentProvider.stripe:
          // For Stripe, we would need card details or payment method ID
          // This would typically involve Stripe SDK or webview
          _showError('Stripe payment requires card details');
          break;

        case PaymentProvider.fawry:
          // Fawry payment - show reference number for outlet payment
          _showFawryInstructions(paymentState.paymentIntent!.clientSecret);
          break;

        case PaymentProvider.vodafoneCash:
          // Vodafone CASH - show phone number input
          _showVodafoneCashInput();
          break;

        case PaymentProvider.meeza:
          // Meeza - show card token input
          _showMeezaInput();
          break;
      }
    } catch (e) {
      _showError('Payment processing failed: $e');
    }
  }

  void _showFawryInstructions(String referenceNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fawry Payment Instructions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please visit any Fawry outlet and provide this reference number:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Text(
                referenceNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text('Amount: ${widget.amount} ${widget.currency}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showVodafoneCashInput() {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vodafone CASH Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your Vodafone phone number:'),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: '01xxxxxxxxx',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _processVodafonePayment(phoneController.text);
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  void _showMeezaInput() {
    final cardTokenController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meeza Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your Meeza card token:'),
            const SizedBox(height: 16),
            TextField(
              controller: cardTokenController,
              decoration: const InputDecoration(
                hintText: 'Card Token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cvvController,
              decoration: const InputDecoration(
                hintText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _processMeezaPayment(cardTokenController.text, cvvController.text);
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  Future<void> _processVodafonePayment(String phoneNumber) async {
    final paymentNotifier = ref.read(paymentProvider.notifier);

    try {
      final vodafoneData = VodafoneCashPaymentData(
        phoneNumber: phoneNumber,
        amount: widget.amount,
        currency: widget.currency,
        description: 'Order Payment - ${widget.orderId}',
      );

      await paymentNotifier.processPayment(vodafoneData);
      _showPaymentResult();
    } catch (e) {
      _showError('Vodafone CASH payment failed: $e');
    }
  }

  Future<void> _processMeezaPayment(String cardToken, String cvv) async {
    final paymentNotifier = ref.read(paymentProvider.notifier);

    try {
      final meezaData = MeezaPaymentData(
        cardToken: cardToken,
        amount: widget.amount,
        currency: widget.currency,
        description: 'Order Payment - ${widget.orderId}',
      );

      await paymentNotifier.processPayment(meezaData);
      _showPaymentResult();
    } catch (e) {
      _showError('Meeza payment failed: $e');
    }
  }

  void _showPaymentResult() {
    final paymentState = ref.read(paymentProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          paymentState.currentPayment?.status == PaymentTransactionStatus.completed
              ? 'Payment Successful'
              : 'Payment Failed',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              paymentState.currentPayment?.status == PaymentTransactionStatus.completed
                  ? Icons.check_circle
                  : Icons.error,
              color: paymentState.currentPayment?.status == PaymentTransactionStatus.completed
                  ? Colors.green
                  : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              paymentState.currentPayment?.status == PaymentTransactionStatus.completed
                  ? 'Your payment has been processed successfully!'
                  : 'Your payment could not be processed.',
            ),
            if (paymentState.currentPayment != null) ...[
              const SizedBox(height: 16),
              Text('Amount: ${paymentState.currentPayment!.amount} ${paymentState.currentPayment!.currency}'),
              Text("Transaction ID: ${paymentState.currentPayment!.transactionId ?? 'N/A'}"),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Header
              const Text(
                'Processing Payment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.amount} ${widget.currency}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),

              // Animated loading indicator
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) => Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(_animation.value),
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.payment,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Please wait...',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Processing your ${widget.selectedProvider.name} payment',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Error display
              if (paymentState.error != null)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    paymentState.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Cancel button
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: paymentState.isProcessing
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}