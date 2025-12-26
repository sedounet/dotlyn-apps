# Money Tracker — Instructions de Refactoring pour Haiku

> **Branche** : `refactor/money-tracker-cleanup`  
> **Généré par** : Opus (2025-12-26)  
> **Objectif** : Nettoyer le code, supprimer duplications, utiliser packages partagés

---

## 📋 Résumé des Tâches

| # | Tâche | Fichier | Priorité |
|---|-------|---------|----------|
| 1 | Supprimer thème local dupliqué | `lib/core/theme/app_theme.dart` | 🔴 |
| 2 | Utiliser DotlynTheme dans main | `lib/main.dart` | 🔴 |
| 3 | Remplacer couleurs hardcodées | `lib/screens/home/home_screen.dart` | 🔴 |
| 4 | Supprimer import inutilisé | `lib/screens/home/home_screen.dart` | 🟡 |
| 5 | Fix BuildContext async gap | `lib/screens/home/home_screen.dart` | 🟡 |
| 6 | Supprimer fichier doublon | `lib/widgets/forms/add_transaction_sheet.dart` | 🟡 |
| 7 | Fix super.key pattern | `lib/widgets/action_buttons_bar.dart` | 🟢 |
| 8 | Fix super.key pattern | `lib/widgets/transaction_list_item.dart` | 🟢 |
| 9 | Fix RadioListTile deprecated | `lib/widgets/forms/transaction_form_sheet.dart` | 🟢 |

---

## 🔴 TÂCHE 1 : Supprimer le thème local dupliqué

**Fichier** : `apps/money_tracker/lib/core/theme/app_theme.dart`

**Action** : Supprimer tout le fichier

**Commande** :
```bash
git rm apps/money_tracker/lib/core/theme/app_theme.dart
rmdir apps/money_tracker/lib/core/theme  # si vide
rmdir apps/money_tracker/lib/core  # si vide
```

**Raison** : Ce fichier duplique `packages/dotlyn_ui/lib/theme/` qui est déjà une dépendance.

---

## 🔴 TÂCHE 2 : Utiliser DotlynTheme dans main.dart

**Fichier** : `apps/money_tracker/lib/main.dart`

**AVANT** (lignes 1-8) :
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/database_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home/home_screen.dart';
```

**APRÈS** :
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

import 'providers/database_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home/home_screen.dart';
```

---

**AVANT** (lignes 50-54 environ) :
```dart
    return MaterialApp(
      title: 'Money Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
```

**APRÈS** :
```dart
    return MaterialApp(
      title: 'Money Tracker',
      theme: DotlynTheme.lightTheme,
      darkTheme: DotlynTheme.darkTheme,
      home: const HomeScreen(),
    );
```

---

## 🔴 TÂCHE 3 : Remplacer couleurs hardcodées dans home_screen.dart

**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart`

**Ajouter import** (après les imports existants) :
```dart
import 'package:dotlyn_ui/dotlyn_ui.dart';
```

**Remplacements à effectuer** :

| Ligne | AVANT | APRÈS |
|-------|-------|-------|
| 101 | `const Color(0xFFE36C2D)` | `DotlynColors.primary` |
| 102 | `const Color(0xFF2C2C2C)` | `DotlynColors.secondary` |
| 124 | `Color(0xFF2C2C2C)` | `DotlynColors.secondary` |
| 155 | `const Color(0xFFE36C2D)` | `DotlynColors.primary` |
| 166 | `const Color(0xFFE36C2D)` | `DotlynColors.primary` |
| 177 | `const Color(0xFFE36C2D)` | `DotlynColors.primary` |

**Note** : Retirer `const` devant les couleurs car `DotlynColors.primary` est déjà const.

---

## 🟡 TÂCHE 4 : Supprimer import inutilisé

**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart`

**AVANT** (ligne 5) :
```dart
import '../../widgets/action_buttons_bar.dart';
```

**APRÈS** : Supprimer cette ligne complètement.

---

