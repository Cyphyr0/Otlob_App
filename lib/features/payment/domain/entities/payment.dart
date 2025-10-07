import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

enum PaymentProvider {
  stripe,
  fawry,
  vodafoneCash,
  meeza,
}

enum PaymentTransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required PaymentProvider provider,
    required double amount,
    required String currency,
    required PaymentTransactionStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? transactionId,
    String? referenceId,
    String? failureReason,
    Map<String, dynamic>? providerResponse,
    Map<String, dynamic>? metadata,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}

@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    required String id,
    required String orderId,
    required PaymentProvider provider,
    required double amount,
    required String currency,
    required String clientSecret,
    String? customerId,
    Map<String, dynamic>? metadata,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) => _$PaymentIntentFromJson(json);
}

@freezed
class FawryPaymentData with _$FawryPaymentData {
  const factory FawryPaymentData({
    required String merchantRefNum,
    required String customerMobile,
    required String customerEmail,
    required String customerName,
    required double amount,
    required String currency,
    String? description,
  }) = _FawryPaymentData;

  factory FawryPaymentData.fromJson(Map<String, dynamic> json) => _$FawryPaymentDataFromJson(json);
}

@freezed
class VodafoneCashPaymentData with _$VodafoneCashPaymentData {
  const factory VodafoneCashPaymentData({
    required String phoneNumber,
    required double amount,
    required String currency,
    String? description,
    String? subscriberName,
  }) = _VodafoneCashPaymentData;

  factory VodafoneCashPaymentData.fromJson(Map<String, dynamic> json) => _$VodafoneCashPaymentDataFromJson(json);
}

@freezed
class MeezaPaymentData with _$MeezaPaymentData {
  const factory MeezaPaymentData({
    required String cardToken,
    required double amount,
    required String currency,
    String? description,
    String? customerEmail,
    String? customerPhone,
  }) = _MeezaPaymentData;

  factory MeezaPaymentData.fromJson(Map<String, dynamic> json) => _$MeezaPaymentDataFromJson(json);
}

@freezed
class StripePaymentData with _$StripePaymentData {
  const factory StripePaymentData({
    required String paymentMethodId,
    required double amount,
    required String currency,
    String? customerId,
    String? description,
    Map<String, String>? metadata,
  }) = _StripePaymentData;

  factory StripePaymentData.fromJson(Map<String, dynamic> json) => _$StripePaymentDataFromJson(json);
}