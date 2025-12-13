# Money Tracker — Instructions IA (Phase 0.1a)

> **IMPORTANT** : Ce prompt couvre UNIQUEMENT la Phase 0.1a (Fondations UX + BDD).  
> **NE PAS implémenter les phases suivantes** (CRUD comptes, opérations, filtres, etc.).  
> **STOP après validation de cette phase.**

---

## 🎯 Objectif Phase 0.1a

Créer les fondations du projet Money Tracker avec :
- Structure projet Flutter propre
- Base de données Drift configurée avec schemas complets
- UI statique (données fake) pour valider le design
- Navigation basique fonctionnelle
- Thème Dotlyn appliqué

**Livrable** : App qui se lance, navigation fonctionne, UI proche finale avec données fictives.

---

## 📁 Contexte Projet

**Type** : Mini-app Flutter dans monorepo Dotlyn Apps  
**Localisation** : `apps/money_tracker/`  
**Packages partagés** :
- `dotlyn_ui` : Thème, couleurs, typography, widgets
- `dotlyn_core` : Services, utils, constants

**Architecture** :
```
apps/money_tracker/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme/         ← Thème Dotlyn
│   │   └── constants/
│   ├── data/
│   │   ├── database/      ← Drift setup + schemas
│   │   └── models/
│   ├── providers/         ← Riverpod providers
│   ├── screens/
│   │   ├── home/
│   │   ├── accounts/
│   │   ├── settings/
│   │   └── onboarding/
│   └── widgets/
│       ├── common/
│       └── forms/
├── pubspec.yaml
└── README.md
```

---

## ✅ Tâches Phase 0.1a

### 1. Setup Projet

