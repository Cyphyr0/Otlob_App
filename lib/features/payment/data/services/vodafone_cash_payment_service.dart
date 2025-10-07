import "dart:convert";
import "package:http/http.dart" as http;
import "package:crypto/crypto.dart";
import "../../domain/entities/payment.dart";

class VodafoneCashPaymentService {
  static const String _baseUrl = "https://vodafonecash.api.eg";
  final String _merchantId;
  final String _apiKey;
  final String _secretKey;
  final http.Client _client;

  VodafoneCashPaymentService(
    this._merchantId,
    this._apiKey,
    this._secretKey, {
    http.Client? client,
  }) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-API-Key": _apiKey,
      };

  /// Create a Vodafone CASH payment request
  Future<PaymentIntent> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String subscriberNumber,
    String? subscriberName,
    String? description,
  }) async {
    try {
      final String referenceNumber = _generateReferenceNumber(orderId);
      final String signature = _generateSignature(referenceNumber, amount);

      final Map<String, dynamic> paymentData = {
        "merchantId": _merchantId,
        "referenceNumber": referenceNumber,
        "subscriberNumber": subscriberNumber,
        "subscriberName": subscriberName ?? "Customer",
        "amount": amount,
        "currency": currency,
        "description": description ?? "Order Payment - $orderId",
        "signature": signature,
        "callbackUrl": "https://yourapp.com/payment/callback/vodafone",
        "language": "en",
      };

      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/charge"),
        headers: _headers,
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return PaymentIntent(
          id: responseData["transactionId"] as String? ?? referenceNumber,
          orderId: orderId,
          provider: PaymentProvider.vodafoneCash,
          amount: amount,
          currency: currency,
          clientSecret: responseData["transactionId"] as String? ?? referenceNumber,
          metadata: {
            "referenceNumber": referenceNumber,
            "subscriberNumber": subscriberNumber,
            "transactionId": responseData["transactionId"],
          },
        );
      } else {
        throw VodafoneCashPaymentException(
          "Failed to create Vodafone CASH payment: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error creating Vodafone CASH payment: $e");
    }
  }

  /// Check payment status
  Future<Payment> getPaymentStatus(String transactionId) async {
    try {
      final response = await _client.get(
        Uri.parse("$_baseUrl/api/payments/status/$transactionId"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapVodafoneResponseToPayment(responseData);
      } else {
        throw VodafoneCashPaymentException(
          "Failed to get payment status: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error getting payment status: $e");
    }
  }

  /// Confirm payment (usually called via webhook or callback)
  Future<Payment> confirmPayment({
    required String transactionId,
    required String referenceNumber,
  }) async {
    try {
      final Map<String, String> confirmationData = {
        "transactionId": transactionId,
        "referenceNumber": referenceNumber,
      };

      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/confirm"),
        headers: _headers,
        body: json.encode(confirmationData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapVodafoneResponseToPayment(responseData);
      } else {
        throw VodafoneCashPaymentException(
          "Failed to confirm payment: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error confirming payment: $e");
    }
  }

  /// Cancel payment
  Future<Payment> cancelPayment(String transactionId) async {
    try {
      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/$transactionId/cancel"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapVodafoneResponseToPayment(responseData);
      } else {
        throw VodafoneCashPaymentException(
          "Failed to cancel payment: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error canceling payment: $e");
    }
  }

  /// Refund payment
  Future<Payment> refundPayment({
    required String transactionId,
    double? amount,
  }) async {
    try {
      final Map<String, dynamic> refundData = {
        "transactionId": transactionId,
        if (amount != null) "amount": amount,
      };

      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/$transactionId/refund"),
        headers: _headers,
        body: json.encode(refundData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapVodafoneResponseToPayment(responseData);
      } else {
        throw VodafoneCashPaymentException(
          "Failed to refund payment: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error refunding payment: $e");
    }
  }

  /// Query subscriber wallet balance (optional utility method)
  Future<double> getSubscriberBalance(String subscriberNumber) async {
    try {
      final response = await _client.get(
        Uri.parse("$_baseUrl/api/subscriber/$subscriberNumber/balance"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return (responseData["balance"] as num?)?.toDouble() ?? 0.0;
      } else {
        throw VodafoneCashPaymentException(
          "Failed to get subscriber balance: ${response.body}",
        );
      }
    } catch (e) {
      throw VodafoneCashPaymentException("Error getting subscriber balance: $e");
    }
  }

  Payment _mapVodafoneResponseToPayment(Map<String, dynamic> responseData) {
    final String orderId = responseData["referenceNumber"]?.toString().replaceFirst("ORDER_", "") ?? "";

    PaymentTransactionStatus status;
    switch (responseData["status"]?.toString().toLowerCase()) {
      case "success":
      case "completed":
      case "paid":
        status = PaymentTransactionStatus.completed;
        break;
      case "pending":
      case "processing":
      case "in_progress":
        status = PaymentTransactionStatus.processing;
        break;
      case "cancelled":
      case "canceled":
        status = PaymentTransactionStatus.cancelled;
        break;
      case "failed":
      case "error":
        status = PaymentTransactionStatus.failed;
        break;
      case "refunded":
        status = PaymentTransactionStatus.refunded;
        break;
      default:
        status = PaymentTransactionStatus.pending;
    }

    return Payment(
      id: responseData["transactionId"] as String? ?? responseData["referenceNumber"] as String? ?? "",
      orderId: orderId,
      provider: PaymentProvider.vodafoneCash,
      amount: (responseData["amount"] as num?)?.toDouble() ?? 0.0,
      currency: responseData["currency"] as String? ?? "EGP",
      status: status,
      createdAt: DateTime.parse(responseData["createdAt"] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.now(),
      transactionId: responseData["transactionId"] as String?,
      referenceId: responseData["referenceNumber"] as String?,
      providerResponse: responseData,
      metadata: {
        "subscriber_number": responseData["subscriberNumber"],
        "subscriber_name": responseData["subscriberName"],
        "payment_time": responseData["paymentTime"],
      },
    );
  }

  String _generateReferenceNumber(String orderId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return "ORDER_${orderId}_VC_$timestamp";
  }

  String _generateSignature(String referenceNumber, double amount) {
    final data = "$_merchantId$referenceNumber${amount.toStringAsFixed(2)}$_secretKey";
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void dispose() {
    _client.close();
  }
}

class VodafoneCashPaymentException implements Exception {
  final String message;

  VodafoneCashPaymentException(this.message);

  @override
  String toString() => "VodafoneCashPaymentException: $message";
}