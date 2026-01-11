# Money Tracker — Documentation

**Status** : ✅ v0.1 MVP (released 2025-12-30)  
**Version actuelle** : v0.1.0  
**Dernière update** : 2026-01-11  
**Roadmap** : Voir section TODO pour phases 0.1e-f et v0.2

---

## 🎯 Vision

Suivi de dépenses et revenus rapide et sans friction, inspiré de Financisto mais moderne et épuré.

**Différenciation** : 
- Interface one-hand friendly (boutons zone pouce)
- 2 soldes (Réel + Disponible) pour vision claire
- Usage quotidien < 3 clics pour toute action
- Pas d'usine à gaz : simplicité avant tout

**Public** : Utilisateur standard avec 2-3 comptes bancaires max

---

## 📦 Versions

### v0.1 — MVP (En cours - Découpé en 6 phases)
**Objectif** : Financisto simplifié utilisable quotidiennement

**Architecture** :
- BDD : Drift (SQLite)
- State : Riverpod
- Analytics : Firebase Analytics + Crashlytics
- Ads : Google AdMob (bannière)

#### Phase 0.1a - Fondations (✅ Complétée)
- [x] Setup projet + Drift
- [x] Schemas BDD (accounts, categories, transactions, beneficiaries)
- [x] UI statique avec données fictives
- [x] Navigation basique
- [x] Thème Dotlyn
- [x] Validation manuelle : Interface fonctionnelle (persistence pas encore active)

#### Phase 0.1b - CRUD Comptes (À venir)
- [ ] Providers Riverpod accounts
- [ ] Ajout/modif/suppression comptes
- [ ] Compte actif en state
- [ ] Home affiche solde dynamique

#### Phase 0.1c - CRUD Opérations (Complétée)
- [x] Providers Riverpod transactions
- [x] Bottom sheet ajout opération fonctionnel
- [x] Liste opérations dynamique (filtrée par compte actif)
- [x] Modification/suppression opérations
- [x] Calcul Solde Réel (transactions validées)
- [x] Support virements entre comptes (type transfer + accountToId)
- [x] Calcul Solde Disponible (réel + en attente)
- [x] Virements : permettre de sélectionner explicitement compte origine ET destination
- [x] Virements : valider l'algorithme de calcul des soldes (voir Notes Techniques)

#### Phase 0.1d - Filtres & Polish (✅ Complétée - 2025-12-30)
- [x] Filtres date (Jour, Semaine, Mois, Année)
- [x] Filtre catégorie multi-select
- [x] Bénéficiaires CRUD
- [x] Toggle masquage montants
- [x] Thème clair/sombre
- [x] Modale détail calcul solde
- [x] Menu contextuel opération
- [x] Swipe comptes
- [x] **UX Transactions** : Swipe droite pour valider, swipe gauche pour supprimer
- [x] **UX Transactions** : Indicateur visuel statut (coche/couleur pour validé vs pending)
- [x] **Layout** : Positionner les FABs au-dessus de la bannière pub (pas dessous)
- [x] **Refactoring Code** (2025-12-30) :
  - Phase 1 - Quick Wins : ActionFab, ConfirmDialog, BalanceRow, CurrencyUtils, suppression legacy
  - Phase 2 - Form Components : 4 form fields réutilisables (Amount, Date, Text, Dropdown)
  - Phase 3 - Utils & Extensions : StatRow, EmptyListWidget, string_extensions
  - Résultat : ~150 lignes supprimées, 16 composants réutilisables, 87% duplication éliminée, 0 issues flutter analyze
- [x] **Performance** : Optimisation démarrage (suppression debug queries, checkIntegrity, debugPrint) → 3-4s → <1s estimé

#### Phase 0.1e - Analytics & Pub (� Prochaine session)
- [ ] Firebase Analytics + Crashlytics setup
- [ ] Events tracking basiques (app_open, transaction_created, account_created)
- [ ] AdMob bannière bottom
- [ ] Flag isFirstLaunch pour Analytics

