import "../entities/payment.dart";

abstract class PaymentRepository {
  /// Create a payment intent for the given order
  Future<PaymentIntent> createPaymentIntent({
    required String orderId,
    required PaymentProvider provider,
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  });

  /// Process payment with the given payment data
  Future<Payment> processPayment({
    required String paymentIntentId,
    required dynamic paymentData, // FawryPaymentData, VodafoneCashPaymentData, etc.
  });

  /// Get payment status by ID
  Future<Payment?> getPaymentById(String paymentId);

  /// Get payments for an order
  Future<List<Payment>> getPaymentsByOrderId(String orderId);

  /// Confirm payment (for webhooks or manual confirmation)
  Future<Payment> confirmPayment(String paymentId);

  /// Cancel payment
  Future<Payment> cancelPayment(String paymentId);

  /// Refund payment
  Future<Payment> refundPayment(String paymentId, double? amount);

  /// Get supported payment providers
  Future<List<PaymentProvider>> getSupportedProviders();
}