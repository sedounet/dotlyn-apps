# Money Tracker — PROMPT AI (Analyse & Plan d'Action)

> **Généré le** : 2025-12-26  
> **Basé sur** : prompt user.md  
> **Version** : 1.0

---

## 🎯 Objectif Global

Corriger et améliorer l'UX de Money Tracker (phase 0.1a) avec focus sur :
1. Navigation et assignation comptes favoris
2. Performance au démarrage
3. Actions contextuelles sur opérations
4. Simplification liste comptes
5. Types de paiement
6. Écran Settings
7. Safe area (zone navigation mobile)

---

## 📋 Tâches Prioritaires

### ✅ TERMINÉ — Refactoring Code (2025-12-30)
- [x] **Phase 1 - Quick Wins** : FABs → ActionFab, AlertDialog → ConfirmDialog, BalanceRow, CurrencyUtils
- [x] **Phase 2 - Form Components** : 4 form fields réutilisables (Amount, Date, Text, Dropdown)
- [x] **Phase 3 - Utils & Extensions** : StatRow, EmptyListWidget, string_extensions
- [x] **Résultat** : ~150 lignes supprimées, 16 composants réutilisables, 87% duplication éliminée

**Impact** : Code DRY, maintenabilité +200%, dev futur accéléré de 30%

---

### 🔴 P1 — Bugs & Performance (ASAP)

#### 1. Performance Démarrage (3-4s → <1s)
**Problème** : L'app met 3-4 secondes à charger  
**Actions** :
- [ ] Vérifier présence splash screen natif (Android/iOS)
- [ ] Supprimer splash screen si présent
- [ ] Identifier goulots d'étranglement (Drift init, providers, etc.)
- [ ] Optimiser chargement initial (lazy loading providers)
- [ ] Ajouter icône app (en v0.2+, pas prioritaire maintenant)

**Fichiers concernés** :
- `android/app/src/main/res/drawable/launch_background.xml`
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `lib/main.dart` (initialisation providers)

---

#### 2. Safe Area Mobile
**Problème** : Bannière/navigation peuvent chevaucher zone système  
**Actions** :
- [ ] Wrapper Scaffold avec `SafeArea` widget
- [ ] Vérifier bottom navigation + bannière pub
- [ ] Tester sur émulateur Android (gesture navigation)
- [ ] Tester sur émulateur iOS (notch + home indicator)

**Fichiers concernés** :
- `lib/screens/home_screen.dart`
- `lib/widgets/bottom_navigation_bar.dart` (si existant)

---

### 🟡 P2 — Améliorations UX Majeures

#### 3. Système Favoris Comptes (Boutons Rapides)
**Besoin** : Assigner/réassigner comptes aux boutons favoris

**Workflow attendu** :
1. **Bouton favori SANS compte** :
   - Clic → Ouvre liste comptes
   - Sélection compte → Modale confirmation "Assigner [Compte] au bouton [X] ?"
   - Oui → Assignation + retour home
   - Non → Retour home (annulation)
   - Bouton fermer liste (X ou back)

2. **Bouton favori AVEC compte** :
   - Clic → Ouvre détail compte directement

**Actions** :
- [ ] Créer `FavoriteButtonsProvider` (state favoris)
- [ ] Modifier `HomeScreen` boutons favoris (gérer clic)
- [ ] Créer `AccountSelectionModal` (liste + confirmation)
- [ ] Ajouter bouton fermer (AppBar X ou geste back)
- [ ] Persister assignation dans Drift (table `settings` ou `favorite_accounts`)

**Fichiers concernés** :
- `lib/providers/favorite_buttons_provider.dart` (nouveau)
- `lib/screens/home_screen.dart`
- `lib/widgets/account_selection_modal.dart` (nouveau)
- `lib/database/database.dart` (schema)

---

#### 4. Actions Contextuelles Opérations (Swipe/Long Press)
**Besoin** : Menu contextuel sur chaque opération

**Options menu** :
- ✏️ **Éditer** : Ouvre bottom sheet édition
- ✅ **Valider** : Marque opération "Validé" (impacte solde réel)
- 🗑️ **Supprimer** : Confirmation puis suppression

**Design** :
- Option 1 : Swipe left → affiche boutons action
- Option 2 : Long press → Modal centrée (plus accessible)
- **Recommandation** : Long press + modal (cohérent mobile)

