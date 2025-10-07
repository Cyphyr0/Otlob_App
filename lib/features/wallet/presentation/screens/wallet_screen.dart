import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/transaction_list.dart';
import '../widgets/top_up_button.dart';
import '../widgets/subscription_card.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Load wallet data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).loadWallet();
      ref.read(walletProvider.notifier).loadTransactions();
      ref.read(walletProvider.notifier).loadSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to transaction history
              context.push('/wallet/transactions');
            },
          ),
          IconButton(
            icon: const Icon(Icons.subscriptions),
            onPressed: () {
              // Navigate to subscriptions
              context.push('/wallet/subscriptions');
            },
          ),
        ],
      ),
      body: walletState.isLoading && walletState.wallet == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(walletProvider.notifier).loadWallet();
                await ref.read(walletProvider.notifier).loadTransactions();
                await ref.read(walletProvider.notifier).loadSubscriptions();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wallet Balance Card
                    if (walletState.wallet != null)
                      WalletBalanceCard(wallet: walletState.wallet!)
                    else
                      const _CreateWalletCard(),

                    const SizedBox(height: 24),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: TopUpButton(
                            onTopUp: (amount, method) async {
                              try {
                                await ref.read(walletProvider.notifier).topUp(
                                  amount: amount,
                                  paymentMethod: method,
                                );
                                if (mounted) {
                                  ShadToaster.of(context).show(
                                    const ShadToast(
                                      description: Text('Top up successful!'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ShadToaster.of(context).show(
                                    ShadToast(
                                      description: Text('Top up failed: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ShadButton.outline(
                            onPressed: () {
                              context.push('/wallet/subscriptions');
                            },
                            child: const Text('Subscriptions'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Active Subscription
                    if (walletState.subscriptions.isNotEmpty) ...[
                      Text(
                        'Active Subscriptions',
                        style: ShadTheme.of(context).textTheme.h4,
                      ),
                      const SizedBox(height: 12),
                      SubscriptionCard(
                        subscription: walletState.subscriptions.firstWhere(
                          (sub) => sub.isActive,
                          orElse: () => walletState.subscriptions.first,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Recent Transactions
                    Text(
                      'Recent Transactions',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 12),

                    if (walletState.transactions.isNotEmpty)
                      TransactionList(
                        transactions: walletState.transactions.take(5).toList(),
                        onViewAll: () {
                          context.push('/wallet/transactions');
                        },
                      )
                    else
                      const _EmptyTransactionsCard(),

                    // Error Display
                    if (walletState.error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                walletState.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.read(walletProvider.notifier).clearError();
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

class _CreateWalletCard extends StatelessWidget {
  const _CreateWalletCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Create Your Wallet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set up your wallet to start making payments and track your transactions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ShadButton(
            onPressed: () {
              // This will be handled by the wallet provider when making first transaction
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransactionsCard extends StatelessWidget {
  const _EmptyTransactionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Yet',
            style: ShadTheme.of(context).textTheme.p.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your transaction history will appear here once you start using your wallet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}