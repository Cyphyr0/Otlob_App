import "dart:convert";
import "package:http/http.dart" as http;
import "package:crypto/crypto.dart";
import "../../domain/entities/payment.dart";

class FawryPaymentService {
  static const String _baseUrl = "https://www.atfawry.com";
  final String _merchantCode;
  final String _securityKey;
  final http.Client _client;

  FawryPaymentService(
    this._merchantCode,
    this._securityKey, {
    http.Client? client,
  }) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  /// Create a Fawry payment
  Future<PaymentIntent> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String customerName,
    required String customerEmail,
    required String customerMobile,
    String? description,
  }) async {
    try {
      final String merchantRefNum = _generateMerchantRefNum(orderId);
      final String signature = _generateSignature(merchantRefNum, amount, currency);

      final Map<String, dynamic> paymentData = {
        "merchantCode": _merchantCode,
        "merchantRefNum": merchantRefNum,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "amount": amount,
        "currency": currency,
        "description": description ?? "Order Payment - $orderId",
        "signature": signature,
        "paymentMethod": "PAYATFAWRY", // Fawry outlet payment
        "language": "en",
        "chargeItems": [
          {
            "itemId": "ORDER_$orderId",
            "description": description ?? "Order Payment",
            "quantity": 1,
            "price": amount,
          }
        ],
      };

      // For Fawry, we create a payment reference that can be used at Fawry outlets
      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/init"),
        headers: _headers,
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return PaymentIntent(
          id: responseData["referenceNumber"] as String? ?? merchantRefNum,
          orderId: orderId,
          provider: PaymentProvider.fawry,
          amount: amount,
          currency: currency,
          clientSecret: responseData["referenceNumber"] as String? ?? merchantRefNum,
          metadata: {
            "merchantRefNum": merchantRefNum,
            "paymentUrl": responseData["paymentUrl"],
            " FawryRefNum": responseData["fawryRefNum"],
          },
        );
      } else {
        throw FawryPaymentException(
          "Failed to create Fawry payment: ${response.body}",
        );
      }
    } catch (e) {
      throw FawryPaymentException("Error creating Fawry payment: $e");
    }
  }

  /// Get payment status from Fawry
  Future<Payment> getPaymentStatus(String referenceNumber) async {
    try {
      final response = await _client.get(
        Uri.parse("$_baseUrl/api/payments/status/$referenceNumber"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapFawryResponseToPayment(responseData);
      } else {
        throw FawryPaymentException(
          "Failed to get payment status: ${response.body}",
        );
      }
    } catch (e) {
      throw FawryPaymentException("Error getting payment status: $e");
    }
  }

  /// Process Fawry payment confirmation (usually called via webhook)
  Future<Payment> confirmPayment({
    required String referenceNumber,
    required String fawryRefNum,
  }) async {
    try {
      final Map<String, String> confirmationData = {
        "referenceNumber": referenceNumber,
        "fawryRefNum": fawryRefNum,
      };

      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/confirm"),
        headers: _headers,
        body: json.encode(confirmationData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapFawryResponseToPayment(responseData);
      } else {
        throw FawryPaymentException(
          "Failed to confirm payment: ${response.body}",
        );
      }
    } catch (e) {
      throw FawryPaymentException("Error confirming payment: $e");
    }
  }

  /// Cancel Fawry payment
  Future<Payment> cancelPayment(String referenceNumber) async {
    try {
      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/$referenceNumber/cancel"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapFawryResponseToPayment(responseData);
      } else {
        throw FawryPaymentException(
          "Failed to cancel payment: ${response.body}",
        );
      }
    } catch (e) {
      throw FawryPaymentException("Error canceling payment: $e");
    }
  }

  /// Refund Fawry payment
  Future<Payment> refundPayment({
    required String referenceNumber,
    double? amount,
  }) async {
    try {
      final Map<String, dynamic> refundData = {
        "referenceNumber": referenceNumber,
        if (amount != null) "amount": amount,
      };

      final response = await _client.post(
        Uri.parse("$_baseUrl/api/payments/$referenceNumber/refund"),
        headers: _headers,
        body: json.encode(refundData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return _mapFawryResponseToPayment(responseData);
      } else {
        throw FawryPaymentException(
          "Failed to refund payment: ${response.body}",
        );
      }
    } catch (e) {
      throw FawryPaymentException("Error refunding payment: $e");
    }
  }

  Payment _mapFawryResponseToPayment(Map<String, dynamic> responseData) {
    final String orderId = responseData["merchantRefNum"]?.toString().replaceFirst("ORDER_", "") ?? "";

    PaymentTransactionStatus status;
    switch (responseData["status"]?.toString().toLowerCase()) {
      case "paid":
      case "success":
        status = PaymentTransactionStatus.completed;
        break;
      case "pending":
      case "in_progress":
        status = PaymentTransactionStatus.processing;
        break;
      case "cancelled":
      case "canceled":
        status = PaymentTransactionStatus.cancelled;
        break;
      case "expired":
        status = PaymentTransactionStatus.failed;
        break;
      case "refunded":
        status = PaymentTransactionStatus.refunded;
        break;
      default:
        status = PaymentTransactionStatus.pending;
    }

    return Payment(
      id: responseData["referenceNumber"] as String? ?? responseData["fawryRefNum"] as String? ?? "",
      orderId: orderId,
      provider: PaymentProvider.fawry,
      amount: (responseData["amount"] as num?)?.toDouble() ?? 0.0,
      currency: responseData["currency"] as String? ?? "EGP",
      status: status,
      createdAt: DateTime.parse(responseData["createdAt"] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.now(),
      transactionId: responseData["fawryRefNum"] as String?,
      referenceId: responseData["referenceNumber"] as String?,
      providerResponse: responseData,
      metadata: {
        "payment_method": responseData["paymentMethod"],
        "payment_time": responseData["paymentTime"],
        "outlet_code": responseData["outletCode"],
      },
    );
  }

  String _generateMerchantRefNum(String orderId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return "ORDER_${orderId}_$timestamp";
  }

  String _generateSignature(String merchantRefNum, double amount, String currency) {
    final data = "$_merchantCode$merchantRefNum${amount.toStringAsFixed(2)}$currency$_securityKey";
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void dispose() {
    _client.close();
  }
}

class FawryPaymentException implements Exception {
  final String message;

  FawryPaymentException(this.message);

  @override
  String toString() => "FawryPaymentException: $message";
}