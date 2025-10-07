import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";
import "../../../../core/services/service_locator.dart";
import "../../../auth/presentation/providers/auth_provider.dart";
import "../../domain/entities/payment.dart";
import "../../domain/repositories/payment_repository.dart";

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(ref),
);

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref ref;
  final Uuid _uuid = const Uuid();

  PaymentNotifier(this.ref) : super(const PaymentState.initial()) {
    _paymentRepository = getIt<PaymentRepository>();
  }

  late final PaymentRepository _paymentRepository;

  Future<void> initializePayment({
    required String orderId,
    required PaymentProvider provider,
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final paymentIntent = await _paymentRepository.createPaymentIntent(
        orderId: orderId,
        provider: provider,
        amount: amount,
        currency: currency,
        metadata: metadata,
      );

      state = state.copyWith(
        isLoading: false,
        paymentIntent: paymentIntent,
        selectedProvider: provider,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> processPayment(dynamic paymentData) async {
    if (state.paymentIntent == null) {
      state = state.copyWith(
        error: "Payment intent not initialized",
      );
      return;
    }

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final payment = await _paymentRepository.processPayment(
        paymentIntentId: state.paymentIntent!.id,
        paymentData: paymentData,
      );

      state = state.copyWith(
        isProcessing: false,
        currentPayment: payment,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> confirmPayment(String paymentId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payment = await _paymentRepository.confirmPayment(paymentId);

      state = state.copyWith(
        isLoading: false,
        currentPayment: payment,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelPayment(String paymentId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payment = await _paymentRepository.cancelPayment(paymentId);

      state = state.copyWith(
        isLoading: false,
        currentPayment: payment,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refundPayment(String paymentId, double? amount) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payment = await _paymentRepository.refundPayment(paymentId, amount);

      state = state.copyWith(
        isLoading: false,
        currentPayment: payment,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<List<Payment>> getPaymentsByOrderId(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payments = await _paymentRepository.getPaymentsByOrderId(orderId);

      state = state.copyWith(
        isLoading: false,
        orderPayments: payments,
        error: null,
      );

      return payments;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return [];
    }
  }

  Future<List<PaymentProvider>> getSupportedProviders() async {
    try {
      return await _paymentRepository.getSupportedProviders();
    } catch (e) {
      // Return default providers if repository fails
      return PaymentProvider.values;
    }
  }

  void selectPaymentProvider(PaymentProvider provider) {
    state = state.copyWith(selectedProvider: provider);
  }

  void resetPayment() {
    state = const PaymentState.initial();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class PaymentState {
  final bool isLoading;
  final bool isProcessing;
  final PaymentIntent? paymentIntent;
  final Payment? currentPayment;
  final List<Payment> orderPayments;
  final PaymentProvider? selectedProvider;
  final String? error;

  const PaymentState({
    required this.isLoading,
    required this.isProcessing,
    this.paymentIntent,
    this.currentPayment,
    this.orderPayments = const [],
    this.selectedProvider,
    this.error,
  });

  const PaymentState.initial()
      : isLoading = false,
        isProcessing = false,
        paymentIntent = null,
        currentPayment = null,
        orderPayments = const [],
        selectedProvider = null,
        error = null;

  PaymentState copyWith({
    bool? isLoading,
    bool? isProcessing,
    PaymentIntent? paymentIntent,
    Payment? currentPayment,
    List<Payment>? orderPayments,
    PaymentProvider? selectedProvider,
    String? error,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      currentPayment: currentPayment ?? this.currentPayment,
      orderPayments: orderPayments ?? this.orderPayments,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      error: error ?? this.error,
    );
  }
}