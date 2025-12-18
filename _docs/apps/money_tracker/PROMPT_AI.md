# NOTE 2025-12-18 : Polish HomeScreen en cours, prompt ci-dessous reste la référence pour la suite du polish. Ne pas supprimer tant que tout n'est pas validé.
# Money Tracker — Instructions IA (Phase 0.1d - Polish UI/UX)

> **PHASE** : 0.1d - Polish UI/UX avant release MVP  
> **PRÉREQUIS** : Phase 0.1c complétée (CRUD Transactions fonctionnel)  
> **STATUT** : EN ATTENTE D'EXÉCUTION

---

## 🎯 OBJECTIF

Refondre l'interface utilisateur du HomeScreen pour une expérience optimale avant d'aller plus loin. Réorganiser les éléments du bas vers le haut, améliorer l'ergonomie des boutons d'action, ajouter un système de masquage des montants et préparer les favoris de comptes.

**Livrable** : HomeScreen refondu + modale de transaction centrée + amélioration des éléments de liste des opérations.

---

## 📁 CONTEXTE PROJET

**Localisation** : `apps/money_tracker/`  
**BDD** : Drift (SQLite) avec tables Accounts, Categories, Transactions, Beneficiaries  
**State** : Riverpod 2.x  
**UI** : Material 3, respecter STYLEGUIDE Dotlyn (orange #E36C2D, gris anthracite #2C2C2C, Satoshi Heavy Italic pour titres, Manrope Regular pour UI)  
**Architecture actuelle** :
- Providers : accounts, transactions, categories, beneficiaries
- Solde Actuel (validé) et Disponible (validé + pending) calculés dynamiquement
- TransactionFormSheet : modale bottom sheet pour CRUD transactions

**État actuel HomeScreen** :
- AppBar avec titre + icône visibilité
- Bandeau compte actif + solde
- Liste des transactions
- 3 FABs en bas à droite (-, swap, +)
- Bannière pub placeholder en bas

---

## 📋 TÂCHES

### 1. Refonte Layout HomeScreen (du bas vers le haut)

**Fichier** : `apps/money_tracker/lib/screens/home/home_screen.dart`

**Structure cible (du bas vers le haut de l'écran)** :

1. **Bannière pub** (inchangée, tout en bas)
2. **Boutons d'action** (agrandis, au-dessus de la bannière)
   - Créer un widget réutilisable `ActionButtonsBar` pour gérer mode main droite/main gauche (setting global à prévoir plus tard)
   - 3 boutons : Dépense (-), Virement (swap), Revenu (+)
   - Taille agrandie (56-60px) pour faciliter l'usage
   - Espacement confortable entre les boutons
   - **IMPORTANT** : Les positionner AU-DESSUS de la bannière pub (pas en FloatingActionButton)

3. **Bandeau solde compte actif**
   - Format : `Disponible = XXXX € | Actuel = YYYY € [👁️]`
   - Solde Disponible : vert si positif, rouge si négatif
   - Solde Actuel : couleur neutre (gris selon thème Dotlyn)
   - Bouton œil à droite pour masquer/afficher les montants
   - **Fonctionnement masquage** :
     - Par défaut : montants cachés (afficher "***" ou "----")
     - Clic sur œil : affiche les montants (reste visible tant que l'app est ouverte)
     - À la prochaine ouverture de l'app : montants cachés à nouveau
     - Prévoir un setting global pour changer ce comportement (pas dans cette phase)
   - Style : bandeau légèrement ombré, fond blanc cassé (#F8F8F8)

4. **Phrase tagline** (au-dessus du bandeau solde)
   - Texte : "Suivi quotidien de vos comptes bancaires" (centré)
   - Style : Manrope Regular, taille 14-16px, couleur gris anthracite (#2C2C2C)

5. **Grille de 3 comptes favoris** (au-dessus de la tagline)
   - 3 boutons de comptes favoris (paramétrables dans settings plus tard)
   - Pour le moment : afficher uniquement le nom du compte
   - Icône ❤️ (cœur) à côté du nom pour identifier les favoris
   - Clic sur un compte : ouvre le compte en question (affiche son solde et ses opérations)
   - Layout : grille 3 colonnes ou 3 boutons horizontaux selon design
   - **Note** : Choisir les comptes favoris parmi les comptes existants dans la BDD (implémentation du choix dans settings à prévoir plus tard, pour le moment hardcoder les 3 premiers comptes)

6. **Logo de l'app** (tout en haut, centré)
   - Logo DotLyn centré
   - Taille adaptée (pas trop grand, ~80-100px)

7. **Liste des opérations** (SUPPRIMÉE pour le moment)
   - Ne plus afficher la liste des opérations sur le HomeScreen
   - La liste sera accessible uniquement lors du clic sur un compte (dans AccountScreen ou un écran dédié)

### 2. Amélioration des éléments de liste des opérations

**Fichier** : Créer un widget `TransactionListItem` dans `apps/money_tracker/lib/widgets/transaction_list_item.dart`

**Format cible pour chaque opération** :
- **Ligne 1** : Note ou désignation de l'opération (ex: "Achat cadeau Noël")
  - Si pas de note : afficher "Sans note" ou catégorie par défaut
- **Ligne 2** : Date au format "lun 22 déc 20:23" + montant (vert si positif, rouge si négatif) aligné à droite
- **Ligne 3** : Solde du compte après cette opération (calculé automatiquement)
  - Format : "Solde après : XXXX €"
  - Couleur neutre (gris)

**Interactions** :
- Clic sur une opération : ouvre la modale de modification (TransactionFormSheet en mode édition)
- Swipe to delete : conserver le comportement actuel (Dismissible)

### 3. Conversion TransactionFormSheet en Dialog centré

**Fichier** : `apps/money_tracker/lib/widgets/forms/transaction_form_sheet.dart`

**Changements** :
- **NE PLUS** utiliser `showModalBottomSheet`
- **UTILISER** `showDialog` pour afficher une modale centrée sur l'écran
- Fond légèrement ombré derrière (barrierColor avec opacité)
- Modale centrée avec une largeur max (300-400px selon écran)
- Bordures arrondies, ombre portée pour effet de profondeur

**Champs à afficher** (dans l'ordre) :
1. Date (DatePicker)
2. Montant (TextField numérique)
3. Type opération : Revenu / Dépense / Virement (radio buttons ou segmented button)
4. Catégorie (DropdownButtonFormField, filtré par type, optionnel si virement)
5. Bénéficiaire (DropdownButtonFormField, optionnel)
6. **Compte d'origine** (pour virements : DropdownButtonFormField de tous les comptes, par défaut = compte actif)
7. **Compte de destination** (pour virements : DropdownButtonFormField de tous les comptes, requis si type = virement)
8. Note (TextField, optionnel)
9. Statut : En attente / Validé (radio buttons ou toggle)

**Précisions virements** :
- Lors d'un virement, le compte par défaut est celui d'où part le virement (compte actif)
- Il faut pouvoir choisir le compte de destination dans une liste déroulante de tous les comptes existants
- Il faut pouvoir choisir le compte d'origine également (par défaut le compte actif bien sûr)

**Validation** :
- Bouton "Enregistrer" → appelle `transactionsRepository.addTransaction(...)` ou `updateTransaction(...)`
- Bouton "Annuler" → ferme la modale sans sauvegarder

### 4. Unification des widgets de formulaire

**Objectif** : L'ensemble des opérations (-, +, virement) seront faites sur le même widget (classe TransactionFormSheet) de manière à éviter la duplication de code.

**Implémentation** :
- Conserver TransactionFormSheet comme widget unique
- Supprimer `add_transaction_sheet.dart` si encore présent (déjà fait normalement)
- Le paramètre `defaultType` permet de pré-sélectionner le type d'opération (income, expense, transfer)
- Les champs compte d'origine/destination ne s'affichent QUE si type = transfer

### 5. Widget ActionButtonsBar réutilisable

**Fichier** : Créer `apps/money_tracker/lib/widgets/action_buttons_bar.dart`

**Fonctionnalités** :
- Widget qui affiche les 3 boutons d'action (-, swap, +)
- Accepte un paramètre `alignment` pour gérer mode main droite/main gauche
  - `alignment: MainAxisAlignment.end` (par défaut, main droite)
  - `alignment: MainAxisAlignment.start` (main gauche)
- Possibilité de passer ce paramètre via un setting global (à implémenter plus tard)
- Pour le moment : hardcoder `MainAxisAlignment.end`

**Design** :
- Boutons larges et visibles (56-60px de hauteur)
- Icônes claires (remove, swap_horiz, add)
- Couleur : respecter thème Dotlyn (orange #E36C2D pour primaire)
- Espacement confortable entre les boutons (16-20px)

---

## ✅ CRITÈRES DE SUCCÈS

- [ ] HomeScreen refondu avec nouvelle structure (bas → haut)
- [ ] Boutons d'action agrandis et positionnés AU-DESSUS de la bannière pub
- [ ] Bandeau solde avec masquage fonctionnel (œil cliquable)
- [ ] Montants cachés par défaut au démarrage de l'app
- [ ] Phrase tagline affichée et centrée
- [ ] Grille de 3 comptes favoris fonctionnelle (clic ouvre le compte)
- [ ] Logo DotLyn centré en haut
- [ ] Liste des opérations supprimée du HomeScreen
- [ ] TransactionListItem avec format amélioré (note, date, montant, solde après)
- [ ] TransactionFormSheet converti en Dialog centré (pas bottom sheet)
- [ ] Champs compte d'origine/destination pour virements fonctionnels
- [ ] ActionButtonsBar widget réutilisable créé
- [ ] Code lint-free (`flutter analyze`)
- [ ] Respect du STYLEGUIDE Dotlyn (couleurs, typo, icônes Remix Icon)

---

## ⚠️ POINTS D'ATTENTION

- **Fluidité et rapidité d'utilisation** : Privilégier une UI réactive et légère
- **Base de données locale rapide** : Drift (SQLite) déjà en place, optimiser les requêtes si besoin
- **Scalabilité** : Prévoir que le nombre de comptes/transactions peut augmenter
- **Mot de passe et encryption** : À prévoir rapidement dans une prochaine phase (pas dans 0.1d)
- **Respect du styleguide** : TOUJOURS utiliser les couleurs Dotlyn, Remix Icon uniquement, polices Satoshi/Manrope
- **Éviter la duplication de code** : Unifier les widgets de formulaire

---

## 📐 STRUCTURE FICHIERS CIBLES

```
apps/money_tracker/lib/
├── screens/
│   └── home/
│       └── home_screen.dart (refonte complète)
├── widgets/
│   ├── action_buttons_bar.dart (nouveau)
│   ├── transaction_list_item.dart (nouveau)
│   └── forms/
│       └── transaction_form_sheet.dart (convertir en Dialog)
└── providers/
    └── ui_state_provider.dart (nouveau, pour gérer état masquage montants)
```

---

## 🔄 WORKFLOW D'EXÉCUTION

1. Créer `ui_state_provider.dart` pour gérer l'état de masquage des montants
2. Créer `action_buttons_bar.dart` widget réutilisable
3. Créer `transaction_list_item.dart` widget pour affichage opération
4. Convertir `TransactionFormSheet` en Dialog centré (showDialog au lieu de showModalBottomSheet)
5. Refondre `HomeScreen` avec nouvelle structure (bas → haut)
6. Tester manuellement toutes les fonctionnalités
7. Exécuter `flutter analyze` pour vérifier lint
8. Valider le respect du STYLEGUIDE Dotlyn
9. Mettre à jour `_docs/apps/money_tracker/APP.md` section TODO (déplacer Phase 0.1d en "Complétée")

---

**Version** : 1.0  
**Date** : 2025-12-18  
**Préparé pour** : GPT-4o

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