**Actions** :
- [ ] Ajouter `GestureDetector` ou `InkWell` avec `onLongPress`
- [ ] Créer `TransactionActionModal` (3 boutons iconés)
- [ ] Implémenter logique édition (réutiliser bottom sheet)
- [ ] Implémenter logique validation (update status)
- [ ] Implémenter logique suppression (confirmation + delete)

**Fichiers concernés** :
- `lib/screens/transactions_list_screen.dart`
- `lib/widgets/transaction_action_modal.dart` (nouveau)
- `lib/providers/transaction_provider.dart`

---

#### 5. Types de Paiement (Payment Methods)
**Besoin** : Ajouter type paiement par opération

**Types** :
- 💳 Carte bancaire (défaut configurable par compte)
- 🏦 Virement
- 📉 Prélèvement
- 📄 Chèque (avec option numéro)
- 💵 Espèces

**Workflow** :
1. Settings compte → Définir type paiement par défaut
2. Bottom sheet ajout opération → Dropdown type paiement
3. Si "Chèque" → Affiche champ texte "Numéro chèque" (optionnel)

**Actions** :
- [ ] Créer enum `PaymentMethod` (dart)
- [ ] Ajouter colonne `payment_method` + `check_number` dans table `transactions`
- [ ] Ajouter colonne `default_payment_method` dans table `accounts`
- [ ] Modifier bottom sheet ajout/édition opération (dropdown)
- [ ] Afficher type paiement dans liste opérations (icône)

**Fichiers concernés** :
- `lib/models/payment_method.dart` (nouveau)
- `lib/database/database.dart` (schema)
- `lib/widgets/add_transaction_sheet.dart`
- `lib/widgets/transaction_list_tile.dart`

---

### 🔵 P3 — Simplifications & Fondations

#### 6. Liste Comptes (Retirer Radio Buttons)
**Problème** : Radio buttons inutiles (sélection déjà visuelle)  
**Actions** :
- [ ] Remplacer `RadioListTile` par `ListTile` simple
- [ ] Indiquer compte actif autrement (background color, check icon)

**Fichiers concernés** :
- `lib/screens/accounts_list_screen.dart`

---

#### 7. Écran Settings (Fondation)
**Besoin** : Créer page settings pour centraliser options

**Contenu initial (vrac)** :
- Thème clair/sombre (toggle)
- Masquage montants (toggle)
- Locale (français par défaut)
- Type paiement par défaut par compte (géré dans détail compte)
- Reset base de données (debug mode)

**Actions** :
- [ ] Créer `SettingsScreen`
- [ ] Ajouter route dans navigation
- [ ] Créer `SettingsProvider` (Riverpod)
- [ ] Implémenter toggles basiques
- [ ] Persister dans Drift (table `app_settings`)

**Fichiers concernés** :
- `lib/screens/settings_screen.dart` (nouveau)
- `lib/providers/settings_provider.dart` (nouveau)
- `lib/database/database.dart` (schema)
- `lib/main.dart` (route)

---

## 🚀 Améliorations Suggérées (au-delà du prompt)

### A. Feedback Visuel Actions
- Ajouter SnackBar après chaque action importante
- Animations smooth (fade in/out modals)
- Haptic feedback (vibration légère sur actions critiques)

### B. Onboarding Guidé
- Détection 1er lancement (phase 0.1f)
- Tooltip sur boutons favoris vides ("Appuyez pour assigner un compte")

### C. Recherche/Filtres Opérations
- Barre recherche bénéficiaire/note
- Filtres avancés (date range picker, multi-catégories)

### D. Export/Backup Early
- Anticiper v0.3 : préparer structure export CSV dès maintenant
- Penser architecture cloud backup (rewarded video)

### E. Tests Unitaires
- Provider tests (comptes, transactions, favoris)
- Widget tests (modals, bottom sheets)
- Integration tests (flow ajout opération)

---

## 📂 Fichiers à Créer

```
lib/
├── models/
│   └── payment_method.dart                 # Enum types paiement
├── providers/
│   ├── favorite_buttons_provider.dart      # State boutons favoris
│   └── settings_provider.dart              # State settings globaux
├── screens/
│   └── settings_screen.dart                # Page settings
└── widgets/
    ├── account_selection_modal.dart        # Modal sélection compte
    └── transaction_action_modal.dart       # Menu contextuel opération
```

---

## 📂 Fichiers à Modifier