#### Phase 0.1f - UX Lean & Polish (🔴 Prochaine session - PRIORITÉ UI/UX)
**Philosophie** : Ultra-lean MVP, focus expérience essentielle
- [ ] **Polish UI/UX complet** : Home screen propre et agréable
- [ ] **Simplifier forms** : Catégorie/bénéficiaire optionnels/masqués
- [ ] **Alléger navigation** : Retirer accès catégories/bénéficiaires du drawer
- [ ] **SafeArea** : Vérification bannière pub ne chevauche pas navigation
- [ ] **Animations** : Transitions smooth, feedback visuel
- [ ] **Tests device réel** : Installation et validation sur téléphone

**Principe** : Garder infra technique (tables, champs) mais masquer complexité UI. Réintroduire features après validation usage réel.

### v0.1 MVP — Périmètre Final Lean

**Features actives** :
- ✅ Multi-comptes (création, édition, sélection)
- ✅ Double solde (Réel / Disponible)
- ✅ Opérations : montant, date, note, statut (En attente / Validé)
- ✅ Catégories : Seed par défaut en BDD, optionnel/caché en UI
- ✅ Bénéficiaires : Structure BDD, optionnel/caché en UI
- ✅ Filtres date basiques
- ✅ Settings : thème, masquage montants
- ✅ Analytics dès début

**Features retirées temporairement** :
- ❌ Onboarding profils catégories (pas de valeur prouvée)
- ❌ Écran gestion catégories (pas utilisé en MVP)
- ❌ Écran gestion bénéficiaires (pas utilisé en MVP)
- ❌ Filtres catégories avancés (complexité inutile)
- ❌ Types de paiement (nice-to-have, pas core)

**À réintroduire en v0.2+ selon feedback** :
- Catégories personnalisées (si besoin exprimé)
- Bénéficiaires actifs (si usage identifié)
- Types paiement (si demandé)
- Onboarding guidé (si users perdus)

### v0.2 — Features Data-Driven (selon feedback beta)
**Objectif** : Ajouter ce qui manque VRAIMENT aux users

**Candidats à réintroduire** :
- Catégories personnalisées (création/édition/suppression)
- Bénéficiaires actifs (CRUD complet visible)
- Types de paiement (Carte/Virement/Chèque/Espèces)
- Onboarding guidé (si confusion constatée)
- Prélèvements automatiques / Opérations récurrentes
- Solde prévisionnel
- [ ] Firebase Analytics + Crashlytics setup
- [ ] Events tracking basiques (app_open, transaction_created, account_created)
- [ ] AdMob bannière bottom
- [ ] Flag isFirstLaunch pour Analytics

**Phase 0.1f - UX Lean & Polish** :
- [ ] Simplifier transaction_form_sheet : masquer/rendre optionnel catégorie & bénéficiaire
- [ ] Retirer navigation vers écrans catégories/bénéficiaires du drawer
- [ ] Polish UI home : alléger, focus actions essentielles
- [ ] SafeArea vérification (bannière pub)
- [ ] Tests rapides flux utilisateur

**Objectif** : MVP utilisable, lean, sans superflu → Beta test

### 🟡 P2 — Post-Beta (selon feedback)

- [ ] Réintroduire catégories SI besoin exprimé
- [ ] Réintroduire bénéficiaires SI usage identifié
- [ ] Onboarding guidé SI users perdus
- [ ] Types paiement SI demandé
- [ ] Polish splash screen
- [ ] Tests complets
## 📝 TODO

<!-- 
RÈGLES :
- Issues locales = #N (numéro séquentiel, pas GitHub)
- Commit SHA = 7 premiers chars (ex: abc1234)
- Date format = YYYY-MM-DD
- Recently Done = garder max 15 items ou 2 semaines
-->

### 🚧 In Progress (max 3-5 items actifs)

_Aucun item en cours actuellement._

---

### 🔴 P1 — ASAP (Finalisation MVP v0.1)

