# Money Tracker — Instructions IA (Phase 0.1c)

> **PHASE** : 0.1c - CRUD Opérations (Transactions)  
> **PRÉREQUIS** : Phase 0.1b complétée (Comptes fonctionnels)

> **STATUT** : COMPLÉTÉ (2025-12-14) — CRUD Transactions, Virements et calculs de soldes implémentés

---

> **NOTE** : Certaines améliorations UX (sélection explicite compte origine/destination, swipe-to-validate, indicateur visuel validé/pending, positionnement FAB au-dessus bannière) sont planifiées en Phase 0.1d (Polish).

---

## 🎯 OBJECTIF

Implémenter la gestion complète des transactions (create/update/delete) et calculer le solde réel du compte actif à partir de `initialBalance + sum(transactions)`.

**Livrable** : Ajout/modification/suppression d'opérations fonctionnel + solde réel calculé dynamiquement.

---

## 📁 CONTEXTE PROJET

**Localisation** : `apps/money_tracker/`  
**BDD** : Drift déjà configuré avec tables : Accounts, Categories, Transactions, Beneficiaries  
**State** : Riverpod 2.x  
**UI** : Material 3, thème Dotlyn (orange #E36C2D)

**Table Transactions** (déjà créée) :
- id, accountId (FK), categoryId (FK), beneficiaryId (FK nullable)
- amount (double), date, note (nullable), status ('pending' ou 'validated')

---

## 📋 TÂCHES

### 1. Providers Riverpod pour Transactions
**Fichier** : `apps/money_tracker/lib/providers/transactions_provider.dart` (créer)

```dart
// Provider stream transactions filtrées par accountId
final transactionsProvider = StreamProvider.autoDispose.family<List<Transaction>, int>((ref, accountId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.transactions)..where((t) => t.accountId.equals(accountId))).watch();
});

// Repository pour CRUD
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TransactionsRepository(database);
});

class TransactionsRepository {
  final AppDatabase _database;
  TransactionsRepository(this._database);
  
  Future<int> addTransaction({required int accountId, required int categoryId, int? beneficiaryId, required double amount, required DateTime date, String? note, required String status}) { ... }
  Future<void> updateTransaction({required int id, ...}) { ... }
  Future<void> deleteTransaction(int id) { ... }
}
```

### 2. Provider Solde Calculé
**Fichier** : `apps/money_tracker/lib/providers/accounts_provider.dart` (ajouter)

```dart
// Provider qui calcule le solde réel : initialBalance + sum(transactions validées)
final accountBalanceProvider = Provider.family<double, int>((ref, accountId) {
  final accountsAsync = ref.watch(accountsProvider);
  final transactionsAsync = ref.watch(transactionsProvider(accountId));
  
  final accounts = accountsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];
  
  final account = accounts.firstWhere((a) => a.id == accountId, orElse: () => null);
  if (account == null) return 0.0;
  
  final validatedSum = transactions.where((t) => t.status == 'validated').fold<double>(0.0, (sum, t) => sum + t.amount);
  return account.initialBalance + validatedSum;
});
```

### 3. Formulaire Transaction (Bottom Sheet)
**Fichier** : `apps/money_tracker/lib/widgets/forms/transaction_form_sheet.dart` (créer)

- Remplacer `add_transaction_sheet.dart` (actuellement statique)
- Champs :
  - Montant (TextField numérique, requis)
  - Type opération : Revenu (+) ou Dépense (-) (radio buttons ou toggle)
  - Catégorie (DropdownButtonFormField depuis `categoriesProvider`, filtré par type)
  - Bénéficiaire (DropdownButtonFormField depuis `beneficiariesProvider`, nullable)
  - Date (DatePicker, défaut = maintenant)
  - Note (TextField, optionnel)
  - Statut : En attente / Validé (radio buttons)
- Mode création / édition selon paramètre `Transaction?`
- Bouton Enregistrer → appelle `transactionsRepository.addTransaction(...)` ou `updateTransaction(...)`

### 4. Mise à jour Home Screen
**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart` (modifier)

**Changements** :
- Afficher le solde réel calculé via `accountBalanceProvider(activeAccount.id)` au lieu de `initialBalance`
- Afficher "Solde Disponible" = solde réel - sum(transactions 'pending')
- Connecter la liste transactions existante au provider : `transactionsProvider(activeAccount.id)`
- Boutons + / - : ouvrir `TransactionFormSheet()` (nouveau fichier)
- Permettre suppression transaction (swipe ou long press + dialog confirmation)
- Tap sur transaction → ouvrir `TransactionFormSheet(transaction: ...)`

### 5. Providers Catégories & Bénéficiaires (lecture seule pour l'instant)
**Fichier** : `apps/money_tracker/lib/providers/categories_provider.dart` (créer)
**Fichier** : `apps/money_tracker/lib/providers/beneficiaries_provider.dart` (créer)

```dart
// Catégories (lecture seule phase 0.1c)
final categoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.categories).watch();
});

// Bénéficiaires (lecture seule phase 0.1c)
final beneficiariesProvider = StreamProvider.autoDispose<List<Beneficiary>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.beneficiaries).watch();
});
```

---

## ⚙️ DÉTAILS TECHNIQUES

**Calcul Solde Réel** : `initialBalance + sum(transactions.amount WHERE status='validated')`  
**Calcul Solde Disponible** : `Solde Réel - sum(transactions.amount WHERE status='pending')`  
**Montants** : Positif = revenu, Négatif = dépense

**Pas de migration de schéma** : toutes les tables existent déjà.

---

## ✅ CRITÈRES DE SUCCÈS

- [ ] Ajout transaction persiste en BDD
- [ ] Modification transaction persiste
- [ ] Suppression transaction persiste (avec confirmation)
- [ ] Solde réel calculé et affiché en temps réel sur Home
- [ ] Solde disponible calculé et affiché
- [ ] Liste transactions filtrée par compte actif
- [ ] Catégories et bénéficiaires affichés dans dropdowns
- [ ] `flutter analyze` sans erreur

---

## 🚫 NE PAS FAIRE

- ❌ Implémenter CRUD catégories/bénéficiaires (lecture seule suffit)
- ❌ Implémenter filtres date complexes (phase 0.1d)
- ❌ Implémenter récurrences (phase 0.2)
- ❌ Intégrer Firebase/Analytics (phase 0.1e)
- ❌ Modifier schéma BDD (tables déjà OK)

---

**Note** : Ce prompt est concis pour économiser les tokens. L'IA doit implémenter proprement sans sur-engineering.

