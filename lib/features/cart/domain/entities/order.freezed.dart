// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  OrderAddress get deliveryAddress => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryTime => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  String? get orderNotes => throw _privateConstructorUsedError;
  String? get promoCode => throw _privateConstructorUsedError;
  String? get trackingId => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String userId,
    List<OrderItem> items,
    OrderAddress deliveryAddress,
    PaymentMethod paymentMethod,
    PaymentStatus paymentStatus,
    OrderStatus status,
    double subtotal,
    double deliveryFee,
    double tax,
    double discount,
    double total,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? estimatedDeliveryTime,
    String? specialInstructions,
    String? orderNotes,
    String? promoCode,
    String? trackingId,
  });

  $OrderAddressCopyWith<$Res> get deliveryAddress;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? items = null,
    Object? deliveryAddress = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? status = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? tax = null,
    Object? discount = null,
    Object? total = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? estimatedDeliveryTime = freezed,
    Object? specialInstructions = freezed,
    Object? orderNotes = freezed,
    Object? promoCode = freezed,
    Object? trackingId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
            deliveryAddress: null == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as OrderAddress,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            tax: null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            estimatedDeliveryTime: freezed == estimatedDeliveryTime
                ? _value.estimatedDeliveryTime
                : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderNotes: freezed == orderNotes
                ? _value.orderNotes
                : orderNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            promoCode: freezed == promoCode
                ? _value.promoCode
                : promoCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackingId: freezed == trackingId
                ? _value.trackingId
                : trackingId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderAddressCopyWith<$Res> get deliveryAddress {
    return $OrderAddressCopyWith<$Res>(_value.deliveryAddress, (value) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    List<OrderItem> items,
    OrderAddress deliveryAddress,
    PaymentMethod paymentMethod,
    PaymentStatus paymentStatus,
    OrderStatus status,
    double subtotal,
    double deliveryFee,
    double tax,
    double discount,
    double total,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? estimatedDeliveryTime,
    String? specialInstructions,
    String? orderNotes,
    String? promoCode,
    String? trackingId,
  });

  @override
  $OrderAddressCopyWith<$Res> get deliveryAddress;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? items = null,
    Object? deliveryAddress = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? status = null,
    Object? subtotal = null,
    Object? deliveryFee = null,
    Object? tax = null,
    Object? discount = null,
    Object? total = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? estimatedDeliveryTime = freezed,
    Object? specialInstructions = freezed,
    Object? orderNotes = freezed,
    Object? promoCode = freezed,
    Object? trackingId = freezed,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
        deliveryAddress: null == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as OrderAddress,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        tax: null == tax
            ? _value.tax
            : tax // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        estimatedDeliveryTime: freezed == estimatedDeliveryTime
            ? _value.estimatedDeliveryTime
            : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderNotes: freezed == orderNotes
            ? _value.orderNotes
            : orderNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        promoCode: freezed == promoCode
            ? _value.promoCode
            : promoCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackingId: freezed == trackingId
            ? _value.trackingId
            : trackingId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    required this.userId,
    required final List<OrderItem> items,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedDeliveryTime,
    this.specialInstructions,
    this.orderNotes,
    this.promoCode,
    this.trackingId,
  }) : _items = items;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<OrderItem> _items;
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final OrderAddress deliveryAddress;
  @override
  final PaymentMethod paymentMethod;
  @override
  final PaymentStatus paymentStatus;
  @override
  final OrderStatus status;
  @override
  final double subtotal;
  @override
  final double deliveryFee;
  @override
  final double tax;
  @override
  final double discount;
  @override
  final double total;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? estimatedDeliveryTime;
  @override
  final String? specialInstructions;
  @override
  final String? orderNotes;
  @override
  final String? promoCode;
  @override
  final String? trackingId;

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, items: $items, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, status: $status, subtotal: $subtotal, deliveryFee: $deliveryFee, tax: $tax, discount: $discount, total: $total, createdAt: $createdAt, updatedAt: $updatedAt, estimatedDeliveryTime: $estimatedDeliveryTime, specialInstructions: $specialInstructions, orderNotes: $orderNotes, promoCode: $promoCode, trackingId: $trackingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.orderNotes, orderNotes) ||
                other.orderNotes == orderNotes) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.trackingId, trackingId) ||
                other.trackingId == trackingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    userId,
    const DeepCollectionEquality().hash(_items),
    deliveryAddress,
    paymentMethod,
    paymentStatus,
    status,
    subtotal,
    deliveryFee,
    tax,
    discount,
    total,
    createdAt,
    updatedAt,
    estimatedDeliveryTime,
    specialInstructions,
    orderNotes,
    promoCode,
    trackingId,
  ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final String id,
    required final String userId,
    required final List<OrderItem> items,
    required final OrderAddress deliveryAddress,
    required final PaymentMethod paymentMethod,
    required final PaymentStatus paymentStatus,
    required final OrderStatus status,
    required final double subtotal,
    required final double deliveryFee,
    required final double tax,
    required final double discount,
    required final double total,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? estimatedDeliveryTime,
    final String? specialInstructions,
    final String? orderNotes,
    final String? promoCode,
    final String? trackingId,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<OrderItem> get items;
  @override
  OrderAddress get deliveryAddress;
  @override
  PaymentMethod get paymentMethod;
  @override
  PaymentStatus get paymentStatus;
  @override
  OrderStatus get status;
  @override
  double get subtotal;
  @override
  double get deliveryFee;
  @override
  double get tax;
  @override
  double get discount;
  @override
  double get total;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get estimatedDeliveryTime;
  @override
  String? get specialInstructions;
  @override
  String? get orderNotes;
  @override
  String? get promoCode;
  @override
  String? get trackingId;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  String? get restaurantId => throw _privateConstructorUsedError;
  String? get restaurantName => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int quantity,
    String imageUrl,
    String? specialInstructions,
    String? restaurantId,
    String? restaurantName,
  });
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? imageUrl = null,
    Object? specialInstructions = freezed,
    Object? restaurantId = freezed,
    Object? restaurantName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            restaurantId: freezed == restaurantId
                ? _value.restaurantId
                : restaurantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            restaurantName: freezed == restaurantName
                ? _value.restaurantName
                : restaurantName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    int quantity,
    String imageUrl,
    String? specialInstructions,
    String? restaurantId,
    String? restaurantName,
  });
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? imageUrl = null,
    Object? specialInstructions = freezed,
    Object? restaurantId = freezed,
    Object? restaurantName = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        restaurantId: freezed == restaurantId
            ? _value.restaurantId
            : restaurantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        restaurantName: freezed == restaurantName
            ? _value.restaurantName
            : restaurantName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.specialInstructions,
    this.restaurantId,
    this.restaurantName,
  });

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final String imageUrl;
  @override
  final String? specialInstructions;
  @override
  final String? restaurantId;
  @override
  final String? restaurantName;

  @override
  String toString() {
    return 'OrderItem(id: $id, name: $name, price: $price, quantity: $quantity, imageUrl: $imageUrl, specialInstructions: $specialInstructions, restaurantId: $restaurantId, restaurantName: $restaurantName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.restaurantName, restaurantName) ||
                other.restaurantName == restaurantName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    quantity,
    imageUrl,
    specialInstructions,
    restaurantId,
    restaurantName,
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final String id,
    required final String name,
    required final double price,
    required final int quantity,
    required final String imageUrl,
    final String? specialInstructions,
    final String? restaurantId,
    final String? restaurantName,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String get imageUrl;
  @override
  String? get specialInstructions;
  @override
  String? get restaurantId;
  @override
  String? get restaurantName;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderAddress _$OrderAddressFromJson(Map<String, dynamic> json) {
  return _OrderAddress.fromJson(json);
}

/// @nodoc
mixin _$OrderAddress {
  String get street => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get governorate => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  String? get apartment => throw _privateConstructorUsedError;
  String? get building => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;

  /// Serializes this OrderAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderAddressCopyWith<OrderAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderAddressCopyWith<$Res> {
  factory $OrderAddressCopyWith(
    OrderAddress value,
    $Res Function(OrderAddress) then,
  ) = _$OrderAddressCopyWithImpl<$Res, OrderAddress>;
  @useResult
  $Res call({
    String street,
    String city,
    String governorate,
    String postalCode,
    String? apartment,
    String? building,
    String? floor,
    double? latitude,
    double? longitude,
    String? instructions,
  });
}

/// @nodoc
class _$OrderAddressCopyWithImpl<$Res, $Val extends OrderAddress>
    implements $OrderAddressCopyWith<$Res> {
  _$OrderAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
    Object? apartment = freezed,
    Object? building = freezed,
    Object? floor = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? instructions = freezed,
  }) {
    return _then(
      _value.copyWith(
            street: null == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            governorate: null == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String,
            postalCode: null == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            apartment: freezed == apartment
                ? _value.apartment
                : apartment // ignore: cast_nullable_to_non_nullable
                      as String?,
            building: freezed == building
                ? _value.building
                : building // ignore: cast_nullable_to_non_nullable
                      as String?,
            floor: freezed == floor
                ? _value.floor
                : floor // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderAddressImplCopyWith<$Res>
    implements $OrderAddressCopyWith<$Res> {
  factory _$$OrderAddressImplCopyWith(
    _$OrderAddressImpl value,
    $Res Function(_$OrderAddressImpl) then,
  ) = __$$OrderAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String street,
    String city,
    String governorate,
    String postalCode,
    String? apartment,
    String? building,
    String? floor,
    double? latitude,
    double? longitude,
    String? instructions,
  });
}

/// @nodoc
class __$$OrderAddressImplCopyWithImpl<$Res>
    extends _$OrderAddressCopyWithImpl<$Res, _$OrderAddressImpl>
    implements _$$OrderAddressImplCopyWith<$Res> {
  __$$OrderAddressImplCopyWithImpl(
    _$OrderAddressImpl _value,
    $Res Function(_$OrderAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = null,
    Object? city = null,
    Object? governorate = null,
    Object? postalCode = null,
    Object? apartment = freezed,
    Object? building = freezed,
    Object? floor = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? instructions = freezed,
  }) {
    return _then(
      _$OrderAddressImpl(
        street: null == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        governorate: null == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String,
        postalCode: null == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        apartment: freezed == apartment
            ? _value.apartment
            : apartment // ignore: cast_nullable_to_non_nullable
                  as String?,
        building: freezed == building
            ? _value.building
            : building // ignore: cast_nullable_to_non_nullable
                  as String?,
        floor: freezed == floor
            ? _value.floor
            : floor // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderAddressImpl implements _OrderAddress {
  const _$OrderAddressImpl({
    required this.street,
    required this.city,
    required this.governorate,
    required this.postalCode,
    this.apartment,
    this.building,
    this.floor,
    this.latitude,
    this.longitude,
    this.instructions,
  });

  factory _$OrderAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderAddressImplFromJson(json);

  @override
  final String street;
  @override
  final String city;
  @override
  final String governorate;
  @override
  final String postalCode;
  @override
  final String? apartment;
  @override
  final String? building;
  @override
  final String? floor;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? instructions;

  @override
  String toString() {
    return 'OrderAddress(street: $street, city: $city, governorate: $governorate, postalCode: $postalCode, apartment: $apartment, building: $building, floor: $floor, latitude: $latitude, longitude: $longitude, instructions: $instructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderAddressImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.apartment, apartment) ||
                other.apartment == apartment) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    street,
    city,
    governorate,
    postalCode,
    apartment,
    building,
    floor,
    latitude,
    longitude,
    instructions,
  );

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      __$$OrderAddressImplCopyWithImpl<_$OrderAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderAddressImplToJson(this);
  }
}

abstract class _OrderAddress implements OrderAddress {
  const factory _OrderAddress({
    required final String street,
    required final String city,
    required final String governorate,
    required final String postalCode,
    final String? apartment,
    final String? building,
    final String? floor,
    final double? latitude,
    final double? longitude,
    final String? instructions,
  }) = _$OrderAddressImpl;

  factory _OrderAddress.fromJson(Map<String, dynamic> json) =
      _$OrderAddressImpl.fromJson;

  @override
  String get street;
  @override
  String get city;
  @override
  String get governorate;
  @override
  String get postalCode;
  @override
  String? get apartment;
  @override
  String? get building;
  @override
  String? get floor;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get instructions;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
