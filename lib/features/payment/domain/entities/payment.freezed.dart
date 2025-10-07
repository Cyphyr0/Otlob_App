// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return _Payment.fromJson(json);
}

/// @nodoc
mixin _$Payment {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  PaymentProvider get provider => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  PaymentTransactionStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String? get referenceId => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;
  Map<String, dynamic>? get providerResponse =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCopyWith<Payment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCopyWith<$Res> {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) then) =
      _$PaymentCopyWithImpl<$Res, Payment>;
  @useResult
  $Res call({
    String id,
    String orderId,
    PaymentProvider provider,
    double amount,
    String currency,
    PaymentTransactionStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    String? transactionId,
    String? referenceId,
    String? failureReason,
    Map<String, dynamic>? providerResponse,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$PaymentCopyWithImpl<$Res, $Val extends Payment>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? provider = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? transactionId = freezed,
    Object? referenceId = freezed,
    Object? failureReason = freezed,
    Object? providerResponse = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as PaymentProvider,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaymentTransactionStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            failureReason: freezed == failureReason
                ? _value.failureReason
                : failureReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            providerResponse: freezed == providerResponse
                ? _value.providerResponse
                : providerResponse // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentImplCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$$PaymentImplCopyWith(
    _$PaymentImpl value,
    $Res Function(_$PaymentImpl) then,
  ) = __$$PaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    PaymentProvider provider,
    double amount,
    String currency,
    PaymentTransactionStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    String? transactionId,
    String? referenceId,
    String? failureReason,
    Map<String, dynamic>? providerResponse,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$PaymentImplCopyWithImpl<$Res>
    extends _$PaymentCopyWithImpl<$Res, _$PaymentImpl>
    implements _$$PaymentImplCopyWith<$Res> {
  __$$PaymentImplCopyWithImpl(
    _$PaymentImpl _value,
    $Res Function(_$PaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? provider = null,
    Object? amount = null,
    Object? currency = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? transactionId = freezed,
    Object? referenceId = freezed,
    Object? failureReason = freezed,
    Object? providerResponse = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as PaymentProvider,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaymentTransactionStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        failureReason: freezed == failureReason
            ? _value.failureReason
            : failureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        providerResponse: freezed == providerResponse
            ? _value._providerResponse
            : providerResponse // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentImpl implements _Payment {
  const _$PaymentImpl({
    required this.id,
    required this.orderId,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.transactionId,
    this.referenceId,
    this.failureReason,
    final Map<String, dynamic>? providerResponse,
    final Map<String, dynamic>? metadata,
  }) : _providerResponse = providerResponse,
       _metadata = metadata;

  factory _$PaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final PaymentProvider provider;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final PaymentTransactionStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? transactionId;
  @override
  final String? referenceId;
  @override
  final String? failureReason;
  final Map<String, dynamic>? _providerResponse;
  @override
  Map<String, dynamic>? get providerResponse {
    final value = _providerResponse;
    if (value == null) return null;
    if (_providerResponse is EqualUnmodifiableMapView) return _providerResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Payment(id: $id, orderId: $orderId, provider: $provider, amount: $amount, currency: $currency, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, transactionId: $transactionId, referenceId: $referenceId, failureReason: $failureReason, providerResponse: $providerResponse, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            const DeepCollectionEquality().equals(
              other._providerResponse,
              _providerResponse,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    provider,
    amount,
    currency,
    status,
    createdAt,
    updatedAt,
    transactionId,
    referenceId,
    failureReason,
    const DeepCollectionEquality().hash(_providerResponse),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      __$$PaymentImplCopyWithImpl<_$PaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentImplToJson(this);
  }
}

abstract class _Payment implements Payment {
  const factory _Payment({
    required final String id,
    required final String orderId,
    required final PaymentProvider provider,
    required final double amount,
    required final String currency,
    required final PaymentTransactionStatus status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? transactionId,
    final String? referenceId,
    final String? failureReason,
    final Map<String, dynamic>? providerResponse,
    final Map<String, dynamic>? metadata,
  }) = _$PaymentImpl;

  factory _Payment.fromJson(Map<String, dynamic> json) = _$PaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  PaymentProvider get provider;
  @override
  double get amount;
  @override
  String get currency;
  @override
  PaymentTransactionStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get transactionId;
  @override
  String? get referenceId;
  @override
  String? get failureReason;
  @override
  Map<String, dynamic>? get providerResponse;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Payment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentImplCopyWith<_$PaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentIntent _$PaymentIntentFromJson(Map<String, dynamic> json) {
  return _PaymentIntent.fromJson(json);
}

/// @nodoc
mixin _$PaymentIntent {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  PaymentProvider get provider => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get clientSecret => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentIntent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentIntentCopyWith<PaymentIntent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentIntentCopyWith<$Res> {
  factory $PaymentIntentCopyWith(
    PaymentIntent value,
    $Res Function(PaymentIntent) then,
  ) = _$PaymentIntentCopyWithImpl<$Res, PaymentIntent>;
  @useResult
  $Res call({
    String id,
    String orderId,
    PaymentProvider provider,
    double amount,
    String currency,
    String clientSecret,
    String? customerId,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$PaymentIntentCopyWithImpl<$Res, $Val extends PaymentIntent>
    implements $PaymentIntentCopyWith<$Res> {
  _$PaymentIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? provider = null,
    Object? amount = null,
    Object? currency = null,
    Object? clientSecret = null,
    Object? customerId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as PaymentProvider,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            clientSecret: null == clientSecret
                ? _value.clientSecret
                : clientSecret // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentIntentImplCopyWith<$Res>
    implements $PaymentIntentCopyWith<$Res> {
  factory _$$PaymentIntentImplCopyWith(
    _$PaymentIntentImpl value,
    $Res Function(_$PaymentIntentImpl) then,
  ) = __$$PaymentIntentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    PaymentProvider provider,
    double amount,
    String currency,
    String clientSecret,
    String? customerId,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$PaymentIntentImplCopyWithImpl<$Res>
    extends _$PaymentIntentCopyWithImpl<$Res, _$PaymentIntentImpl>
    implements _$$PaymentIntentImplCopyWith<$Res> {
  __$$PaymentIntentImplCopyWithImpl(
    _$PaymentIntentImpl _value,
    $Res Function(_$PaymentIntentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? provider = null,
    Object? amount = null,
    Object? currency = null,
    Object? clientSecret = null,
    Object? customerId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PaymentIntentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as PaymentProvider,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        clientSecret: null == clientSecret
            ? _value.clientSecret
            : clientSecret // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentIntentImpl implements _PaymentIntent {
  const _$PaymentIntentImpl({
    required this.id,
    required this.orderId,
    required this.provider,
    required this.amount,
    required this.currency,
    required this.clientSecret,
    this.customerId,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$PaymentIntentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentIntentImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final PaymentProvider provider;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String clientSecret;
  @override
  final String? customerId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaymentIntent(id: $id, orderId: $orderId, provider: $provider, amount: $amount, currency: $currency, clientSecret: $clientSecret, customerId: $customerId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentIntentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    provider,
    amount,
    currency,
    clientSecret,
    customerId,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      __$$PaymentIntentImplCopyWithImpl<_$PaymentIntentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentIntentImplToJson(this);
  }
}

abstract class _PaymentIntent implements PaymentIntent {
  const factory _PaymentIntent({
    required final String id,
    required final String orderId,
    required final PaymentProvider provider,
    required final double amount,
    required final String currency,
    required final String clientSecret,
    final String? customerId,
    final Map<String, dynamic>? metadata,
  }) = _$PaymentIntentImpl;

  factory _PaymentIntent.fromJson(Map<String, dynamic> json) =
      _$PaymentIntentImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  PaymentProvider get provider;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get clientSecret;
  @override
  String? get customerId;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FawryPaymentData _$FawryPaymentDataFromJson(Map<String, dynamic> json) {
  return _FawryPaymentData.fromJson(json);
}

/// @nodoc
mixin _$FawryPaymentData {
  String get merchantRefNum => throw _privateConstructorUsedError;
  String get customerMobile => throw _privateConstructorUsedError;
  String get customerEmail => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this FawryPaymentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FawryPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FawryPaymentDataCopyWith<FawryPaymentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FawryPaymentDataCopyWith<$Res> {
  factory $FawryPaymentDataCopyWith(
    FawryPaymentData value,
    $Res Function(FawryPaymentData) then,
  ) = _$FawryPaymentDataCopyWithImpl<$Res, FawryPaymentData>;
  @useResult
  $Res call({
    String merchantRefNum,
    String customerMobile,
    String customerEmail,
    String customerName,
    double amount,
    String currency,
    String? description,
  });
}

/// @nodoc
class _$FawryPaymentDataCopyWithImpl<$Res, $Val extends FawryPaymentData>
    implements $FawryPaymentDataCopyWith<$Res> {
  _$FawryPaymentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FawryPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantRefNum = null,
    Object? customerMobile = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            merchantRefNum: null == merchantRefNum
                ? _value.merchantRefNum
                : merchantRefNum // ignore: cast_nullable_to_non_nullable
                      as String,
            customerMobile: null == customerMobile
                ? _value.customerMobile
                : customerMobile // ignore: cast_nullable_to_non_nullable
                      as String,
            customerEmail: null == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FawryPaymentDataImplCopyWith<$Res>
    implements $FawryPaymentDataCopyWith<$Res> {
  factory _$$FawryPaymentDataImplCopyWith(
    _$FawryPaymentDataImpl value,
    $Res Function(_$FawryPaymentDataImpl) then,
  ) = __$$FawryPaymentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String merchantRefNum,
    String customerMobile,
    String customerEmail,
    String customerName,
    double amount,
    String currency,
    String? description,
  });
}

/// @nodoc
class __$$FawryPaymentDataImplCopyWithImpl<$Res>
    extends _$FawryPaymentDataCopyWithImpl<$Res, _$FawryPaymentDataImpl>
    implements _$$FawryPaymentDataImplCopyWith<$Res> {
  __$$FawryPaymentDataImplCopyWithImpl(
    _$FawryPaymentDataImpl _value,
    $Res Function(_$FawryPaymentDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FawryPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchantRefNum = null,
    Object? customerMobile = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
  }) {
    return _then(
      _$FawryPaymentDataImpl(
        merchantRefNum: null == merchantRefNum
            ? _value.merchantRefNum
            : merchantRefNum // ignore: cast_nullable_to_non_nullable
                  as String,
        customerMobile: null == customerMobile
            ? _value.customerMobile
            : customerMobile // ignore: cast_nullable_to_non_nullable
                  as String,
        customerEmail: null == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FawryPaymentDataImpl implements _FawryPaymentData {
  const _$FawryPaymentDataImpl({
    required this.merchantRefNum,
    required this.customerMobile,
    required this.customerEmail,
    required this.customerName,
    required this.amount,
    required this.currency,
    this.description,
  });

  factory _$FawryPaymentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FawryPaymentDataImplFromJson(json);

  @override
  final String merchantRefNum;
  @override
  final String customerMobile;
  @override
  final String customerEmail;
  @override
  final String customerName;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String? description;

  @override
  String toString() {
    return 'FawryPaymentData(merchantRefNum: $merchantRefNum, customerMobile: $customerMobile, customerEmail: $customerEmail, customerName: $customerName, amount: $amount, currency: $currency, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FawryPaymentDataImpl &&
            (identical(other.merchantRefNum, merchantRefNum) ||
                other.merchantRefNum == merchantRefNum) &&
            (identical(other.customerMobile, customerMobile) ||
                other.customerMobile == customerMobile) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    merchantRefNum,
    customerMobile,
    customerEmail,
    customerName,
    amount,
    currency,
    description,
  );

  /// Create a copy of FawryPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FawryPaymentDataImplCopyWith<_$FawryPaymentDataImpl> get copyWith =>
      __$$FawryPaymentDataImplCopyWithImpl<_$FawryPaymentDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FawryPaymentDataImplToJson(this);
  }
}

abstract class _FawryPaymentData implements FawryPaymentData {
  const factory _FawryPaymentData({
    required final String merchantRefNum,
    required final String customerMobile,
    required final String customerEmail,
    required final String customerName,
    required final double amount,
    required final String currency,
    final String? description,
  }) = _$FawryPaymentDataImpl;

  factory _FawryPaymentData.fromJson(Map<String, dynamic> json) =
      _$FawryPaymentDataImpl.fromJson;

  @override
  String get merchantRefNum;
  @override
  String get customerMobile;
  @override
  String get customerEmail;
  @override
  String get customerName;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String? get description;

  /// Create a copy of FawryPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FawryPaymentDataImplCopyWith<_$FawryPaymentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VodafoneCashPaymentData _$VodafoneCashPaymentDataFromJson(
  Map<String, dynamic> json,
) {
  return _VodafoneCashPaymentData.fromJson(json);
}

/// @nodoc
mixin _$VodafoneCashPaymentData {
  String get phoneNumber => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get subscriberName => throw _privateConstructorUsedError;

  /// Serializes this VodafoneCashPaymentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VodafoneCashPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VodafoneCashPaymentDataCopyWith<VodafoneCashPaymentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VodafoneCashPaymentDataCopyWith<$Res> {
  factory $VodafoneCashPaymentDataCopyWith(
    VodafoneCashPaymentData value,
    $Res Function(VodafoneCashPaymentData) then,
  ) = _$VodafoneCashPaymentDataCopyWithImpl<$Res, VodafoneCashPaymentData>;
  @useResult
  $Res call({
    String phoneNumber,
    double amount,
    String currency,
    String? description,
    String? subscriberName,
  });
}

/// @nodoc
class _$VodafoneCashPaymentDataCopyWithImpl<
  $Res,
  $Val extends VodafoneCashPaymentData
>
    implements $VodafoneCashPaymentDataCopyWith<$Res> {
  _$VodafoneCashPaymentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VodafoneCashPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? subscriberName = freezed,
  }) {
    return _then(
      _value.copyWith(
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            subscriberName: freezed == subscriberName
                ? _value.subscriberName
                : subscriberName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VodafoneCashPaymentDataImplCopyWith<$Res>
    implements $VodafoneCashPaymentDataCopyWith<$Res> {
  factory _$$VodafoneCashPaymentDataImplCopyWith(
    _$VodafoneCashPaymentDataImpl value,
    $Res Function(_$VodafoneCashPaymentDataImpl) then,
  ) = __$$VodafoneCashPaymentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String phoneNumber,
    double amount,
    String currency,
    String? description,
    String? subscriberName,
  });
}

/// @nodoc
class __$$VodafoneCashPaymentDataImplCopyWithImpl<$Res>
    extends
        _$VodafoneCashPaymentDataCopyWithImpl<
          $Res,
          _$VodafoneCashPaymentDataImpl
        >
    implements _$$VodafoneCashPaymentDataImplCopyWith<$Res> {
  __$$VodafoneCashPaymentDataImplCopyWithImpl(
    _$VodafoneCashPaymentDataImpl _value,
    $Res Function(_$VodafoneCashPaymentDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VodafoneCashPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? subscriberName = freezed,
  }) {
    return _then(
      _$VodafoneCashPaymentDataImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        subscriberName: freezed == subscriberName
            ? _value.subscriberName
            : subscriberName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VodafoneCashPaymentDataImpl implements _VodafoneCashPaymentData {
  const _$VodafoneCashPaymentDataImpl({
    required this.phoneNumber,
    required this.amount,
    required this.currency,
    this.description,
    this.subscriberName,
  });

  factory _$VodafoneCashPaymentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VodafoneCashPaymentDataImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String? description;
  @override
  final String? subscriberName;

  @override
  String toString() {
    return 'VodafoneCashPaymentData(phoneNumber: $phoneNumber, amount: $amount, currency: $currency, description: $description, subscriberName: $subscriberName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VodafoneCashPaymentDataImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.subscriberName, subscriberName) ||
                other.subscriberName == subscriberName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    phoneNumber,
    amount,
    currency,
    description,
    subscriberName,
  );

  /// Create a copy of VodafoneCashPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VodafoneCashPaymentDataImplCopyWith<_$VodafoneCashPaymentDataImpl>
  get copyWith =>
      __$$VodafoneCashPaymentDataImplCopyWithImpl<
        _$VodafoneCashPaymentDataImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VodafoneCashPaymentDataImplToJson(this);
  }
}

abstract class _VodafoneCashPaymentData implements VodafoneCashPaymentData {
  const factory _VodafoneCashPaymentData({
    required final String phoneNumber,
    required final double amount,
    required final String currency,
    final String? description,
    final String? subscriberName,
  }) = _$VodafoneCashPaymentDataImpl;

  factory _VodafoneCashPaymentData.fromJson(Map<String, dynamic> json) =
      _$VodafoneCashPaymentDataImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String? get description;
  @override
  String? get subscriberName;

  /// Create a copy of VodafoneCashPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VodafoneCashPaymentDataImplCopyWith<_$VodafoneCashPaymentDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MeezaPaymentData _$MeezaPaymentDataFromJson(Map<String, dynamic> json) {
  return _MeezaPaymentData.fromJson(json);
}

/// @nodoc
mixin _$MeezaPaymentData {
  String get cardToken => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;

  /// Serializes this MeezaPaymentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeezaPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeezaPaymentDataCopyWith<MeezaPaymentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeezaPaymentDataCopyWith<$Res> {
  factory $MeezaPaymentDataCopyWith(
    MeezaPaymentData value,
    $Res Function(MeezaPaymentData) then,
  ) = _$MeezaPaymentDataCopyWithImpl<$Res, MeezaPaymentData>;
  @useResult
  $Res call({
    String cardToken,
    double amount,
    String currency,
    String? description,
    String? customerEmail,
    String? customerPhone,
  });
}

/// @nodoc
class _$MeezaPaymentDataCopyWithImpl<$Res, $Val extends MeezaPaymentData>
    implements $MeezaPaymentDataCopyWith<$Res> {
  _$MeezaPaymentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeezaPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardToken = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
  }) {
    return _then(
      _value.copyWith(
            cardToken: null == cardToken
                ? _value.cardToken
                : cardToken // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerEmail: freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MeezaPaymentDataImplCopyWith<$Res>
    implements $MeezaPaymentDataCopyWith<$Res> {
  factory _$$MeezaPaymentDataImplCopyWith(
    _$MeezaPaymentDataImpl value,
    $Res Function(_$MeezaPaymentDataImpl) then,
  ) = __$$MeezaPaymentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardToken,
    double amount,
    String currency,
    String? description,
    String? customerEmail,
    String? customerPhone,
  });
}

/// @nodoc
class __$$MeezaPaymentDataImplCopyWithImpl<$Res>
    extends _$MeezaPaymentDataCopyWithImpl<$Res, _$MeezaPaymentDataImpl>
    implements _$$MeezaPaymentDataImplCopyWith<$Res> {
  __$$MeezaPaymentDataImplCopyWithImpl(
    _$MeezaPaymentDataImpl _value,
    $Res Function(_$MeezaPaymentDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeezaPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardToken = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
  }) {
    return _then(
      _$MeezaPaymentDataImpl(
        cardToken: null == cardToken
            ? _value.cardToken
            : cardToken // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerEmail: freezed == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MeezaPaymentDataImpl implements _MeezaPaymentData {
  const _$MeezaPaymentDataImpl({
    required this.cardToken,
    required this.amount,
    required this.currency,
    this.description,
    this.customerEmail,
    this.customerPhone,
  });

  factory _$MeezaPaymentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeezaPaymentDataImplFromJson(json);

  @override
  final String cardToken;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String? description;
  @override
  final String? customerEmail;
  @override
  final String? customerPhone;

  @override
  String toString() {
    return 'MeezaPaymentData(cardToken: $cardToken, amount: $amount, currency: $currency, description: $description, customerEmail: $customerEmail, customerPhone: $customerPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeezaPaymentDataImpl &&
            (identical(other.cardToken, cardToken) ||
                other.cardToken == cardToken) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardToken,
    amount,
    currency,
    description,
    customerEmail,
    customerPhone,
  );

  /// Create a copy of MeezaPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeezaPaymentDataImplCopyWith<_$MeezaPaymentDataImpl> get copyWith =>
      __$$MeezaPaymentDataImplCopyWithImpl<_$MeezaPaymentDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MeezaPaymentDataImplToJson(this);
  }
}

abstract class _MeezaPaymentData implements MeezaPaymentData {
  const factory _MeezaPaymentData({
    required final String cardToken,
    required final double amount,
    required final String currency,
    final String? description,
    final String? customerEmail,
    final String? customerPhone,
  }) = _$MeezaPaymentDataImpl;

  factory _MeezaPaymentData.fromJson(Map<String, dynamic> json) =
      _$MeezaPaymentDataImpl.fromJson;

  @override
  String get cardToken;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String? get description;
  @override
  String? get customerEmail;
  @override
  String? get customerPhone;

  /// Create a copy of MeezaPaymentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeezaPaymentDataImplCopyWith<_$MeezaPaymentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StripePaymentData _$StripePaymentDataFromJson(Map<String, dynamic> json) {
  return _StripePaymentData.fromJson(json);
}

/// @nodoc
mixin _$StripePaymentData {
  String get paymentMethodId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, String>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this StripePaymentData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StripePaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StripePaymentDataCopyWith<StripePaymentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripePaymentDataCopyWith<$Res> {
  factory $StripePaymentDataCopyWith(
    StripePaymentData value,
    $Res Function(StripePaymentData) then,
  ) = _$StripePaymentDataCopyWithImpl<$Res, StripePaymentData>;
  @useResult
  $Res call({
    String paymentMethodId,
    double amount,
    String currency,
    String? customerId,
    String? description,
    Map<String, String>? metadata,
  });
}

/// @nodoc
class _$StripePaymentDataCopyWithImpl<$Res, $Val extends StripePaymentData>
    implements $StripePaymentDataCopyWith<$Res> {
  _$StripePaymentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StripePaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? amount = null,
    Object? currency = null,
    Object? customerId = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentMethodId: null == paymentMethodId
                ? _value.paymentMethodId
                : paymentMethodId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StripePaymentDataImplCopyWith<$Res>
    implements $StripePaymentDataCopyWith<$Res> {
  factory _$$StripePaymentDataImplCopyWith(
    _$StripePaymentDataImpl value,
    $Res Function(_$StripePaymentDataImpl) then,
  ) = __$$StripePaymentDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String paymentMethodId,
    double amount,
    String currency,
    String? customerId,
    String? description,
    Map<String, String>? metadata,
  });
}

/// @nodoc
class __$$StripePaymentDataImplCopyWithImpl<$Res>
    extends _$StripePaymentDataCopyWithImpl<$Res, _$StripePaymentDataImpl>
    implements _$$StripePaymentDataImplCopyWith<$Res> {
  __$$StripePaymentDataImplCopyWithImpl(
    _$StripePaymentDataImpl _value,
    $Res Function(_$StripePaymentDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StripePaymentData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? amount = null,
    Object? currency = null,
    Object? customerId = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$StripePaymentDataImpl(
        paymentMethodId: null == paymentMethodId
            ? _value.paymentMethodId
            : paymentMethodId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StripePaymentDataImpl implements _StripePaymentData {
  const _$StripePaymentDataImpl({
    required this.paymentMethodId,
    required this.amount,
    required this.currency,
    this.customerId,
    this.description,
    final Map<String, String>? metadata,
  }) : _metadata = metadata;

  factory _$StripePaymentDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StripePaymentDataImplFromJson(json);

  @override
  final String paymentMethodId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String? customerId;
  @override
  final String? description;
  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StripePaymentData(paymentMethodId: $paymentMethodId, amount: $amount, currency: $currency, customerId: $customerId, description: $description, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StripePaymentDataImpl &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentMethodId,
    amount,
    currency,
    customerId,
    description,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of StripePaymentData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StripePaymentDataImplCopyWith<_$StripePaymentDataImpl> get copyWith =>
      __$$StripePaymentDataImplCopyWithImpl<_$StripePaymentDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StripePaymentDataImplToJson(this);
  }
}

abstract class _StripePaymentData implements StripePaymentData {
  const factory _StripePaymentData({
    required final String paymentMethodId,
    required final double amount,
    required final String currency,
    final String? customerId,
    final String? description,
    final Map<String, String>? metadata,
  }) = _$StripePaymentDataImpl;

  factory _StripePaymentData.fromJson(Map<String, dynamic> json) =
      _$StripePaymentDataImpl.fromJson;

  @override
  String get paymentMethodId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String? get customerId;
  @override
  String? get description;
  @override
  Map<String, String>? get metadata;

  /// Create a copy of StripePaymentData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StripePaymentDataImplCopyWith<_$StripePaymentDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
