import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";
import "../../../../core/services/service_locator.dart";
import "../../../auth/presentation/providers/auth_provider.dart";
import "../../../payment/domain/entities/payment.dart";
import "../../domain/entities/cart_item.dart";
import "../../domain/entities/order.dart";
import "../../domain/repositories/order_repository.dart";

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ref),
);

class OrderNotifier extends StateNotifier<OrderState> {
  final Ref ref;
  final Uuid _uuid = const Uuid();

  OrderNotifier(this.ref) : super(const OrderState.initial()) {
    _orderRepository = getIt<OrderRepository>();
  }

  late final OrderRepository _orderRepository;

  Future<void> placeOrder({
    required List<CartItem> cartItems,
    required OrderAddress deliveryAddress,
    required PaymentMethod paymentMethod,
    String? specialInstructions,
    String? promoCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;

        // Calculate order totals
        final subtotal = cartItems.fold<double>(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        const deliveryFee = 15.0; // Fixed delivery fee
        const tax = 0.14; // 14% tax rate
        final taxAmount = subtotal * tax;
        final discount = _calculateDiscount(subtotal, promoCode);
        final total = subtotal + deliveryFee + taxAmount - discount;

        // Create order items
        final orderItems = cartItems.map((item) => OrderItem(
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          imageUrl: item.imageUrl,
          specialInstructions: item.specialInstructions,
          restaurantId: item.restaurantId,
          restaurantName: item.restaurantName,
        )).toList();

        // Create order
        final order = Order(
          id: _uuid.v4(),
          userId: userId,
          items: orderItems,
          deliveryAddress: deliveryAddress,
          paymentMethod: paymentMethod,
          paymentStatus: PaymentStatus.pending,
          status: OrderStatus.pending,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          tax: taxAmount,
          discount: discount,
          total: total,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 45)),
          specialInstructions: specialInstructions,
          promoCode: promoCode,
        );

        // Save order to repository
        await _orderRepository.placeOrder(order);

        state = state.copyWith(
          isLoading: false,
          order: order,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "User must be authenticated to place an order",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _orderRepository.updateOrderStatus(orderId, status);

      if (state.order != null) {
        final updatedOrder = state.order!.copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );

        state = state.copyWith(
          isLoading: false,
          order: updatedOrder,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<List<Order>> getUserOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        final orders = await _orderRepository.getUserOrders(userId);

        state = state.copyWith(
          isLoading: false,
          userOrders: orders,
          error: null,
        );

        return orders;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "User must be authenticated",
        );
        return [];
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return [];
    }
  }

  double _calculateDiscount(double subtotal, String? promoCode) {
    if (promoCode == "SAVE10") {
      return subtotal * 0.1;
    } else if (promoCode == "NEWUSER") {
      return subtotal * 0.15;
    }
    return 0.0;
  }

  Future<void> processOrderWithPayment({
    required List<CartItem> cartItems,
    required OrderAddress deliveryAddress,
    required PaymentProvider paymentProvider,
    String? specialInstructions,
    String? promoCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;

        // Calculate order totals
        final subtotal = cartItems.fold<double>(
          0,
          (sum, item) => sum + (item.price * item.quantity),
        );
        const deliveryFee = 15.0;
        const tax = 0.14;
        final taxAmount = subtotal * tax;
        final discount = _calculateDiscount(subtotal, promoCode);
        final total = subtotal + deliveryFee + taxAmount - discount;

        // Create order items
        final orderItems = cartItems.map((item) => OrderItem(
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          imageUrl: item.imageUrl,
          specialInstructions: item.specialInstructions,
          restaurantId: item.restaurantId,
          restaurantName: item.restaurantName,
        )).toList();

        // Create order with pending payment status
        final order = Order(
          id: _uuid.v4(),
          userId: userId,
          items: orderItems,
          deliveryAddress: deliveryAddress,
          paymentMethod: _mapPaymentProviderToPaymentMethod(paymentProvider),
          paymentStatus: PaymentStatus.pending,
          status: OrderStatus.pending,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          tax: taxAmount,
          discount: discount,
          total: total,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 45)),
          specialInstructions: specialInstructions,
          promoCode: promoCode,
        );

        // Save order to repository
        await _orderRepository.placeOrder(order);

        state = state.copyWith(
          isLoading: false,
          order: order,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "User must be authenticated to place an order",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  PaymentMethod _mapPaymentProviderToPaymentMethod(PaymentProvider provider) {
    switch (provider) {
      case PaymentProvider.stripe:
        return PaymentMethod.card;
      case PaymentProvider.fawry:
        return PaymentMethod.wallet;
      case PaymentProvider.vodafoneCash:
        return PaymentMethod.wallet;
      case PaymentProvider.meeza:
        return PaymentMethod.card;
    }
  }

  Future<void> updateOrderPaymentStatus(String orderId, PaymentStatus paymentStatus) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Update payment status in order
      if (state.order != null && state.order!.id == orderId) {
        final updatedOrder = state.order!.copyWith(
          paymentStatus: paymentStatus,
          status: paymentStatus == PaymentStatus.completed ? OrderStatus.confirmed : state.order!.status,
          updatedAt: DateTime.now(),
        );

        // Update in repository
        await _orderRepository.updateOrderStatus(orderId, updatedOrder.status);

        state = state.copyWith(
          isLoading: false,
          order: updatedOrder,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetOrder() {
    state = const OrderState.initial();
  }
}

class OrderState {
  final bool isLoading;
  final Order? order;
  final List<Order> userOrders;
  final String? error;

  const OrderState({
    required this.isLoading,
    this.order,
    this.userOrders = const [],
    this.error,
  });

  const OrderState.initial()
      : isLoading = false,
        order = null,
        userOrders = const [],
        error = null;

  OrderState copyWith({
    bool? isLoading,
    Order? order,
    List<Order>? userOrders,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      order: order ?? this.order,
      userOrders: userOrders ?? this.userOrders,
      error: error ?? this.error,
    );
  }
}