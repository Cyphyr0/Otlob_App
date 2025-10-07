import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

class ProcessPayment {
  const ProcessPayment(this.repository);

  final WalletRepository repository;

  Future<Transaction> call({
    required double amount,
    required String orderId,
    String? description,
  }) async {
    // Get wallet
    final wallet = await repository.getWallet();
    if (wallet == null) {
      throw Exception('Wallet not found. Please create a wallet first.');
    }

    // Check if user has sufficient balance
    final hasBalance = await repository.hasSufficientBalance(wallet.id, amount);
    if (!hasBalance) {
      throw Exception('Insufficient balance');
    }

    return repository.processPayment(
      walletId: wallet.id,
      amount: amount,
      orderId: orderId,
      description: description,
    );
  }
}