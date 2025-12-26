# Money Tracker — Phase 2 Features (Instructions pour Haiku)

> **Branche** : `refactor/money-tracker-cleanup` (ou créer `feat/money-tracker-phase2`)  
> **Généré par** : Opus (2025-12-26)  
> **Objectif** : Implémenter les features avancées Phase 2 (~5h)

---

## 📋 Résumé des Tâches

| # | Feature | Temps | Priorité |
|---|---------|-------|----------|
| 1 | Types de paiement (Enum + BDD + UI) | 2h | 🟡 |
| 2 | Système favoris comptes (Boutons home) | 2h | 🟡 |
| 3 | Écran Settings (Fondation) | 1h | 🟡 |

---

## 🟡 TÂCHE 1 : Types de Paiement

### 1.1 — Créer l'enum PaymentMethod

**Nouveau fichier** : `apps/money_tracker/lib/models/payment_method.dart`

```dart
enum PaymentMethod {
  card('Carte bancaire'),
  transfer('Virement'),
  directDebit('Prélèvement'),
  check('Chèque'),
  cash('Espèces');

  const PaymentMethod(this.label);
  final String label;

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentMethod.card,
    );
  }
}
```

---

### 1.2 — Modifier le schema BDD (app_database.dart)

**Fichier** : `apps/money_tracker/lib/data/database/app_database.dart`

**Ajouter colonne dans table `Transactions`** (chercher la classe `Transactions extends Table`) :

```dart
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  IntColumn get beneficiaryId => integer().nullable().references(Beneficiaries, #id)();
  IntColumn get accountToId => integer().nullable().references(Accounts, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('validated'))();
  
  // NOUVELLES COLONNES À AJOUTER ICI
  TextColumn get paymentMethod => text().withDefault(const Constant('card'))();
  TextColumn get checkNumber => text().nullable()();
}
```

**Après modification** : Exécuter pour régénérer le code Drift :
```bash
cd apps/money_tracker
dart run build_runner build --delete-conflicting-outputs
```

---

### 1.3 — Ajouter colonne default payment dans table Accounts

**Dans la même classe `Accounts extends Table`** :

```dart
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get initialBalance => real()();
  DateTimeColumn get createdAt => dateTime()();
  
  // NOUVELLE COLONNE À AJOUTER ICI
  TextColumn get defaultPaymentMethod => text().withDefault(const Constant('card'))();
}
```

---

### 1.4 — Mettre à jour transaction_form_sheet.dart

**Fichier** : `apps/money_tracker/lib/widgets/forms/transaction_form_sheet.dart`

**A. Importer le modèle** (en haut du fichier) :
```dart
import '../../models/payment_method.dart';
```

**B. Ajouter state variable** (dans `_TransactionFormSheetState`, après `String _type = 'expense';`) :
```dart
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _checkNumber;
```

**C. Initialiser depuis transaction existante** (dans `initState`, après `_type = ...`) :
```dart
    if (t != null) {
      _paymentMethod = PaymentMethod.fromString(t.paymentMethod);
      _checkNumber = t.checkNumber;
    }
```

**D. Ajouter UI après le dropdown Type** (chercher `DropdownButtonFormField<String> value: _type` et ajouter APRÈS) :

```dart
                const SizedBox(height: 12),
                // Type de paiement
                DropdownButtonFormField<PaymentMethod>(
                  value: _paymentMethod,
                  items: PaymentMethod.values
                      .map((pm) => DropdownMenuItem(value: pm, child: Text(pm.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _paymentMethod = v ?? PaymentMethod.card),
                  decoration: const InputDecoration(labelText: 'Moyen de paiement'),
                ),
                // Numéro de chèque si type = chèque
                if (_paymentMethod == PaymentMethod.check) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _checkNumber,
                    decoration: const InputDecoration(labelText: 'Numéro de chèque (optionnel)'),
                    onChanged: (v) => _checkNumber = v.trim().isEmpty ? null : v.trim(),
                  ),
                ],
```

**E. Passer les valeurs lors du save** (chercher `repository.addTransaction` et `repository.updateTransaction`) :

Ajouter ces paramètres dans les deux appels :
```dart
          paymentMethod: _paymentMethod.name,
          checkNumber: _checkNumber,
```

---

### 1.5 — Mettre à jour les providers/repositories

**Fichier** : `apps/money_tracker/lib/providers/transactions_provider.dart`

**Chercher la méthode `addTransaction`** et ajouter les paramètres :

```dart
  Future<void> addTransaction({
    required int accountId,
    int? categoryId,
    int? beneficiaryId,
    int? accountToId,
    required double amount,
    required DateTime date,
    String? note,
    required String status,
    String paymentMethod = 'card',  // AJOUTER
    String? checkNumber,             // AJOUTER
  }) async {
```

