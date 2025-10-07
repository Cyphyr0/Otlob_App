import '../entities/subscription.dart';
import '../repositories/wallet_repository.dart';

class ManageSubscription {
  const ManageSubscription(this.repository);

  final WalletRepository repository;

  Future<Subscription?> getActiveSubscription() async {
    return repository.getActiveSubscription();
  }

  Future<List<Subscription>> getAllSubscriptions() async {
    return repository.getSubscriptions();
  }

  Future<Subscription> createSubscription({
    required SubscriptionType type,
    required double amount,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
    Map<String, dynamic>? metadata,
  }) async {
    // Get wallet
    final wallet = await repository.getWallet();
    if (wallet == null) {
      throw Exception('Wallet not found. Please create a wallet first.');
    }

    final subscription = Subscription(
      id: '', // Will be set by repository
      userId: wallet.userId,
      walletId: wallet.id,
      type: type,
      status: SubscriptionStatus.active,
      amount: amount,
      currency: currency,
      startDate: startDate,
      endDate: endDate,
      metadata: metadata,
      createdAt: DateTime.now(),
    );

    return repository.createSubscription(subscription);
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    return repository.cancelSubscription(subscriptionId);
  }

  Future<void> updateSubscription(Subscription subscription) async {
    return repository.updateSubscription(subscription);
  }

  Stream<List<Subscription>> watchSubscriptions() {
    return repository.watchSubscriptions();
  }
}