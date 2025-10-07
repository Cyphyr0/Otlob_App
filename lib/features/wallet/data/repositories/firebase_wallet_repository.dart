import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/subscription.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/subscription_model.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';

class FirebaseWalletRepository implements WalletRepository {

  FirebaseWalletRepository(this._firestore, this._auth);
  final firestore.FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId => _auth.currentUser?.uid ?? '';

  firestore.CollectionReference<Map<String, dynamic>> get _walletsCollection =>
      _firestore.collection('wallets');

  firestore.CollectionReference<Map<String, dynamic>> get _transactionsCollection =>
      _firestore.collection('transactions');

  firestore.CollectionReference<Map<String, dynamic>> get _subscriptionsCollection =>
      _firestore.collection('subscriptions');

  @override
  Future<Wallet?> getWallet() async {
    if (_userId.isEmpty) return null;

    try {
      final snapshot = await _walletsCollection
          .where('userId', isEqualTo: _userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final walletModel = WalletModel.fromFirestore(snapshot.docs.first);
      return walletModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get wallet: $e');
    }
  }

  @override
  Future<Wallet> createWallet(String currency) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      // Check if wallet already exists
      final existingWallet = await getWallet();
      if (existingWallet != null) {
        return existingWallet;
      }

      final docRef = _walletsCollection.doc();
      final now = DateTime.now();

      final wallet = Wallet(
        id: docRef.id,
        userId: _userId,
        balance: 0,
        currency: currency,
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      await docRef.set(WalletModel.fromEntity(wallet).toFirestore());
      return wallet;
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }

  @override
  Future<void> updateBalance(String walletId, double newBalance) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      await _walletsCollection.doc(walletId).update({
        'balance': newBalance,
        'updatedAt': firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update balance: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactions(String walletId) async {
    if (_userId.isEmpty) return [];

    try {
      final snapshot = await _transactionsCollection
          .where('walletId', isEqualTo: walletId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactionsPaginated(
    String walletId, {
    int limit = 20,
    String? startAfter,
  }) async {
    if (_userId.isEmpty) return [];

    try {
      firestore.Query query = _transactionsCollection
          .where('walletId', isEqualTo: walletId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        final startAfterDoc = await _transactionsCollection.doc(startAfter).get();
        query = query.startAfterDocument(startAfterDoc);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get transactions paginated: $e');
    }
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final docRef = _transactionsCollection.doc(transaction.id);
      await docRef.set(TransactionModel.fromEntity(transaction).toFirestore());

      // Update wallet balance based on transaction type
      await _updateWalletBalanceForTransaction(transaction);

      return transaction;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<Transaction?> getTransaction(String transactionId) async {
    try {
      final doc = await _transactionsCollection.doc(transactionId).get();
      if (!doc.exists) return null;

      return TransactionModel.fromFirestore(doc).toEntity();
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  @override
  Future<Subscription?> getActiveSubscription() async {
    if (_userId.isEmpty) return null;

    try {
      final snapshot = await _subscriptionsCollection
          .where('userId', isEqualTo: _userId)
          .where('status', isEqualTo: 'active')
          .where('endDate', isGreaterThan: firestore.FieldValue.serverTimestamp())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return SubscriptionModel.fromFirestore(snapshot.docs.first).toEntity();
    } catch (e) {
      throw Exception('Failed to get active subscription: $e');
    }
  }

  @override
  Future<List<Subscription>> getSubscriptions() async {
    if (_userId.isEmpty) return [];

    try {
      final snapshot = await _subscriptionsCollection
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SubscriptionModel.fromFirestore(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get subscriptions: $e');
    }
  }

  @override
  Future<Subscription> createSubscription(Subscription subscription) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final docRef = _subscriptionsCollection.doc(subscription.id);
      await docRef.set(SubscriptionModel.fromEntity(subscription).toFirestore());

      return subscription;
    } catch (e) {
      throw Exception('Failed to create subscription: $e');
    }
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      await _subscriptionsCollection.doc(subscription.id).update(
        SubscriptionModel.fromEntity(subscription).toFirestore(),
      );
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      await _subscriptionsCollection.doc(subscriptionId).update({
        'status': 'cancelled',
        'cancelledAt': firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  @override
  Stream<double> watchBalance(String walletId) => _walletsCollection.doc(walletId).snapshots().map((doc) {
      if (!doc.exists) return 0.0;
      final data = doc.data();
      return (data?['balance'] as num?)?.toDouble() ?? 0.0;
    });

  @override
  Stream<List<Transaction>> watchTransactions(String walletId) => _transactionsCollection
        .where('walletId', isEqualTo: walletId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc).toEntity())
              .toList());

  @override
  Stream<List<Subscription>> watchSubscriptions() {
    if (_userId.isEmpty) return Stream.value([]);

    return _subscriptionsCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
              .map((doc) => SubscriptionModel.fromFirestore(doc).toEntity())
              .toList());
  }

  @override
  Future<Transaction> processTopUp({
    required String walletId,
    required double amount,
    required String paymentMethod,
    String? description,
  }) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    try {
      final transaction = Transaction(
        id: _transactionsCollection.doc().id,
        walletId: walletId,
        userId: _userId,
        type: TransactionType.topUp,
        amount: amount,
        currency: 'EGP',
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        description: description ?? 'Top up via $paymentMethod',
        metadata: {
          'paymentMethod': paymentMethod,
        },
      );

      await addTransaction(transaction);
      return transaction;
    } catch (e) {
      throw Exception('Failed to process top-up: $e');
    }
  }

  @override
  Future<Transaction> processPayment({
    required String walletId,
    required double amount,
    required String orderId,
    String? description,
  }) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    // Check if user has sufficient balance
    final wallet = await getWallet();
    if (wallet == null || wallet.balance < amount) {
      throw Exception('Insufficient balance');
    }

    try {
      final transaction = Transaction(
        id: _transactionsCollection.doc().id,
        walletId: walletId,
        userId: _userId,
        type: TransactionType.payment,
        amount: amount,
        currency: 'EGP',
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        description: description ?? 'Payment for order $orderId',
        metadata: {
          'orderId': orderId,
        },
      );

      await addTransaction(transaction);
      return transaction;
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  @override
  Future<Transaction> processSubscriptionPayment({
    required String walletId,
    required String subscriptionId,
    required double amount,
    String? description,
  }) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');

    // Check if user has sufficient balance
    final wallet = await getWallet();
    if (wallet == null || wallet.balance < amount) {
      throw Exception('Insufficient balance');
    }

    try {
      final transaction = Transaction(
        id: _transactionsCollection.doc().id,
        walletId: walletId,
        userId: _userId,
        type: TransactionType.subscription,
        amount: amount,
        currency: 'EGP',
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        description: description ?? 'Subscription payment',
        metadata: {
          'subscriptionId': subscriptionId,
        },
      );

      await addTransaction(transaction);
      return transaction;
    } catch (e) {
      throw Exception('Failed to process subscription payment: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getWalletStats(String walletId) async {
    if (_userId.isEmpty) return {};

    try {
      final transactions = await getTransactions(walletId);

      var totalTopUp = 0;
      var totalPayments = 0;
      var totalSubscriptions = 0;

      for (final transaction in transactions) {
        switch (transaction.type) {
          case TransactionType.topUp:
            totalTopUp += transaction.amount;
            break;
          case TransactionType.payment:
            totalPayments += transaction.amount;
            break;
          case TransactionType.subscription:
            totalSubscriptions += transaction.amount;
            break;
          default:
            break;
        }
      }

      return {
        'totalTransactions': transactions.length,
        'totalTopUp': totalTopUp,
        'totalPayments': totalPayments,
        'totalSubscriptions': totalSubscriptions,
        'netAmount': totalTopUp - totalPayments - totalSubscriptions,
      };
    } catch (e) {
      throw Exception('Failed to get wallet stats: $e');
    }
  }

  @override
  Future<bool> hasSufficientBalance(String walletId, double amount) async {
    final wallet = await getWallet();
    return wallet != null && wallet.balance >= amount;
  }

  Future<void> _updateWalletBalanceForTransaction(Transaction transaction) async {
    final wallet = await getWallet();
    if (wallet == null) return;

    var newBalance = wallet.balance;

    switch (transaction.type) {
      case TransactionType.topUp:
      case TransactionType.refund:
      case TransactionType.cashback:
        newBalance += transaction.amount;
        break;
      case TransactionType.payment:
      case TransactionType.subscription:
        newBalance -= transaction.amount;
        break;
      default:
        break;
    }

    await updateBalance(wallet.id, newBalance);
  }
}