**Dans le body** (chercher `TransactionsCompanion.insert`) :
```dart
    await _db.into(_db.transactions).insert(
      TransactionsCompanion.insert(
        accountId: accountId,
        categoryId: Value(categoryId),
        beneficiaryId: Value(beneficiaryId),
        accountToId: Value(accountToId),
        amount: amount,
        date: date,
        note: Value(note),
        status: status,
        paymentMethod: Value(paymentMethod),  // AJOUTER
        checkNumber: Value(checkNumber),       // AJOUTER
      ),
    );
```

**Faire pareil pour `updateTransaction`** (ajouter les 2 paramètres + les passer dans le Companion).

---

### 1.6 — Afficher le type de paiement dans la liste

**Fichier** : `apps/money_tracker/lib/widgets/transaction_list_item.dart`

**Ajouter paramètre** :
```dart
  final String paymentMethod;

  const TransactionListItem({
    super.key,
    required this.note,
    required this.date,
    required this.amount,
    required this.balanceAfter,
    required this.onTap,
    required this.paymentMethod,  // AJOUTER
  });
```

**Dans le build** (ajouter une icône après le montant) :

```dart
        // Après le Text du montant, ajouter :
        const SizedBox(width: 8),
        _getPaymentIcon(paymentMethod),
```

**Ajouter méthode helper** (avant le dernier `}` de la classe) :

```dart
  Widget _getPaymentIcon(String method) {
    IconData icon;
    switch (method) {
      case 'card':
        icon = Icons.credit_card;
        break;
      case 'transfer':
        icon = Icons.swap_horiz;
        break;
      case 'directDebit':
        icon = Icons.autorenew;
        break;
      case 'check':
        icon = Icons.receipt;
        break;
      case 'cash':
        icon = Icons.money;
        break;
      default:
        icon = Icons.payment;
    }
    return Icon(icon, size: 16, color: Colors.grey[600]);
  }
```

**Mettre à jour les appels** dans `home_screen.dart` (passer `paymentMethod: transaction.paymentMethod`).

---

## 🟡 TÂCHE 2 : Système Favoris Comptes

### 2.1 — Créer table favorites dans BDD

**Fichier** : `apps/money_tracker/lib/data/database/app_database.dart`

**Ajouter nouvelle table** (après `class Beneficiaries extends Table`) :

```dart
class FavoriteAccounts extends Table {
  IntColumn get buttonIndex => integer()();
  IntColumn get accountId => integer().references(Accounts, #id)();

  @override
  Set<Column> get primaryKey => {buttonIndex};
}
```

**Ajouter dans la liste des tables** (`@DriftDatabase(tables: [...])`):
```dart
@DriftDatabase(tables: [
  Accounts,
  Categories,
  Transactions,
  Beneficiaries,
  FavoriteAccounts,  // AJOUTER ICI
])
```

**Régénérer** :
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### 2.2 — Créer provider favoris

**Nouveau fichier** : `apps/money_tracker/lib/providers/favorite_accounts_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../data/database/app_database.dart';

final favoriteAccountsProvider = StreamProvider<Map<int, int>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.favoriteAccounts).watch().map((favorites) {
    return Map.fromEntries(
      favorites.map((fav) => MapEntry(fav.buttonIndex, fav.accountId)),
    );
  });
});

class FavoriteAccountsRepository {
  final AppDatabase _db;
  FavoriteAccountsRepository(this._db);

  Future<void> assignAccountToButton(int buttonIndex, int accountId) async {
    await _db.into(_db.favoriteAccounts).insert(
      FavoriteAccountsCompanion.insert(
        buttonIndex: buttonIndex,
        accountId: accountId,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> removeButtonAssignment(int buttonIndex) async {
    await (_db.delete(_db.favoriteAccounts)
          ..where((tbl) => tbl.buttonIndex.equals(buttonIndex)))
        .go();
  }
}

final favoriteAccountsRepositoryProvider = Provider((ref) {
  return FavoriteAccountsRepository(ref.watch(databaseProvider));
});
```

---

### 2.3 — Mettre à jour home_screen.dart

