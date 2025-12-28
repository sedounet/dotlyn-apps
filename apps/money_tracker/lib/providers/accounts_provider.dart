import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import 'database_provider.dart';
import 'transactions_provider.dart';

final accountsProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.accounts).watch();
});

final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return AccountsRepository(database);
});

final activeAccountIdProvider = NotifierProvider<ActiveAccountIdNotifier, int?>(
  ActiveAccountIdNotifier.new,
);

final activeAccountProvider = Provider<Account?>((ref) {
  final accountsValue = ref.watch(accountsProvider);
  final accounts = accountsValue.value ?? [];
  if (accounts.isEmpty) return null;

  final activeId = ref.watch(activeAccountIdProvider);
  if (activeId != null) {
    for (final account in accounts) {
      if (account.id == activeId) {
        return account;
      }
    }
  }

  return accounts.first;
});

class ActiveAccountIdNotifier extends Notifier<int?> {
  @override
  int? build() {
    ref.listen<AsyncValue<List<Account>>>(accountsProvider, (previous, next) {
      final accounts = next.value ?? [];
      if (accounts.isEmpty) {
        state = null;
        return;
      }
      if (state == null || accounts.every((account) => account.id != state)) {
        state = accounts.first.id;
      }
    });
    return null;
  }

  void setActive(int id) {
    state = id;
  }
}

class AccountsRepository {
  AccountsRepository(this._database);

  final AppDatabase _database;

  Future<int> addAccount({
    required String name,
    required String type,
    required double initialBalance,
  }) {
    return _database
        .into(_database.accounts)
        .insert(
          AccountsCompanion.insert(
            name: name,
            type: type,
            initialBalance: Value(initialBalance),
          ),
        );
  }

  Future<void> updateAccount({
    required int id,
    required String name,
    required String type,
    required double initialBalance,
  }) {
    return (_database.update(
      _database.accounts,
    )..where((tbl) => tbl.id.equals(id))).write(
      AccountsCompanion(
        name: Value(name),
        type: Value(type),
        initialBalance: Value(initialBalance),
      ),
    );
  }

  Future<void> deleteAccount(int id) {
    return (_database.delete(
      _database.accounts,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}

// Provider pour récupérer les virements ENTRANTS (où ce compte est la destination)
final incomingTransfersProvider = StreamProvider.autoDispose
    .family<List<Transaction>, int>((ref, accountId) {
      final database = ref.watch(databaseProvider);
      return (database.select(
        database.transactions,
      )..where((t) => t.accountToId.equals(accountId))).watch();
    });

// Provider qui calcule le solde actuel : initialBalance + sum(transactions where status='validated')
// Inclut uniquement les opérations validées (virements sortants et entrants)
final accountBalanceProvider = Provider.family<double, int>((ref, accountId) {
  final accountsAsync = ref.watch(accountsProvider);
  final transactionsAsync = ref.watch(transactionsProvider(accountId));
  final incomingTransfersAsync = ref.watch(
    incomingTransfersProvider(accountId),
  );

  final accounts = accountsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];
  final incomingTransfers = incomingTransfersAsync.value ?? [];

  Account? account;
  try {
    account = accounts.firstWhere((a) => a.id == accountId);
  } catch (_) {
    account = null;
  }
  if (account == null) return 0.0;

  // Somme des transactions sortantes validées (déjà signées: income positif, expense négatif, transfer négatif)
  final validatedSum = transactions
      .where((t) => t.status == 'validated')
      .fold<double>(0.0, (sum, t) => sum + t.amount);

  // Somme des virements ENTRANTS validés (montant toujours négatif dans la DB, donc on inverse)
  final incomingTransfersSum = incomingTransfers
      .where((t) => t.status == 'validated')
      .fold<double>(0.0, (sum, t) => sum + t.amount.abs());

  return account.initialBalance +
      validatedSum +
      incomingTransfersSum; // Solde actuel (validées uniquement)
});

// Provider qui calcule le solde disponible : Solde actuel + opérations en attente
// Solde Disponible ≤ Solde Actuel (car pending sont généralement des dépenses négatives)
final accountAvailableBalanceProvider = Provider.family<double, int>((
  ref,
  accountId,
) {
  final accountsAsync = ref.watch(accountsProvider);
  final transactionsAsync = ref.watch(transactionsProvider(accountId));
  final incomingTransfersAsync = ref.watch(
    incomingTransfersProvider(accountId),
  );

  final accounts = accountsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];
  final incomingTransfers = incomingTransfersAsync.value ?? [];

  Account? account;
  try {
    account = accounts.firstWhere((a) => a.id == accountId);
  } catch (_) {
    account = null;
  }
  if (account == null) return 0.0;

  // Somme de TOUTES les transactions (validées + en attente)
  final allTransactionsSum = transactions.fold<double>(
    0.0,
    (sum, t) => sum + t.amount,
  );

  // Somme de TOUS les virements entrants (validés + en attente)
  final allIncomingTransfersSum = incomingTransfers.fold<double>(
    0.0,
    (sum, t) => sum + t.amount.abs(),
  );

  return account.initialBalance +
      allTransactionsSum +
      allIncomingTransfersSum; // Solde disponible
});
