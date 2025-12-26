import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../models/payment_method.dart';
import 'database_provider.dart';

final transactionsProvider = StreamProvider.autoDispose.family<List<Transaction>, int>((
  ref,
  accountId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.transactions,
  )..where((t) => t.accountId.equals(accountId))).watch();
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TransactionsRepository(database);
});

class TransactionsRepository {
  TransactionsRepository(this._database);

  final AppDatabase _database;

  Future<int> addTransaction({
    required int accountId,
    int? categoryId,
    int? beneficiaryId,
    int? accountToId,
    required double amount,
    required DateTime date,
    String? note,
    required String status,
    PaymentMethod paymentMethod = PaymentMethod.card,
    String? checkNumber,
  }) {
    return _database
        .into(_database.transactions)
        .insert(
          TransactionsCompanion.insert(
            accountId: accountId,
            categoryId: Value(categoryId),
            beneficiaryId: Value(beneficiaryId),
            accountToId: Value(accountToId),
            amount: amount,
            date: date,
            note: Value(note),
            status: status,
            paymentMethod: Value(paymentMethod.name),
            checkNumber: Value(checkNumber),
          ),
        );
  }

  Future<void> updateTransaction({
    required int id,
    required int accountId,
    int? categoryId,
    int? beneficiaryId,
    int? accountToId,
    required double amount,
    required DateTime date,
    String? note,
    required String status,
    PaymentMethod paymentMethod = PaymentMethod.card,
    String? checkNumber,
  }) {
    return (_database.update(_database.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        accountId: Value(accountId),
        categoryId: Value(categoryId),
        beneficiaryId: Value(beneficiaryId),
        accountToId: Value(accountToId),
        amount: Value(amount),
        date: Value(date),
        note: Value(note),
        status: Value(status),
        paymentMethod: Value(paymentMethod.name),
        checkNumber: Value(checkNumber),
      ),
    );
  }

  Future<void> deleteTransaction(int id) {
    return (_database.delete(_database.transactions)..where((t) => t.id.equals(id))).go();
  }
}
