import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';

class GetTransactions {
  const GetTransactions(this.repository);

  final WalletRepository repository;

  Future<List<Transaction>> call({int limit = 20, String? startAfter}) async {
    // Get wallet
    final wallet = await repository.getWallet();
    if (wallet == null) {
      return [];
    }

    return repository.getTransactionsPaginated(
      wallet.id,
      limit: limit,
      startAfter: startAfter,
    );
  }

  Stream<List<Transaction>> watch() {
    return repository.watchTransactions('').asyncExpand((_) async* {
      final wallet = await repository.getWallet();
      if (wallet != null) {
        yield* repository.watchTransactions(wallet.id);
      } else {
        yield* Stream.value([]);
      }
    });
  }
}