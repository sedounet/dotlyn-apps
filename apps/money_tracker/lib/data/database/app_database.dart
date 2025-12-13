import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get beneficiaryId => integer().nullable().references(Beneficiaries, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()(); // 'pending' or 'validated'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Accounts, Categories, Transactions, Beneficiaries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> seedInitialData() async {
    final categoriesCount = await (select(categories)).get();
    if (categoriesCount.isNotEmpty) return;

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
  }

  // À SUPPRIMER EN PHASE 0.1b - Uniquement pour validation UI
  Future<void> seedFakeData() async {
    // Compte fictif
    final accountId = await into(accounts).insert(
      AccountsCompanion.insert(
        name: 'Compte Courant',
        type: 'current',
        initialBalance: const Value(1000.0),
      ),
    );

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

    // Récupérer IDs catégories
    final categoriesList = await select(categories).get();
    final salaryCategory = categoriesList.firstWhere((c) => c.name == 'Salaire');
    final foodCategory = categoriesList.firstWhere((c) => c.name == 'Alimentaire');
    final leisureCategory = categoriesList.firstWhere((c) => c.name == 'Loisirs');

    // Transactions fictives
    await batch((batch) {
      batch.insertAll(transactions, [
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: foodCategory.id,
          beneficiaryId: Value(carrefourId),
          amount: -45.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'pending',
          note: const Value('Courses semaine'),
        ),
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: salaryCategory.id,
          beneficiaryId: Value(employerId),
          amount: 2000.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
          status: 'validated',
          note: const Value('Salaire décembre'),
        ),
        TransactionsCompanion.insert(
          accountId: accountId,
          categoryId: leisureCategory.id,
          beneficiaryId: Value(pizzaHutId),
          amount: -20.0,
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'pending',
          note: const Value('Resto avec amis'),
        ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'money_tracker.sqlite'));
    return NativeDatabase(file);
  });
}