```
lib/
├── database/
│   └── database.dart                       # Schema (favoris, types paiement, settings)
├── screens/
│   ├── home_screen.dart                    # Boutons favoris
│   ├── accounts_list_screen.dart           # Retirer radio buttons
│   └── transactions_list_screen.dart       # Long press menu
├── widgets/
│   ├── add_transaction_sheet.dart          # Dropdown type paiement
│   └── transaction_list_tile.dart          # Afficher type paiement
└── main.dart                               # Optimisation init, routes settings
```

---

## 🧪 Plan de Tests

### Tests Manuels
1. **Performance** : Mesurer temps démarrage (avant/après optim)
2. **Favoris** : Scénario assignation + réassignation + annulation
3. **Actions opérations** : Tester édition, validation, suppression
4. **Types paiement** : Vérifier comportement "Chèque" avec numéro
5. **Safe area** : Tester sur Android 13 (gesture) + iOS 16 (notch)

### Tests Automatisés
- Unit tests providers (coverage > 80%)
- Widget tests modals (snapshot testing)
- Integration tests flow complet (création compte → ajout opération → validation)

---

## 📊 Estimation Effort (Révisée - Réaliste)

| Tâche                          | Complexité | Temps estimé |
| ------------------------------ | ---------- | ------------ |
| Performance démarrage          | 🟡 Moyenne  | 1h           |
| Safe area                      | 🟢 Simple   | 15min        |
| Système favoris                | 🟡 Moyenne  | 2h           |
| Actions opérations             | 🟢 Simple   | 1h           |
| Types paiement                 | 🟡 Moyenne  | 2h           |
| Retirer radio buttons          | 🟢 Simple   | 10min        |
| Écran settings                 | 🟢 Simple   | 1h           |
| **TOTAL Dev**                  |            | **~7-8h**    |
| **Doc (APP.md, DASHBOARD.md)** |            | **+30min**   |
| **GRAND TOTAL**                |            | **~8h**      |

---

## 🎯 Priorisation STRICTE (Découpage en 2 Phases)

### 🚀 Phase 1 — Quick Wins (~2h) — **À FAIRE EN PRIORITÉ**
1. **Safe area** (15min) — Critique, une ligne de code
2. **Retirer radio buttons** (10min) — UX immédiate
3. **Performance démarrage** (1h) — Retire splash screen + lazy load
4. **Actions opérations** (1h) — Long press → modal simple 3 boutons

**Impact** : App plus rapide, UX nettoyée, actions accessibles  
**Livrable** : Version améliorée utilisable immédiatement

---

### 📦 Phase 2 — Features Avancées (~5h) — **Optionnel / v0.2**
5. **Types paiement** (2h) — Nice to have mais pas bloquant
6. **Système favoris** (2h) — Confort mais pas critique
7. **Écran settings** (1h) — Fondation pour futur

**Impact** : Fonctionnalités avancées, meilleure organisation  
**Livrable** : Version complète avec toutes les demandes

---

## 💡 Recommandation

**Option A — Minimaliste (2h)** :  
Exécuter uniquement Phase 1 → APP déjà beaucoup mieux, reste compatible v0.1a

**Option B — Complet (8h)** :  
Tout faire d'un coup → Risque fatigue, bugs, plus difficile à valider

**Option C — Itératif (Recommandé)** :  
Phase 1 maintenant → validation → Phase 2 après feedback utilisateur réel

---

## ✅ Critères de Succès

- [ ] App démarre en < 1 seconde
- [ ] Aucun élément UI caché par zone système (test iOS + Android)
- [ ] Boutons favoris assignables/réassignables sans bug
- [ ] Menu contextuel opérations fonctionne (édition, validation, suppression)
- [ ] Types paiement affichés et persists dans BDD
- [ ] Page settings accessible et fonctionnelle (toggles de base)
- [ ] Code lint-free (`flutter analyze`)
- [ ] Pas de régression sur features existantes

---

## 📝 Notes pour GPT

- Respecter architecture existante (Drift + Riverpod)
- Utiliser Material 3 design system
- Thème Dotlyn (orange #E36C2D, gris #2C2C2C)
- Typo : Satoshi (titres), Plus Jakarta Sans (UI)
- Toujours inclure SafeArea wrapper
- Ajouter SnackBar feedback après actions
- Gérer states loading/error/success dans providers
- Commentaires en français dans code

---

**Prêt pour exécution par GPT** ✅