- [ ] Vérifier que `apps/money_tracker/` existe avec structure Flutter basique
- [ ] Configurer `pubspec.yaml` avec dépendances :
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    drift: ^2.14.0
    sqlite3_flutter_libs: ^0.5.0
    path_provider: ^2.1.0
    path: ^1.8.3
    flutter_riverpod: ^2.4.0
    intl: ^0.18.0
    dotlyn_ui:
      path: ../../packages/dotlyn_ui
    dotlyn_core:
      path: ../../packages/dotlyn_core
  
  dev_dependencies:
    drift_dev: ^2.14.0
    build_runner: ^2.4.0
  ```

### 2. Configuration Drift (Base de Données)

**Fichier** : `lib/data/database/app_database.dart`

**Schemas à créer** :

```dart
// Table Comptes
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'current', 'savings', 'other'
  RealColumn get initialBalance => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Table Catégories
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => text()(); // 'income' ou 'expense'
  TextColumn get icon => text().nullable()(); // Nom icône Remix Icon
  TextColumn get color => text().nullable()(); // Hex color
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// Table Transactions
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get beneficiaryId => integer().nullable().references(Beneficiaries, #id)();
  RealColumn get amount => real()(); // Positif = revenu, Négatif = dépense
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()(); // 'pending' ou 'validated'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Table Bénéficiaires
class Beneficiaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

**Configuration Database** :
```dart
@DriftDatabase(tables: [Accounts, Categories, Transactions, Beneficiaries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  
  // Seed data initial (catégories Standard)
  Future<void> seedInitialData() async {
    // Vérifier si déjà seedé
    final categoriesCount = await (select(categories)).get();
    if (categoriesCount.isNotEmpty) return;
    
    // Seed catégories profil "Standard"
    await batch((batch) {
      batch.insertAll(categories, [
        // Revenus
        CategoriesCompanion.insert(name: 'Salaire', type: 'income', icon: const Value('ri-money-dollar-circle-line'), sortOrder: const Value(1)),
        CategoriesCompanion.insert(name: 'Remboursement', type: 'income', icon: const Value('ri-refund-line'), sortOrder: const Value(2)),
        CategoriesCompanion.insert(name: 'Autre revenu', type: 'income', icon: const Value('ri-wallet-line'), sortOrder: const Value(3)),
        
        // Dépenses
        CategoriesCompanion.insert(name: 'Alimentaire', type: 'expense', icon: const Value('ri-shopping-cart-line'), sortOrder: const Value(10)),
        CategoriesCompanion.insert(name: 'Transport', type: 'expense', icon: const Value('ri-car-line'), sortOrder: const Value(11)),
        CategoriesCompanion.insert(name: 'Logement', type: 'expense', icon: const Value('ri-home-line'), sortOrder: const Value(12)),
        CategoriesCompanion.insert(name: 'Santé', type: 'expense', icon: const Value('ri-heart-pulse-line'), sortOrder: const Value(13)),
        CategoriesCompanion.insert(name: 'Loisirs', type: 'expense', icon: const Value('ri-gamepad-line'), sortOrder: const Value(14)),
        CategoriesCompanion.insert(name: 'Shopping', type: 'expense', icon: const Value('ri-shopping-bag-line'), sortOrder: const Value(15)),
        CategoriesCompanion.insert(name: 'Autre dépense', type: 'expense', icon: const Value('ri-more-line'), sortOrder: const Value(16)),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'money_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

**Générer code Drift** :
```bash
flutter pub run build_runner build
```

### 3. Setup Riverpod

**Fichier** : `lib/providers/database_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});
```

### 4. Thème Dotlyn

**Fichier** : `lib/core/theme/app_theme.dart`

Utiliser les couleurs du styleguide :
- Orange terre cuite : `#E36C2D`
- Gris anthracite : `#2C2C2C`
- Typo : Satoshi (titres), Manrope (UI)

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFE36C2D);
  static const Color darkGrey = Color(0xFF2C2C2C);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
    ),
    fontFamily: 'Manrope',
    // Utiliser Satoshi pour les titres dans les TextThemes
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryOrange,
      foregroundColor: Colors.white,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Manrope',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.w600),
    ),
  );
}
```

### 5. Données Fictives (à supprimer ultérieurement)

**Fichier** : `lib/data/database/app_database.dart` (ajouter méthode)

```dart
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
  final carrefourId = await into(beneficiaries).insert(
    BeneficiariesCompanion.insert(name: 'Carrefour'),
  );
  final employerId = await into(beneficiaries).insert(
    BeneficiariesCompanion.insert(name: 'Employeur'),
  );
  final pizzaHutId = await into(beneficiaries).insert(
    BeneficiariesCompanion.insert(name: 'Pizza Hut'),
  );
  
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
```

**Appel dans main.dart** :
```dart
// Après seedInitialData()
await database.seedFakeData(); // TODO: Supprimer en phase 0.1b
```

### 6. UI Statique - Home Screen

**Fichier** : `lib/screens/home/home_screen.dart`

Layout complet selon wireframe fourni :
- Header avec titre + icône masquage (non fonctionnel encore)
- Nom compte (hardcodé "Compte Courant")
- Solde Réel + Solde Disponible (valeurs fixes : 1000€, 900€)
- Liste opérations (lecture depuis BDD via FutureBuilder - fonctionnel)
- Bannière pub placeholder (Container avec couleur)
- Boutons +/- en bottom (onTap vide pour l'instant)

**Important** : Utiliser données de la BDD pour la liste (via provider), pas hardcodé.

### 7. Navigation Basique

**Fichier** : `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init database et seed
  final database = AppDatabase();
  await database.seedInitialData();
  await database.seedFakeData(); // TODO: Supprimer en phase 0.1b
  
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
```

**Drawer (burger menu)** dans HomeScreen :
- Items de menu : Accueil, Mes Comptes, Catégories, Bénéficiaires, Paramètres, À propos
- Navigation vers pages vides (Scaffold avec AppBar uniquement)

### 8. Bottom Sheet Ajout Opération (UI Only)

**Fichier** : `lib/widgets/forms/add_transaction_sheet.dart`

Layout complet selon wireframe :
- Champs : Montant, Catégorie (dropdown), Bénéficiaire (dropdown), Date (picker), Note, Statut (radio)
- Bouton Enregistrer (onPressed vide)
- **PAS de logique de sauvegarde** (phase 0.1c)

### 9. Pages Secondaires Vides

Créer structures vides pour :
- `lib/screens/accounts/accounts_screen.dart`
- `lib/screens/settings/settings_screen.dart`
- `lib/screens/beneficiaries/beneficiaries_screen.dart`

Juste un Scaffold avec AppBar et texte "En construction".

---

## 🚫 Ce qu'il NE FAUT PAS Faire (Phases Suivantes)

- ❌ Implémenter CRUD comptes (phase 0.1b)
- ❌ Implémenter sauvegarde opérations (phase 0.1c)
- ❌ Implémenter filtres (phase 0.1d)
- ❌ Intégrer Firebase/AdMob (phase 0.1e)
- ❌ Créer onboarding catégories (phase 0.1f)

**STOP après validation de la checklist ci-dessous.**

---

## ✅ Critères de Succès Phase 0.1a

- [ ] App se lance sans erreur
- [ ] Base de données initialisée avec 10 catégories
- [ ] Données fictives chargées (1 compte, 3 transactions)
- [ ] Home screen affiche les 3 transactions depuis la BDD
- [ ] Navigation burger menu fonctionne (vers pages vides)
- [ ] Bottom sheet s'ouvre au tap bouton + ou -
- [ ] Thème Dotlyn appliqué (couleurs orange/gris)
- [ ] `flutter analyze` : 0 erreur
- [ ] Code lint-free

---

## 📝 Checklist Validation Manuelle

Après implémentation, vérifier :
1. Run `flutter pub get`
2. Run `flutter pub run build_runner build`
3. Run `flutter analyze` → 0 erreur
4. Run app sur émulateur/device
5. Vérifier affichage liste transactions
6. Tester navigation drawer
7. Tester ouverture bottom sheet

**Une fois validé → Commit** :
```bash
git add .
git commit -m "[money_tracker] feat: phase 0.1a - fondations UX + BDD"
```

---

## 🔄 Après Validation

**NE PAS continuer avec phase 0.1b.**  
Attendre instructions pour générer PROMPT_AI phase suivante.

---

**Version** : 0.1a  
**Date** : 2025-12-13
