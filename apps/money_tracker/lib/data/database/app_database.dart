import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Define tables
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'current', 'savings', 'other'
  RealColumn get initialBalance => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get defaultPaymentMethod =>
      text().withDefault(const Constant('card'))();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => text()(); // 'income' or 'expense'
  TextColumn get icon => text().nullable()(); // Icon name
  TextColumn get color => text().nullable()(); // Hex color
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Beneficiaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FavoriteAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get buttonIndex => integer().unique()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get beneficiaryId =>
      integer().nullable().references(Beneficiaries, #id)();
  IntColumn get accountToId => integer().nullable().references(
        Accounts,
        #id,
        onDelete: KeyAction.cascade,
      )(); // For transfers
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()(); // 'pending' or 'validated'
  TextColumn get paymentMethod => text().withDefault(const Constant('card'))();
  TextColumn get checkNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Transactions,
    Beneficiaries,
    FavoriteAccounts,
    AppSettings
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            // Add accountToId for transfers and make categoryId nullable
            await m.addColumn(transactions, transactions.accountToId);
            // Note: SQLite doesn't support making existing columns nullable directly
            // New transactions will use nullable categoryId via Companion.insert
          }
          if (from <= 2) {
            // v3: Add new columns to Transactions
            await m.addColumn(transactions, transactions.paymentMethod);
            await m.addColumn(transactions, transactions.checkNumber);
            // v3: Add defaultPaymentMethod to Accounts
            await m.addColumn(accounts, accounts.defaultPaymentMethod);
          }
          if (from <= 3) {
            // v4: Create FavoriteAccounts and AppSettings tables
            await m.createTable(favoriteAccounts);
            await m.createTable(appSettings);
          }
        },
      );

  Future<void> seedInitialData() async {
    // Check with count() instead of get() - much faster
    final count = await (selectOnly(categories)
          ..addColumns([categories.id.count()]))
        .getSingle();
    final categoriesCount = count.read(categories.id.count()) ?? 0;

    if (categoriesCount > 0) {
      return; // Categories already seeded, skip silently
    }

    debugPrint('[DB] Seed: Inserting initial categories...');
    await batch((batch) {
      batch.insertAll(categories, [
        // Revenus
        CategoriesCompanion.insert(
          name: 'Salaire',
          type: 'income',
          icon: const Value('ri-money-dollar-circle-line'),
          sortOrder: const Value(1),
        ),
        CategoriesCompanion.insert(
          name: 'Remboursement',
          type: 'income',
          icon: const Value('ri-refund-line'),
          sortOrder: const Value(2),
        ),
        CategoriesCompanion.insert(
          name: 'Autre revenu',
          type: 'income',
          icon: const Value('ri-wallet-line'),
          sortOrder: const Value(3),
        ),

        // Dépenses
        CategoriesCompanion.insert(
          name: 'Alimentaire',
          type: 'expense',
          icon: const Value('ri-shopping-cart-line'),
          sortOrder: const Value(10),
        ),
        CategoriesCompanion.insert(
          name: 'Transport',
          type: 'expense',
          icon: const Value('ri-car-line'),
          sortOrder: const Value(11),
        ),
        CategoriesCompanion.insert(
          name: 'Logement',
          type: 'expense',
          icon: const Value('ri-home-line'),
          sortOrder: const Value(12),
        ),
        CategoriesCompanion.insert(
          name: 'Santé',
          type: 'expense',
          icon: const Value('ri-heart-pulse-line'),
          sortOrder: const Value(13),
        ),
        CategoriesCompanion.insert(
          name: 'Loisirs',
          type: 'expense',
          icon: const Value('ri-gamepad-line'),
          sortOrder: const Value(14),
        ),
        CategoriesCompanion.insert(
          name: 'Shopping',
          type: 'expense',
          icon: const Value('ri-shopping-bag-line'),
          sortOrder: const Value(15),
        ),
        CategoriesCompanion.insert(
          name: 'Autre dépense',
          type: 'expense',
          icon: const Value('ri-more-line'),
          sortOrder: const Value(16),
        ),
      ]);
    });

    debugPrint('[DB] Seed: Categories inserted successfully.');
  }

  // À SUPPRIMER EN PHASE 0.1b - Uniquement pour validation UI
  Future<void> seedFakeData() async {
    // GARDE-FOU: Vérifier si des données fictives existent déjà
    final existingAccounts = await (select(accounts)).get();
    final existingBeneficiaries = await (select(beneficiaries)).get();
    final existingTransactions = await (select(transactions)).get();

    if (existingAccounts.isNotEmpty ||
        existingBeneficiaries.isNotEmpty ||
        existingTransactions.isNotEmpty) {
      debugPrint(
        '[DB] Seed Fake: Data already exists (${existingAccounts.length} accounts, ${existingBeneficiaries.length} beneficiaries, ${existingTransactions.length} transactions), skipping fake data.',
      );
      return;
    }

    debugPrint('[DB] Seed Fake: Inserting fake data for UI validation...');

    // Compte fictif
    final accountId = await into(accounts).insert(
      AccountsCompanion.insert(
        name: 'Compte Courant',
        type: 'current',
        initialBalance: const Value(1000.0),
      ),
    );

    debugPrint('[DB] Seed Fake: Account created with ID: $accountId');

    // Bénéficiaires fictifs
    final carrefourId = await into(
      beneficiaries,
    ).insert(BeneficiariesCompanion.insert(name: 'Carrefour'));
    final employerId = await into(
      beneficiaries,
    ).insert(BeneficiariesCompanion.insert(name: 'Employeur'));
    final pizzaHutId = await into(
      beneficiaries,
    ).insert(BeneficiariesCompanion.insert(name: 'Pizza Hut'));

    debugPrint(
      '[DB] Seed Fake: 3 beneficiaries created (IDs: $carrefourId, $employerId, $pizzaHutId)',
    );

    // Récupérer IDs catégories
    final categoriesList = await select(categories).get();
    final salaryCategory =
        categoriesList.firstWhere((c) => c.name == 'Salaire');
    final foodCategory =
        categoriesList.firstWhere((c) => c.name == 'Alimentaire');
    final leisureCategory =
        categoriesList.firstWhere((c) => c.name == 'Loisirs');

    // Transactions fictives
    await batch((batch) {
      batch.insertAll(transactions, [
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: Value(foodCategory.id),
          beneficiaryId: Value(carrefourId),
          amount: -45.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'pending',
          note: const Value('Courses semaine'),
        ),
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: Value(salaryCategory.id),
          beneficiaryId: Value(employerId),
          amount: 2000.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: 'validated',
          note: const Value('Salaire décembre'),
        ),
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: Value(leisureCategory.id),
          beneficiaryId: Value(pizzaHutId),
          amount: -20.0,
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'pending',
          note: const Value('Resto avec amis'),
        ),
      ]);
    });

    final insertedTransactions = await (select(transactions)).get();
    debugPrint(
      '[DB] Seed Fake: ${insertedTransactions.length} transactions inserted. Fake data seed complete.',
    );
  }

  /// Dev helper: delete all tables and reseed initial + fake data (if requested).
  /// Use only in debug/testing.
  Future<void> resetToDefaultData({bool includeFakeData = true}) async {
    debugPrint('[DB] Reset: Starting database reset...');

    await transaction(() async {
      final txCount = await (select(transactions)).get();
      final benCount = await (select(beneficiaries)).get();
      final catCount = await (select(categories)).get();
      final accCount = await (select(accounts)).get();

      debugPrint(
        '[DB] Reset: Deleting ${txCount.length} transactions, ${benCount.length} beneficiaries, ${catCount.length} categories, ${accCount.length} accounts...',
      );

      await delete(transactions).go();
      await delete(beneficiaries).go();
      await delete(categories).go();
      await delete(accounts).go();
    });

    debugPrint('[DB] Reset: All data deleted. Re-seeding...');

    await seedInitialData();
    if (includeFakeData) {
      await seedFakeData();
    }

    debugPrint('[DB] Reset: Database reset complete.');
  }

  /// Diagnostic helper: get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final accountsCount = await (select(accounts)).get();
    final categoriesCount = await (select(categories)).get();
    final beneficiariesCount = await (select(beneficiaries)).get();
    final transactionsCount = await (select(transactions)).get();

    return {
      'accounts': accountsCount.length,
      'categories': categoriesCount.length,
      'beneficiaries': beneficiariesCount.length,
      'transactions': transactionsCount.length,
    };
  }

  /// Diagnostic helper: check for potential data integrity issues
  Future<List<String>> checkIntegrity() async {
    final issues = <String>[];

    // Check for orphan transactions (categoryId or beneficiaryId reference deleted records)
    final allTransactions = await (select(transactions)).get();
    final allCategories = await (select(categories)).get();
    final allBeneficiaries = await (select(beneficiaries)).get();
    final allAccounts = await (select(accounts)).get();

    final categoryIds = allCategories.map((c) => c.id).toSet();
    final beneficiaryIds = allBeneficiaries.map((b) => b.id).toSet();
    final accountIds = allAccounts.map((a) => a.id).toSet();

    for (final tx in allTransactions) {
      if (!accountIds.contains(tx.accountId)) {
        issues.add(
            'Transaction ${tx.id} references non-existent account ${tx.accountId}');
      }
      if (tx.categoryId != null && !categoryIds.contains(tx.categoryId)) {
        issues.add(
            'Transaction ${tx.id} references non-existent category ${tx.categoryId}');
      }
      if (tx.beneficiaryId != null &&
          !beneficiaryIds.contains(tx.beneficiaryId)) {
        issues.add(
            'Transaction ${tx.id} references non-existent beneficiary ${tx.beneficiaryId}');
      }
      if (tx.accountToId != null && !accountIds.contains(tx.accountToId)) {
        issues.add(
            'Transaction ${tx.id} references non-existent accountTo ${tx.accountToId}');
      }
    }

    // Check for duplicate category names
    final categoryNames = <String, int>{};
    for (final cat in allCategories) {
      categoryNames[cat.name] = (categoryNames[cat.name] ?? 0) + 1;
    }
    categoryNames.forEach((name, count) {
      if (count > 1) {
        issues.add('Duplicate category name: "$name" ($count occurrences)');
      }
    });

    // Check for duplicate beneficiary names
    final beneficiaryNames = <String, int>{};
    for (final ben in allBeneficiaries) {
      beneficiaryNames[ben.name] = (beneficiaryNames[ben.name] ?? 0) + 1;
    }
    beneficiaryNames.forEach((name, count) {
      if (count > 1) {
        issues.add('Duplicate beneficiary name: "$name" ($count occurrences)');
      }
    });

    if (issues.isEmpty) {
      debugPrint('[DB] Integrity check: All checks passed ✓');
    } else {
      debugPrint('[DB] Integrity check: ${issues.length} issue(s) found:');
      for (final issue in issues) {
        debugPrint('  ⚠ $issue');
      }
    }

    return issues;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'money_tracker.sqlite'));
    return NativeDatabase(file);
  });
}
