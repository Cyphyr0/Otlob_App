import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWallet {
  const GetWallet(this.repository);

  final WalletRepository repository;

  Future<Wallet?> call() async => repository.getWallet();

  Stream<double> watchBalance() => repository.watchBalance('').asyncExpand((_) async* {
      final wallet = await repository.getWallet();
      if (wallet != null) {
        yield* repository.watchBalance(wallet.id);
      }
    });
}