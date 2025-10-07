import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/payment.dart';

class StripePaymentService {

  StripePaymentService(this._secretKey, {http.Client? client})
      : _client = client ?? http.Client();
  static const String _baseUrl = 'https://api.stripe.com/v1';
  final String _secretKey;
  final http.Client _client;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  /// Create a payment intent
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
    String? customerEmail,
    String? customerPhone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final data = <String, String>{
        'amount': _convertAmountToStripe(amount, currency),
        'currency': currency.toLowerCase(),
        'metadata[order_id]': orderId,
        if (customerEmail != null) 'receipt_email': customerEmail,
        if (metadata != null) ...metadata.map((k, v) => MapEntry('metadata[$k]', v.toString())),
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: _headers,
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return PaymentIntent(
          id: responseData['id'] as String,
          orderId: orderId,
          provider: PaymentProvider.stripe,
          amount: amount,
          currency: currency,
          clientSecret: responseData['client_secret'] as String,
          customerId: responseData['customer'] as String?,
          metadata: metadata,
        );
      } else {
        throw StripePaymentException(
          'Failed to create payment intent: ${response.body}',
        );
      }
    } catch (e) {
      throw StripePaymentException('Error creating payment intent: $e');
    }
  }

  /// Confirm a payment
  Future<Payment> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final data = <String, String>{
        'payment_method': paymentMethodId,
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/payment_intents/$paymentIntentId/confirm'),
        headers: _headers,
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapStripeResponseToPayment(responseData);
      } else {
        throw StripePaymentException(
          'Failed to confirm payment: ${response.body}',
        );
      }
    } catch (e) {
      throw StripePaymentException('Error confirming payment: $e');
    }
  }

  /// Retrieve payment intent status
  Future<Payment> getPaymentStatus(String paymentIntentId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/payment_intents/$paymentIntentId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapStripeResponseToPayment(responseData);
      } else {
        throw StripePaymentException(
          'Failed to get payment status: ${response.body}',
        );
      }
    } catch (e) {
      throw StripePaymentException('Error getting payment status: $e');
    }
  }

  /// Cancel payment intent
  Future<Payment> cancelPayment(String paymentIntentId) async {
    try {
      final data = <String, String>{
        'cancellation_reason': 'requested_by_customer',
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/payment_intents/$paymentIntentId/cancel'),
        headers: _headers,
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapStripeResponseToPayment(responseData);
      } else {
        throw StripePaymentException(
          'Failed to cancel payment: ${response.body}',
        );
      }
    } catch (e) {
      throw StripePaymentException('Error canceling payment: $e');
    }
  }

  /// Create a refund
  Future<Payment> refundPayment({
    required String paymentIntentId,
    double? amount,
  }) async {
    try {
      final data = <String, String>{
        'payment_intent': paymentIntentId,
        if (amount != null) 'amount': _convertAmountToStripe(amount, 'usd'),
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/refunds'),
        headers: _headers,
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapStripeRefundToPayment(responseData, paymentIntentId);
      } else {
        throw StripePaymentException(
          'Failed to refund payment: ${response.body}',
        );
      }
    } catch (e) {
      throw StripePaymentException('Error refunding payment: $e');
    }
  }

  Payment _mapStripeResponseToPayment(Map<String, dynamic> responseData) {
    final orderId = responseData['metadata']?['order_id'] as String? ?? '';

    PaymentTransactionStatus status;
    switch (responseData['status']) {
      case 'succeeded':
        status = PaymentTransactionStatus.completed;
        break;
      case 'processing':
        status = PaymentTransactionStatus.processing;
        break;
      case 'canceled':
        status = PaymentTransactionStatus.cancelled;
        break;
      case 'requires_payment_method':
      case 'requires_confirmation':
        status = PaymentTransactionStatus.pending;
        break;
      default:
        status = PaymentTransactionStatus.failed;
    }

    return Payment(
      id: responseData['id'] as String,
      orderId: orderId,
      provider: PaymentProvider.stripe,
      amount: _convertStripeAmountToDouble(
        int.parse(responseData['amount'].toString()),
        responseData['currency'] as String,
      ),
      currency: (responseData['currency'] as String).toUpperCase(),
      status: status,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (responseData['created'] as int) * 1000,
      ),
      updatedAt: DateTime.now(),
      transactionId: responseData['latest_charge'] as String?,
      referenceId: responseData['id'] as String,
      providerResponse: responseData,
      metadata: {
        'payment_method': responseData['payment_method_types']?.first,
        'description': responseData['description'],
      },
    );
  }

  Payment _mapStripeRefundToPayment(
    Map<String, dynamic> refundData,
    String originalPaymentIntentId,
  ) => Payment(
      id: refundData['id'] as String,
      orderId: refundData['metadata']?['order_id'] as String? ?? '',
      provider: PaymentProvider.stripe,
      amount: _convertStripeAmountToDouble(
        int.parse(refundData['amount'].toString()),
        refundData['currency'] as String,
      ),
      currency: (refundData['currency'] as String).toUpperCase(),
      status: PaymentTransactionStatus.refunded,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (refundData['created'] as int) * 1000,
      ),
      updatedAt: DateTime.now(),
      transactionId: refundData['charge'] as String?,
      referenceId: refundData['id'] as String,
      providerResponse: refundData,
      metadata: {
        'refund_reason': refundData['reason'],
        'original_payment_intent': originalPaymentIntentId,
      },
    );

  String _convertAmountToStripe(double amount, String currency) {
    // Stripe expects amounts in the smallest currency unit (cents for USD, piastres for EGP)
    int stripeAmount;
    switch (currency.toUpperCase()) {
      case 'USD':
      case 'EUR':
        stripeAmount = (amount * 100).toInt();
        break;
      case 'EGP':
        stripeAmount = (amount * 100).toInt(); // EGP piastres
        break;
      default:
        stripeAmount = (amount * 100).toInt();
    }
    return stripeAmount.toString();
  }

  double _convertStripeAmountToDouble(int stripeAmount, String currency) {
    // Convert from smallest currency unit back to standard unit
    switch (currency.toUpperCase()) {
      case 'USD':
      case 'EUR':
        return stripeAmount / 100.0;
      case 'EGP':
        return stripeAmount / 100.0; // EGP piastres
      default:
        return stripeAmount / 100.0;
    }
  }

  void dispose() {
    _client.close();
  }
}

class StripePaymentException implements Exception {

  StripePaymentException(this.message);
  final String message;

  @override
  String toString() => 'StripePaymentException: $message';
}