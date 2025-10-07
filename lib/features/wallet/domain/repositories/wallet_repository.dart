import '../entities/wallet.dart';
import '../entities/transaction.dart';
import '../entities/subscription.dart';

abstract class WalletRepository {
  /// Get wallet for the current user
  Future<Wallet?> getWallet();

  /// Create a new wallet for the user
  Future<Wallet> createWallet(String currency);

  /// Update wallet balance
  Future<void> updateBalance(String walletId, double newBalance);

  /// Get all transactions for a wallet
  Future<List<Transaction>> getTransactions(String walletId);

  /// Get transactions with pagination
  Future<List<Transaction>> getTransactionsPaginated(
    String walletId, {
    int limit = 20,
    String? startAfter,
  });

  /// Add a new transaction
  Future<Transaction> addTransaction(Transaction transaction);

  /// Get transaction by ID
  Future<Transaction?> getTransaction(String transactionId);

  /// Get active subscription for user
  Future<Subscription?> getActiveSubscription();

  /// Get all subscriptions for user
  Future<List<Subscription>> getSubscriptions();

  /// Create a new subscription
  Future<Subscription> createSubscription(Subscription subscription);

  /// Update subscription
  Future<void> updateSubscription(Subscription subscription);

  /// Cancel subscription
  Future<void> cancelSubscription(String subscriptionId);

  /// Get wallet balance as stream for real-time updates
  Stream<double> watchBalance(String walletId);

  /// Get transactions as stream for real-time updates
  Stream<List<Transaction>> watchTransactions(String walletId);

  /// Get subscriptions as stream for real-time updates
  Stream<List<Subscription>> watchSubscriptions();

  /// Process top-up transaction
  Future<Transaction> processTopUp({
    required String walletId,
    required double amount,
    required String paymentMethod,
    String? description,
  });

  /// Process payment transaction
  Future<Transaction> processPayment({
    required String walletId,
    required double amount,
    required String orderId,
    String? description,
  });

  /// Process subscription payment
  Future<Transaction> processSubscriptionPayment({
    required String walletId,
    required String subscriptionId,
    required double amount,
    String? description,
  });

  /// Get wallet statistics
  Future<Map<String, dynamic>> getWalletStats(String walletId);

  /// Check if user has sufficient balance
  Future<bool> hasSufficientBalance(String walletId, double amount);
}