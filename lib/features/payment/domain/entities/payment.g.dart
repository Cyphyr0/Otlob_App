// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentTransactionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      transactionId: json['transactionId'] as String?,
      referenceId: json['referenceId'] as String?,
      failureReason: json['failureReason'] as String?,
      providerResponse: json['providerResponse'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$PaymentTransactionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'transactionId': instance.transactionId,
      'referenceId': instance.referenceId,
      'failureReason': instance.failureReason,
      'providerResponse': instance.providerResponse,
      'metadata': instance.metadata,
    };

const _$PaymentProviderEnumMap = {
  PaymentProvider.stripe: 'stripe',
  PaymentProvider.fawry: 'fawry',
  PaymentProvider.vodafoneCash: 'vodafoneCash',
  PaymentProvider.meeza: 'meeza',
};

const _$PaymentTransactionStatusEnumMap = {
  PaymentTransactionStatus.pending: 'pending',
  PaymentTransactionStatus.processing: 'processing',
  PaymentTransactionStatus.completed: 'completed',
  PaymentTransactionStatus.failed: 'failed',
  PaymentTransactionStatus.cancelled: 'cancelled',
  PaymentTransactionStatus.refunded: 'refunded',
};

_$PaymentIntentImpl _$$PaymentIntentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentIntentImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      provider: $enumDecode(_$PaymentProviderEnumMap, json['provider']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      clientSecret: json['clientSecret'] as String,
      customerId: json['customerId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentIntentImplToJson(_$PaymentIntentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'provider': _$PaymentProviderEnumMap[instance.provider]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'clientSecret': instance.clientSecret,
      'customerId': instance.customerId,
      'metadata': instance.metadata,
    };

_$FawryPaymentDataImpl _$$FawryPaymentDataImplFromJson(
  Map<String, dynamic> json,
) => _$FawryPaymentDataImpl(
  merchantRefNum: json['merchantRefNum'] as String,
  customerMobile: json['customerMobile'] as String,
  customerEmail: json['customerEmail'] as String,
  customerName: json['customerName'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$FawryPaymentDataImplToJson(
  _$FawryPaymentDataImpl instance,
) => <String, dynamic>{
  'merchantRefNum': instance.merchantRefNum,
  'customerMobile': instance.customerMobile,
  'customerEmail': instance.customerEmail,
  'customerName': instance.customerName,
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
};

_$VodafoneCashPaymentDataImpl _$$VodafoneCashPaymentDataImplFromJson(
  Map<String, dynamic> json,
) => _$VodafoneCashPaymentDataImpl(
  phoneNumber: json['phoneNumber'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  description: json['description'] as String?,
  subscriberName: json['subscriberName'] as String?,
);

Map<String, dynamic> _$$VodafoneCashPaymentDataImplToJson(
  _$VodafoneCashPaymentDataImpl instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
  'subscriberName': instance.subscriberName,
};

_$MeezaPaymentDataImpl _$$MeezaPaymentDataImplFromJson(
  Map<String, dynamic> json,
) => _$MeezaPaymentDataImpl(
  cardToken: json['cardToken'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  description: json['description'] as String?,
  customerEmail: json['customerEmail'] as String?,
  customerPhone: json['customerPhone'] as String?,
);

Map<String, dynamic> _$$MeezaPaymentDataImplToJson(
  _$MeezaPaymentDataImpl instance,
) => <String, dynamic>{
  'cardToken': instance.cardToken,
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
  'customerEmail': instance.customerEmail,
  'customerPhone': instance.customerPhone,
};

_$StripePaymentDataImpl _$$StripePaymentDataImplFromJson(
  Map<String, dynamic> json,
) => _$StripePaymentDataImpl(
  paymentMethodId: json['paymentMethodId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  customerId: json['customerId'] as String?,
  description: json['description'] as String?,
  metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$$StripePaymentDataImplToJson(
  _$StripePaymentDataImpl instance,
) => <String, dynamic>{
  'paymentMethodId': instance.paymentMethodId,
  'amount': instance.amount,
  'currency': instance.currency,
  'customerId': instance.customerId,
  'description': instance.description,
  'metadata': instance.metadata,
};
