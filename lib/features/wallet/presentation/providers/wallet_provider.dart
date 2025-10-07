import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/get_wallet.dart';
import '../../domain/usecases/process_top_up.dart';
import '../../domain/usecases/process_payment.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/manage_subscription.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final getWallet = GetWallet(ref.watch(walletRepositoryProvider));
  final processTopUp = ProcessTopUp(ref.watch(walletRepositoryProvider));
  final processPayment = ProcessPayment(ref.watch(walletRepositoryProvider));
  final getTransactions = GetTransactions(ref.watch(walletRepositoryProvider));
  final manageSubscription = ManageSubscription(ref.watch(walletRepositoryProvider));

  return WalletNotifier(
    getWallet: getWallet,
    processTopUp: processTopUp,
    processPayment: processPayment,
    getTransactions: getTransactions,
    manageSubscription: manageSubscription,
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  // This will be implemented when we set up dependency injection
  throw UnimplementedError('Wallet repository provider not implemented');
});

class WalletState {
  const WalletState({
    this.wallet,
    this.transactions = const [],
    this.subscriptions = const [],
    this.isLoading = false,
    this.error,
  });

  final Wallet? wallet;
  final List<Transaction> transactions;
  final List<Subscription> subscriptions;
  final bool isLoading;
  final String? error;

  WalletState copyWith({
    Wallet? wallet,
    List<Transaction>? transactions,
    List<Subscription>? subscriptions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final GetWallet _getWallet;
  final ProcessTopUp _processTopUp;
  final ProcessPayment _processPayment;
  final GetTransactions _getTransactions;
  final ManageSubscription _manageSubscription;

  WalletNotifier({
    required GetWallet getWallet,
    required ProcessTopUp processTopUp,
    required ProcessPayment processPayment,
    required GetTransactions getTransactions,
    required ManageSubscription manageSubscription,
  })  : _getWallet = getWallet,
        _processTopUp = processTopUp,
        _processPayment = processPayment,
        _getTransactions = getTransactions,
        _manageSubscription = manageSubscription,
        super(const WalletState());

  Future<void> loadWallet() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final wallet = await _getWallet();
      state = state.copyWith(wallet: wallet, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final transactions = await _getTransactions();
      state = state.copyWith(transactions: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadSubscriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final subscriptions = await _manageSubscription.getAllSubscriptions();
      state = state.copyWith(subscriptions: subscriptions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Transaction> topUp({
    required double amount,
    required String paymentMethod,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final transaction = await _processTopUp(
        amount: amount,
        paymentMethod: paymentMethod,
        description: description,
      );

      // Reload wallet and transactions
      await loadWallet();
      await loadTransactions();

      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<Transaction> processPayment({
    required double amount,
    required String orderId,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final transaction = await _processPayment(
        amount: amount,
        orderId: orderId,
        description: description,
      );

      // Reload wallet and transactions
      await loadWallet();
      await loadTransactions();

      state = state.copyWith(isLoading: false);
      return transaction;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<Subscription> createSubscription({
    required SubscriptionType type,
    required double amount,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
    Map<String, dynamic>? metadata,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final subscription = await _manageSubscription.createSubscription(
        type: type,
        amount: amount,
        currency: currency,
        startDate: startDate,
        endDate: endDate,
        metadata: metadata,
      );

      // Reload subscriptions
      await loadSubscriptions();

      state = state.copyWith(isLoading: false);
      return subscription;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _manageSubscription.cancelSubscription(subscriptionId);

      // Reload subscriptions
      await loadSubscriptions();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}