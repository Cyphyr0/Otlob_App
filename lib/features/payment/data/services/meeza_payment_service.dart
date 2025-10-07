import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/payment.dart';

class MeezaPaymentService {

  MeezaPaymentService(
    this._merchantId,
    this._terminalId,
    this._apiKey,
    this._secretKey, {
    http.Client? client,
  }) : _client = client ?? http.Client();
  static const String _baseUrl = 'https://api.meeza.eg';
  final String _merchantId;
  final String _terminalId;
  final String _apiKey;
  final String _secretKey;
  final http.Client _client;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Merchant-ID': _merchantId,
        'X-API-Key': _apiKey,
      };

  /// Create a Meeza payment request
  Future<PaymentIntent> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String cardToken,
    String? customerEmail,
    String? customerPhone,
    String? description,
  }) async {
    try {
      final referenceNumber = _generateReferenceNumber(orderId);
      final signature = _generateSignature(referenceNumber, amount);

      final paymentData = <String, dynamic>{
        'merchantId': _merchantId,
        'terminalId': _terminalId,
        'referenceNumber': referenceNumber,
        'cardToken': cardToken,
        'amount': amount,
        'currency': currency,
        'description': description ?? 'Order Payment - $orderId',
        'signature': signature,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'callbackUrl': 'https://yourapp.com/payment/callback/meeza',
        'language': 'en',
        'paymentType': 'TOKENIZED',
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/payments/process'),
        headers: _headers,
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return PaymentIntent(
          id: responseData['transactionId'] as String? ?? referenceNumber,
          orderId: orderId,
          provider: PaymentProvider.meeza,
          amount: amount,
          currency: currency,
          clientSecret: responseData['transactionId'] as String? ?? referenceNumber,
          metadata: {
            'referenceNumber': referenceNumber,
            'cardToken': cardToken,
            'transactionId': responseData['transactionId'],
          },
        );
      } else {
        throw MeezaPaymentException(
          'Failed to create Meeza payment: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error creating Meeza payment: $e');
    }
  }

  /// Process tokenized card payment
  Future<Payment> processTokenPayment({
    required String transactionId,
    required String cardToken,
    required String cvv,
  }) async {
    try {
      final tokenData = <String, dynamic>{
        'transactionId': transactionId,
        'cardToken': cardToken,
        'cvv': cvv,
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/payments/token/process'),
        headers: _headers,
        body: json.encode(tokenData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapMeezaResponseToPayment(responseData);
      } else {
        throw MeezaPaymentException(
          'Failed to process token payment: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error processing token payment: $e');
    }
  }

  /// Get payment status
  Future<Payment> getPaymentStatus(String transactionId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/payments/status/$transactionId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapMeezaResponseToPayment(responseData);
      } else {
        throw MeezaPaymentException(
          'Failed to get payment status: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error getting payment status: $e');
    }
  }

  /// Confirm payment (usually called via webhook or callback)
  Future<Payment> confirmPayment({
    required String transactionId,
    required String referenceNumber,
  }) async {
    try {
      final confirmationData = <String, String>{
        'transactionId': transactionId,
        'referenceNumber': referenceNumber,
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/payments/confirm'),
        headers: _headers,
        body: json.encode(confirmationData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapMeezaResponseToPayment(responseData);
      } else {
        throw MeezaPaymentException(
          'Failed to confirm payment: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error confirming payment: $e');
    }
  }

  /// Cancel payment
  Future<Payment> cancelPayment(String transactionId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/api/payments/$transactionId/cancel'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapMeezaResponseToPayment(responseData);
      } else {
        throw MeezaPaymentException(
          'Failed to cancel payment: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error canceling payment: $e');
    }
  }

  /// Refund payment
  Future<Payment> refundPayment({
    required String transactionId,
    double? amount,
  }) async {
    try {
      final refundData = <String, dynamic>{
        'transactionId': transactionId,
        if (amount != null) 'amount': amount,
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/payments/$transactionId/refund'),
        headers: _headers,
        body: json.encode(refundData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapMeezaResponseToPayment(responseData);
      } else {
        throw MeezaPaymentException(
          'Failed to refund payment: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error refunding payment: $e');
    }
  }

  /// Create card token for future payments
  Future<String> createCardToken({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String customerEmail,
  }) async {
    try {
      final tokenData = <String, dynamic>{
        'cardNumber': cardNumber,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cvv': cvv,
        'customerEmail': customerEmail,
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/api/tokens/create'),
        headers: _headers,
        body: json.encode(tokenData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['token'] as String;
      } else {
        throw MeezaPaymentException(
          'Failed to create card token: ${response.body}',
        );
      }
    } catch (e) {
      throw MeezaPaymentException('Error creating card token: $e');
    }
  }

  Payment _mapMeezaResponseToPayment(Map<String, dynamic> responseData) {
    final orderId = responseData['referenceNumber']?.toString().replaceFirst('ORDER_', '') ?? '';

    PaymentTransactionStatus status;
    switch (responseData['status']?.toString().toLowerCase()) {
      case 'success':
      case 'completed':
      case 'paid':
      case 'captured':
        status = PaymentTransactionStatus.completed;
        break;
      case 'pending':
      case 'processing':
      case 'in_progress':
      case 'authorized':
        status = PaymentTransactionStatus.processing;
        break;
      case 'cancelled':
      case 'canceled':
      case 'voided':
        status = PaymentTransactionStatus.cancelled;
        break;
      case 'failed':
      case 'error':
      case 'declined':
        status = PaymentTransactionStatus.failed;
        break;
      case 'refunded':
        status = PaymentTransactionStatus.refunded;
        break;
      default:
        status = PaymentTransactionStatus.pending;
    }

    return Payment(
      id: responseData['transactionId'] as String? ?? responseData['referenceNumber'] as String? ?? '',
      orderId: orderId,
      provider: PaymentProvider.meeza,
      amount: (responseData['amount'] as num?)?.toDouble() ?? 0.0,
      currency: responseData['currency'] as String? ?? 'EGP',
      status: status,
      createdAt: DateTime.parse(responseData['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.now(),
      transactionId: responseData['transactionId'] as String?,
      referenceId: responseData['referenceNumber'] as String?,
      providerResponse: responseData,
      metadata: {
        'card_token': responseData['cardToken'],
        'payment_time': responseData['paymentTime'],
        'auth_code': responseData['authCode'],
        'rrn': responseData['rrn'], // Retrieval Reference Number
      },
    );
  }

  String _generateReferenceNumber(String orderId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ORDER_${orderId}_MZ_$timestamp';
  }

  String _generateSignature(String referenceNumber, double amount) {
    final data = '$_merchantId$_terminalId$referenceNumber${amount.toStringAsFixed(2)}$_secretKey';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void dispose() {
    _client.close();
  }
}

class MeezaPaymentException implements Exception {

  MeezaPaymentException(this.message);
  final String message;

  @override
  String toString() => 'MeezaPaymentException: $message';
}