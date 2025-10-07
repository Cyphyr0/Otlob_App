import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "../../domain/entities/payment.dart";
import "../../domain/repositories/payment_repository.dart";
import "../services/stripe_payment_service.dart";
import "../services/fawry_payment_service.dart";
import "../services/vodafone_cash_payment_service.dart";
import "../services/meeza_payment_service.dart";

class FirebasePaymentRepository implements PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Payment service instances (would be injected in production)
  late final StripePaymentService _stripeService;
  late final FawryPaymentService _fawryService;
  late final VodafoneCashPaymentService _vodafoneService;
  late final MeezaPaymentService _meezaService;

  FirebasePaymentRepository() {
    _initializePaymentServices();
  }

  void _initializePaymentServices() {
    // These would typically come from environment variables or secure config
    const String stripeSecretKey = "sk_test_your_stripe_secret_key";
    const String fawryMerchantCode = "your_fawry_merchant_code";
    const String fawrySecurityKey = "your_fawry_security_key";
    const String vodafoneMerchantId = "your_vodafone_merchant_id";
    const String vodafoneApiKey = "your_vodafone_api_key";
    const String vodafoneSecretKey = "your_vodafone_secret_key";
    const String meezaMerchantId = "your_meeza_merchant_id";
    const String meezaTerminalId = "your_meeza_terminal_id";
    const String meezaApiKey = "your_meeza_api_key";
    const String meezaSecretKey = "your_meeza_secret_key";

    _stripeService = StripePaymentService(stripeSecretKey);
    _fawryService = FawryPaymentService(fawryMerchantCode, fawrySecurityKey);
    _vodafoneService = VodafoneCashPaymentService(
      vodafoneMerchantId,
      vodafoneApiKey,
      vodafoneSecretKey,
    );
    _meezaService = MeezaPaymentService(
      meezaMerchantId,
      meezaTerminalId,
      meezaApiKey,
      meezaSecretKey,
    );
  }

  @override
  Future<PaymentIntent> createPaymentIntent({
    required String orderId,
    required PaymentProvider provider,
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final String userId = _auth.currentUser?.uid ?? "";

      switch (provider) {
        case PaymentProvider.stripe:
          final intent = await _stripeService.createPaymentIntent(
            amount: amount,
            currency: currency,
            orderId: orderId,
            customerEmail: metadata?["customerEmail"],
            customerPhone: metadata?["customerPhone"],
          );

          // Save payment intent to Firestore
          await _savePaymentIntent(intent, userId);
          return intent;

        case PaymentProvider.fawry:
          final intent = await _fawryService.createPayment(
            orderId: orderId,
            amount: amount,
            currency: currency,
            customerName: metadata?["customerName"] ?? "Customer",
            customerEmail: metadata?["customerEmail"] ?? "",
            customerMobile: metadata?["customerMobile"] ?? "",
            description: metadata?["description"],
          );

          // Save payment intent to Firestore
          await _savePaymentIntent(intent, userId);
          return intent;

        case PaymentProvider.vodafoneCash:
          final intent = await _vodafoneService.createPayment(
            orderId: orderId,
            amount: amount,
            currency: currency,
            subscriberNumber: metadata?["subscriberNumber"] ?? "",
            subscriberName: metadata?["subscriberName"],
            description: metadata?["description"],
          );

          // Save payment intent to Firestore
          await _savePaymentIntent(intent, userId);
          return intent;

        case PaymentProvider.meeza:
          final intent = await _meezaService.createPayment(
            orderId: orderId,
            amount: amount,
            currency: currency,
            cardToken: metadata?["cardToken"] ?? "",
            customerEmail: metadata?["customerEmail"],
            customerPhone: metadata?["customerPhone"],
            description: metadata?["description"],
          );

          // Save payment intent to Firestore
          await _savePaymentIntent(intent, userId);
          return intent;
      }
    } catch (e) {
      throw PaymentRepositoryException("Failed to create payment intent: $e");
    }
  }

  @override
  Future<Payment> processPayment({
    required String paymentIntentId,
    required dynamic paymentData,
  }) async {
    try {
      final String userId = _auth.currentUser?.uid ?? "";

      // Get payment intent from Firestore to determine provider
      final intentDoc = await _firestore
          .collection("payment_intents")
          .doc(paymentIntentId)
          .get();

      if (!intentDoc.exists) {
        throw PaymentRepositoryException("Payment intent not found");
      }

      final intentData = intentDoc.data()!;
      final PaymentProvider provider = PaymentProvider.values.firstWhere(
        (p) => p.toString() == intentData["provider"],
      );

      Payment payment;

      switch (provider) {
        case PaymentProvider.stripe:
          final stripeData = paymentData as StripePaymentData;
          payment = await _stripeService.confirmPayment(
            paymentIntentId: paymentIntentId,
            paymentMethodId: stripeData.paymentMethodId,
          );
          break;

        case PaymentProvider.fawry:
          // Fawry payments are usually confirmed via webhooks or manual confirmation
          payment = await _fawryService.getPaymentStatus(paymentIntentId);
          break;

        case PaymentProvider.vodafoneCash:
          // Vodafone CASH payments are usually confirmed via webhooks or callbacks
          payment = await _vodafoneService.getPaymentStatus(paymentIntentId);
          break;

        case PaymentProvider.meeza:
          final meezaData = paymentData as MeezaPaymentData;
          payment = await _meezaService.processTokenPayment(
            transactionId: paymentIntentId,
            cardToken: meezaData.cardToken,
            cvv: "123", // This would come from user input
          );
          break;
      }

      // Save payment to Firestore
      await _savePayment(payment, userId);
      return payment;
    } catch (e) {
      throw PaymentRepositoryException("Failed to process payment: $e");
    }
  }

  @override
  Future<Payment?> getPaymentById(String paymentId) async {
    try {
      final doc = await _firestore.collection("payments").doc(paymentId).get();

      if (doc.exists) {
        return Payment.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw PaymentRepositoryException("Failed to get payment: $e");
    }
  }

  @override
  Future<List<Payment>> getPaymentsByOrderId(String orderId) async {
    try {
      final snapshot = await _firestore
          .collection("payments")
          .where("orderId", isEqualTo: orderId)
          .orderBy("createdAt", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Payment.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw PaymentRepositoryException("Failed to get payments by order: $e");
    }
  }

  @override
  Future<Payment> confirmPayment(String paymentId) async {
    try {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw PaymentRepositoryException("Payment not found");
      }

      // Update payment status to completed
      final confirmedPayment = payment.copyWith(
        status: PaymentTransactionStatus.completed,
        updatedAt: DateTime.now(),
      );

      await _updatePayment(confirmedPayment);
      return confirmedPayment;
    } catch (e) {
      throw PaymentRepositoryException("Failed to confirm payment: $e");
    }
  }

  @override
  Future<Payment> cancelPayment(String paymentId) async {
    try {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw PaymentRepositoryException("Payment not found");
      }

      Payment cancelledPayment;

      // Cancel with the appropriate service
      switch (payment.provider) {
        case PaymentProvider.stripe:
          cancelledPayment = await _stripeService.cancelPayment(paymentId);
          break;
        case PaymentProvider.fawry:
          cancelledPayment = await _fawryService.cancelPayment(paymentId);
          break;
        case PaymentProvider.vodafoneCash:
          cancelledPayment = await _vodafoneService.cancelPayment(paymentId);
          break;
        case PaymentProvider.meeza:
          cancelledPayment = await _meezaService.cancelPayment(paymentId);
          break;
      }

      await _updatePayment(cancelledPayment);
      return cancelledPayment;
    } catch (e) {
      throw PaymentRepositoryException("Failed to cancel payment: $e");
    }
  }

  @override
  Future<Payment> refundPayment(String paymentId, double? amount) async {
    try {
      final payment = await getPaymentById(paymentId);
      if (payment == null) {
        throw PaymentRepositoryException("Payment not found");
      }

      Payment refundedPayment;

      // Refund with the appropriate service
      switch (payment.provider) {
        case PaymentProvider.stripe:
          refundedPayment = await _stripeService.refundPayment(
            paymentIntentId: paymentId,
            amount: amount,
          );
          break;
        case PaymentProvider.fawry:
          refundedPayment = await _fawryService.refundPayment(
            referenceNumber: paymentId,
            amount: amount,
          );
          break;
        case PaymentProvider.vodafoneCash:
          refundedPayment = await _vodafoneService.refundPayment(
            transactionId: paymentId,
            amount: amount,
          );
          break;
        case PaymentProvider.meeza:
          refundedPayment = await _meezaService.refundPayment(
            transactionId: paymentId,
            amount: amount,
          );
          break;
      }

      await _updatePayment(refundedPayment);
      return refundedPayment;
    } catch (e) {
      throw PaymentRepositoryException("Failed to refund payment: $e");
    }
  }

  @override
  Future<List<PaymentProvider>> getSupportedProviders() async {
    // Return all supported providers
    return PaymentProvider.values;
  }

  Future<void> _savePaymentIntent(PaymentIntent intent, String userId) async {
    await _firestore.collection("payment_intents").doc(intent.id).set({
      "id": intent.id,
      "orderId": intent.orderId,
      "provider": intent.provider.toString(),
      "amount": intent.amount,
      "currency": intent.currency,
      "clientSecret": intent.clientSecret,
      "customerId": intent.customerId,
      "metadata": intent.metadata,
      "userId": userId,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> _savePayment(Payment payment, String userId) async {
    await _firestore.collection("payments").doc(payment.id).set({
      ...payment.toJson(),
      "userId": userId,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updatePayment(Payment payment) async {
    await _firestore.collection("payments").doc(payment.id).update({
      ...payment.toJson(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  void dispose() {
    _stripeService.dispose();
    _fawryService.dispose();
    _vodafoneService.dispose();
    _meezaService.dispose();
  }
}

class PaymentRepositoryException implements Exception {
  final String message;

  PaymentRepositoryException(this.message);

  @override
  String toString() => "PaymentRepositoryException: $message";
}