## 🟡 TÂCHE 5 : Fix BuildContext across async gap

**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart`

**Ligne concernée** : ~266

**Chercher** le pattern :
```dart
await someAsyncOperation();
ScaffoldMessenger.of(context).showSnackBar(...);
```

**Remplacer par** :
```dart
await someAsyncOperation();
if (!context.mounted) return;
ScaffoldMessenger.of(context).showSnackBar(...);
```

---

## 🟡 TÂCHE 6 : Supprimer fichier doublon add_transaction_sheet.dart

**Fichier** : `apps/money_tracker/lib/widgets/forms/add_transaction_sheet.dart`

**Action** : Supprimer le fichier (c'est un template non utilisé, `transaction_form_sheet.dart` fait le vrai travail)

**Vérification avant suppression** :
```bash
grep -r "add_transaction_sheet" apps/money_tracker/lib/
```

Si aucun import n'utilise ce fichier, le supprimer :
```bash
git rm apps/money_tracker/lib/widgets/forms/add_transaction_sheet.dart
```

---

## 🟢 TÂCHE 7 : Fix super.key pattern - action_buttons_bar.dart

**Fichier** : `apps/money_tracker/lib/widgets/action_buttons_bar.dart`

**AVANT** (ligne 8) :
```dart
const ActionButtonsBar({Key? key}) : super(key: key);
```

**APRÈS** :
```dart
const ActionButtonsBar({super.key});
```

---

## 🟢 TÂCHE 8 : Fix super.key pattern - transaction_list_item.dart

**Fichier** : `apps/money_tracker/lib/widgets/transaction_list_item.dart`

**AVANT** (ligne 11) :
```dart
const TransactionListItem({Key? key, ...}) : super(key: key);
```

**APRÈS** :
```dart
const TransactionListItem({super.key, ...});
```

---

## 🟢 TÂCHE 9 : Fix RadioListTile deprecated API

**Fichier** : `apps/money_tracker/lib/widgets/forms/transaction_form_sheet.dart`

**Lignes concernées** : 275-276, 283-284

**AVANT** :
```dart
RadioListTile<String>(
  title: const Text('Validé'),
  value: 'validated',
  groupValue: _status,
  onChanged: (v) => setState(() => _status = v ?? 'validated'),
),
```

**APRÈS** (Flutter 3.32+) :
```dart
RadioListTile<String>.adaptive(
  title: const Text('Validé'),
  value: 'validated',
  groupValue: _status,
  onChanged: (v) => setState(() => _status = v ?? 'validated'),
),
```

**Note** : Les warnings `groupValue`/`onChanged` deprecated concernent une future migration vers `RadioGroup`. Pour l'instant, ajouter `.adaptive` suffit à moderniser sans breaking change. La migration complète vers `RadioGroup` peut attendre Flutter 4.x.

---

## ✅ Validation Finale

Après toutes les modifications, exécuter :

```bash
cd apps/money_tracker
flutter analyze
flutter test
```

**Objectif** : 0 warnings, 0 infos (sauf deprecated RadioListTile si non migré)

---

## 📦 Commit Final

```bash
git add .
git commit -m "[money_tracker] refactor: use shared dotlyn_ui theme, remove duplicates, fix lint issues"
```

---

## 📝 Notes pour Haiku

1. **Ordre d'exécution** : Suivre les tâches dans l'ordre (1→9)
2. **Tâche 1 dépend de Tâche 2** : Ne pas supprimer app_theme.dart avant d'avoir mis à jour main.dart
3. **Tâche 3 dépend de Tâche 4** : L'import dotlyn_ui remplace l'import action_buttons_bar
4. **Tester après chaque groupe** : `flutter analyze` après tâches 1-3, puis après 4-6, puis après 7-9
5. **Ne pas toucher aux autres fichiers** : Focus uniquement sur les fichiers listés

---

**Temps estimé** : 30-45 minutes  
**Difficulté** : Facile (modifications mécaniques)