**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart`

**A. Importer le provider** :
```dart
import '../../providers/favorite_accounts_provider.dart';
```

**B. Remplacer les 3 boutons hardcodés** (chercher `List.generate(3, (index) =>`) :

```dart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer(
                builder: (context, ref, _) {
                  final favoritesAsync = ref.watch(favoriteAccountsProvider);
                  final accountsAsync = ref.watch(accountsProvider);

                  return favoritesAsync.when(
                    data: (favorites) => accountsAsync.when(
                      data: (accounts) => Row(
                        children: List.generate(3, (index) {
                          final accountId = favorites[index];
                          final account = accountId != null
                              ? accounts.firstWhere((a) => a.id == accountId,
                                  orElse: () => accounts.first)
                              : null;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: GestureDetector(
                                onTap: () => _handleFavoriteButtonTap(
                                  context,
                                  ref,
                                  index,
                                  account,
                                  accounts,
                                ),
                                child: Container(
                                  height: 64,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DotlynColors.primary, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.account_balance_wallet,
                                          size: 24),
                                      const SizedBox(height: 4),
                                      Text(
                                        account?.name ?? 'Non assigné',
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => Text('Erreur: $e'),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Erreur: $e'),
                  );
                },
              ),
            ),
```

**C. Ajouter méthode handler** (avant le dernier `}` du widget) :

```dart
  void _handleFavoriteButtonTap(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    Account? assignedAccount,
    List<Account> allAccounts,
  ) {
    if (assignedAccount != null) {
      // Ouvrir le détail du compte
      ref.read(activeAccountProvider.notifier).setActiveAccount(assignedAccount.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${assignedAccount.name} sélectionné')),
      );
    } else {
      // Afficher modale pour assigner
      _showAccountSelectionModal(context, ref, buttonIndex, allAccounts);
    }
  }

  void _showAccountSelectionModal(
    BuildContext context,
    WidgetRef ref,
    int buttonIndex,
    List<Account> accounts,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assigner au bouton ${buttonIndex + 1}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                subtitle: Text(account.type),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmer'),
                      content: Text(
                        'Assigner "${account.name}" au bouton ${buttonIndex + 1} ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Confirmer'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await ref
                        .read(favoriteAccountsRepositoryProvider)
                        .assignAccountToButton(buttonIndex, account.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${account.name} assigné !')),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
```

---

## 🟡 TÂCHE 3 : Écran Settings

### 3.1 — Créer table settings dans BDD

**Fichier** : `apps/money_tracker/lib/data/database/app_database.dart`

**Ajouter table** :
```dart
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
```

**Ajouter à la liste** :
```dart
@DriftDatabase(tables: [
  Accounts,
  Categories,
  Transactions,
  Beneficiaries,
  FavoriteAccounts,
  AppSettings,  // AJOUTER
])
```

**Régénérer**.

---

### 3.2 — Créer provider settings

**Nouveau fichier** : `apps/money_tracker/lib/providers/settings_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../data/database/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  Future<String?> getSetting(String key) async {
    final result = await (_db.select(_db.appSettings)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await _db.into(_db.appSettings).insert(
      AppSettingsCompanion.insert(key: key, value: value),
      mode: InsertMode.insertOrReplace,
    );
  }
}

final settingsRepositoryProvider = Provider((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

// Provider pour le thème
final themeSettingProvider = FutureProvider<String>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return await repo.getSetting('theme') ?? 'light';
});
```

---

### 3.3 — Mettre à jour settings_screen.dart

**Fichier** : `apps/money_tracker/lib/screens/settings/settings_screen.dart`

**Remplacer tout le contenu** par :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../providers/ui_state_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeSettingProvider);
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Thème'),
            subtitle: themeAsync.when(
              data: (theme) => Text(theme == 'dark' ? 'Sombre' : 'Clair'),
              loading: () => const Text('Chargement...'),
              error: (e, s) => const Text('Erreur'),
            ),
            trailing: themeAsync.maybeWhen(
              data: (theme) => Switch(
                value: theme == 'dark',
                onChanged: (isDark) async {
                  await ref
                      .read(settingsRepositoryProvider)
                      .setSetting('theme', isDark ? 'dark' : 'light');
                  ref.invalidate(themeSettingProvider);
                },
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          ListTile(
            title: const Text('Masquer les montants'),
            subtitle: const Text('Afficher *** à la place des soldes'),
            trailing: Switch(
              value: !isBalanceVisible,
              onChanged: (value) =>
                  ref.read(balanceVisibilityProvider.notifier).toggleVisibility(),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Locale'),
            subtitle: const Text('Français (FR)'),
            enabled: false,
          ),
          const Divider(),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0 (Phase 0.1a)'),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Validation Finale

### Tests manuels
1. **Types paiement** : Créer opération → Sélectionner "Chèque" → Saisir numéro → Vérifier affichage icône dans liste
2. **Favoris** : Clic bouton vide → Assigner compte → Confirmer → Reclic → Doit ouvrir compte
3. **Settings** : Toggle thème → Vérifier changement (besoin restart app pour voir effet)

### Commandes
```bash
cd apps/money_tracker
flutter analyze
flutter test
git add .
git commit -m "[money_tracker] feat: add payment methods, favorite accounts, settings screen"
```

---

## 📝 Notes pour Haiku

1. **Ordre strict** : Tâche 1 → Tâche 2 → Tâche 3
2. **Régénérer Drift** après chaque modification de schema : `dart run build_runner build --delete-conflicting-outputs`
3. **Tester après chaque tâche** : `flutter analyze` doit passer
4. **Si erreur "table not found"** : Supprimer `build/` et régénérer
5. **BuildContext async** : Toujours vérifier `context.mounted` avant `Navigator.pop`

---

**Temps estimé** : 5h  
**Complexité** : Moyenne (modifications BDD + UI)
