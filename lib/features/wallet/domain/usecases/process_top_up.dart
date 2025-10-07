import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

class ProcessTopUp {
  const ProcessTopUp(this.repository);

  final WalletRepository repository;

  Future<Transaction> call({
    required double amount,
    required String paymentMethod,
    String? description,
  }) async {
    // Get or create wallet
    var wallet = await repository.getWallet();
    wallet ??= await repository.createWallet('EGP');

    return repository.processTopUp(
      walletId: wallet.id,
      amount: amount,
      paymentMethod: paymentMethod,
      description: description,
    );
  }
}