**Phase 0.1e - Analytics & Pub** :
- [ ] #1: Firebase Analytics + Crashlytics setup
- [ ] #2: Events tracking basiques (app_open, transaction_created, account_created)
- [ ] #3: AdMob bannière bottom
- [ ] #4: Flag isFirstLaunch pour Analytics

**Phase 0.1f - UX Lean & Polish** :
- [ ] #5: Simplifier transaction_form_sheet : masquer/rendre optionnel catégorie & bénéficiaire
- [ ] #6: Retirer navigation vers écrans catégories/bénéficiaires du drawer
- [ ] #7: Polish UI home : alléger, focus actions essentielles
- [ ] #8: SafeArea vérification (bannière pub)
- [ ] #9: Tests rapides flux utilisateur

**Bugs/améliorations USER-NOTES** :
- [ ] #10: Refactoriser dialog ajout opération : bouton switch type au lieu dropdown
- [ ] #11: Revoir layout dialog : note au-dessus montant, date sous montant
- [ ] #12: Améliorer visuel statut opération (case à cocher vs couleur)
- [ ] #13: Vérifier taille/couleur FAB cohérence avec github-notes

**⛔ Issues GitHub DÉSACTIVÉES** (feature verrouillée) :
<!-- NE PAS utiliser GitHub issues (GH#N) tant que feature non activée -->

---

### 🟡 P2 — Post-Beta (selon feedback utilisateur)

**Features à réintroduire SI demandé** :
- [ ] #20: Catégories personnalisées (création/édition/suppression)
- [ ] #21: Bénéficiaires actifs (CRUD complet visible)
- [ ] #22: Types de paiement (Carte/Virement/Chèque/Espèces)
- [ ] #23: Onboarding guidé (si confusion constatée)
- [ ] #24: Prélèvements automatiques / Opérations récurrentes
- [ ] #25: Solde prévisionnel

**Polish UI/UX** :
- [ ] #26: Optimiser splash screen (actuellement 3-4s)
- [ ] #27: Compacter éléments d'interface selon feedback

---

### 🔵 P3 — Versions futures

- [ ] #30: v0.2 : Prélèvements automatiques
- [ ] #31: v0.3 : Import/Export + Sécurité
- [ ] #32: v0.4 : Graphiques + Analytics avancés

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

_Aucun item avec commit SHA pour l'instant (migration workflow en cours)._

**Items historiques (Pre-Workflow)** :
- Phase 0.1a-d complétées (voir CHANGELOG.md [0.1.0])
- Refactoring phases 1-3 (2025-12-30)
- Performance optimization (startup < 1s)

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- CHANGELOG.md : [`../../../apps/money_tracker/CHANGELOG.md`](../../../apps/money_tracker/CHANGELOG.md)

---

##  Notes Techniques

### Fichiers Documentation
- **APP.md** : Roadmap, TODO, notes techniques (fichier principal)
- **PITCH.md** : Vision, identité, public cible (stable)
- **PROMPT_AI.md** : Instructions structurées features futures (mis à jour)
- **PROMPT_USER_ARCHIVE.md** : Historique demandes utilisateur (archive)

### Terminologie Soldes
- **Solde Actuel** = Ce qui est effectivement sur le compte bancaire (uniquement les opérations validées)
- **Solde Disponible** = Solde incluant aussi les opérations "en attente" 
  - Formule : `initialBalance + sum(TOUTES transactions validées ET pending)`
  - **Important** : Solde Disponible ≤ Solde Actuel (car les pending sont généralement des dépenses négatives)

### Algorithme Calcul Solde avec Virements

**Structure de données** :
- Transaction avec `accountId` (compte source), `accountToId` (compte destination pour virements)
- Type détecté : `accountToId != null` → virement, sinon income/expense basé sur signe

**Calcul Solde Actuel d'un compte X** (uniquement validées) :
```
soldeActuel(X) = initialBalance(X) 
               + Σ transactions WHERE accountId=X AND status='validated' (signées: +revenu, -dépense, -virement)
               + Σ transactions WHERE accountToId=X AND status='validated' (abs: +crédit virement entrant)
```

**Calcul Solde Disponible d'un compte X** (validées + pending) :
```
soldeDisponible(X) = initialBalance(X)
                   + Σ transactions WHERE accountId=X (TOUTES: validées + pending)
                   + Σ transactions WHERE accountToId=X (TOUTES: validées + pending, en abs)
```

**Exemple concret** :
- Compte A : initialBalance = 1000€
- Compte B : initialBalance = 500€
- Transaction 1 : accountId=A, amount=+200 (revenu validé)
- Transaction 2 : accountId=A, amount=-50 (dépense validée)
- Transaction 3 : accountId=A, amount=-30 (dépense PENDING)
- **Transaction 4 : accountId=A, accountToId=B, amount=-100 (virement A→B validé)**

**Solde Actuel A** :
```
= 1000 (initial)
  + 200 (transaction 1 validée)
  - 50  (transaction 2 validée)
  - 100 (transaction 4 validée, virement sortant)
= 1050€
```

**Solde Disponible A** :
```  
= 1000 (initial)
  + 200 (transaction 1)
  - 50  (transaction 2)
  - 30  (transaction 3 PENDING !)
  - 100 (transaction 4 virement sortant)
= 1020€
```

**Solde Actuel B** :
```
= 500 (initial)
  + 100 (transaction 4 validée, virement entrant)
= 600€
```

**Solde Disponible B** :
```
= 500 (initial)
  + 100 (transaction 4, virement entrant)
= 600€
```

**✅ Règle** : Solde Disponible ≤ Solde Actuel

**⚠️ Points d'attention actuels** :
1. Le compte source du virement est désormais sélectionnable explicitement dans le formulaire (création/modification)
2. Pour éditer un virement, le compte source peut être modifié
3. Refactor UI à prévoir pour améliorer l’ergonomie si besoin (prochaine version)

**Implémentatio& Bénéficiaires (Stratégie Lean)
**Structure BDD** : Tables complètes, seed par défaut lors init DB
**UI MVP** : Masqué/optionnel, pas de CRUD visible
**Formulaire transaction** :
- Catégorie : Champ optionnel, peut être NULL, dropdown minimal ou caché
- Bénéficiaire : Champ optionnel, peut être NULL, dropdown minimal ou caché

**Raison** : Simplifier UX initiale, valider usage réel avant d'exposer complexité. Structure technique prête pour réintroduction rapide en v0.2 si besoin.
- `accountAvailableBalanceProvider` → Solde Disponible (TOUTES les transactions)

### Statuts Opération
- **En attente** = Saisi mais pas encore débité par banque
- **Validé** = Débité/crédité sur compte bancaire

### Catégories Profils Onboarding
- **Simple** : 6 catégories (Courses, Factures, Loisirs, Autre...)
- **Standard** : 10 catégories (Alimentaire, Transport, Logement, Santé...)
- **Détaillé** : 15 catégories (détail complet courses/restaurants, essence...)

### Données Fictives Phase 0.1a
**Supprimé en phase 0.1b** :
- 1 compte "Compte Courant" (1000€)
- 3 bénéficiaires (Carrefour, Employeur, Pizza Hut)
- 3 transactions (Courses -45€, Salaire +2000€, Resto -20€)

---

## 📐 Structure UI

### Écrans Principaux
- **Home** : Dashboard avec soldes + liste opérations + boutons +/-
- **Bottom Sheet** : Ajout/modif opération (modale rapide)
- **Mes Comptes** : Liste + gestion comptes
- **Catégories** : Onboarding 1ère fois, puis liste
- **Bénéficiaires** : Liste + CRUD
- **Paramètres** : Thème, masquage, locale, export (v0.3+)

### Navigation
- Burger menu (drawer) : Accès pages secondaires
- FAB +/- : Actions principales (zone pouce)
- Swipe horizontal : Changer compte actif

---

**Branche active** : `main`  
**Inspiration** : Financisto (GitHub: dsolonenko/financisto)

---

**Version** : 2.0  
**Dernière mise à jour** : 2026-01-11  
**Maintainer** : @sedounet

