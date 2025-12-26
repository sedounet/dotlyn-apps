# Money Tracker — Documentation de développement

> **Status** : 🟡 En développement (Phase 2+ — Refonte UX transactions & favoris)  
> **Version actuelle** : v0.1e+ (Phase 2+)  
> **Dernière mise à jour** : 2025-12-26

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

#### Phase 0.1d - Filtres & Polish (🟡 En cours — polish UI/UX)
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
- [ ] Polish UI/UX HomeScreen (structure, couleurs, responsive, logo, tagline, favoris, action bar, ad banner) — EN COURS, RESTE À FINALISER
### Notes
- Polish HomeScreen en cours : structure générale OK, il reste à finaliser le responsive, les couleurs, et quelques détails UI/UX.
- Voir PROMPT_AI.md pour la liste complète des tâches polish.

#### Phase 0.1e - Analytics & Pub (À venir)
- [ ] Firebase Analytics + Crashlytics
- [ ] Events tracking
- [ ] AdMob bannière bottom

#### Phase 0.1f - Onboarding (À venir)
- [ ] Détection 1er lancement
- [ ] Choix profil catégories (Simple/Standard/Détaillé)
- [ ] Seed catégories selon profil

**Features MVP complètes** :
- ✅ Multi-comptes (illimité, focus 2-3)
- ✅ Double solde (Réel / Disponible)
- ✅ Opérations : montant, catégorie, bénéficiaire, date, note, statut (En attente / Validé)
- ✅ Catégories prédéfinies (10 catégories Standard)
- ✅ Filtres date et catégorie
- ✅ Settings : thème, masquage montants, locale FR
- ✅ Analytics dès début

### v0.2 — Prélèvements Automatiques
**Objectif** : Solde prévisionnel avec récurrences

**Features** :
- Opérations récurrentes (mensuel, hebdo, annuel)
- Jour de référence par compte
- Solde Disponible amélioré (avec prélèvements futurs)
- Gestion catégories (ajout/modif/suppression)

### v0.3 — Sécurité & Data
**Features** :
- Import CSV bancaire
- Export CSV
- Backup cloud (rewarded video)
- Encryption données
- Auth : PIN / biométrie

### v0.4 — Analytics & Polish
**Features** :
- Graphiques dépenses (catégories, mois)
- Statistiques avancées
- Auto-suggestion bénéficiaires
- UI recherche rapide (1-2 clics)

---

## 📋 TODO

### 🔴 P1 — Phase 2+ (En cours — Refonte UX)

**Contexte** : Suite feedback utilisateur (PROMPT_USER_ARCHIVE.md), amélioration ergonomie et gestion transactions

**Travail effectué** :
- [x] **Migration BDD v3→v4** : Correction bug création tables FavoriteAccounts et AppSettings
- [x] **Boutons favoris** : Logique assignment complète (vide → sélection compte → confirmation → assignation)
- [x] **Navigation favoris** : Clic bouton favori → ouvre écran transactions du compte
- [x] **Liste transactions home** : Affichage transactions compte actif avec menu contextuel
- [x] **Menu contextuel transaction** : Éditer / Supprimer (avec confirmation) / Valider-Dévalider
- [x] **Toggle validation** : Bouton bascule entre "Valider" (vert) et "Dévalider" (orange) selon statut
- [x] **Indicateurs visuels** : Point orange pour "en attente", texte grisé
- [x] **Écran transactions compte** : AccountTransactionsScreen avec soldes + liste complète + FAB ajout
- [x] **Refonte liste comptes** : Suppression radio buttons, ajout icône édition, navigation vers transactions au tap
- [x] **Tri transactions** : Plus récentes en haut (orderBy date DESC)
- [x] **Statut par défaut** : "En attente" au lieu de "Validé" pour nouvelles opérations
- [x] **Validation virements** : Avertissement si moins de 2 comptes disponibles
- [x] **Catégorie optionnelle** : Plus obligatoire lors création/édition transaction

**Reste à faire** :
- [ ] Tests complets flux utilisateur (création, édition, suppression, validation toggle)
- [ ] Polish UI : Optimiser splash screen (actuellement 3-4s)
- [ ] Polish UI : Vérifier SafeArea pour bannière pub (ne doit pas chevaucher navigation)
- [ ] Polish UI : Compacter/réduire certains éléments d'interface (à planifier)

**Commits** :
- `ce8559e` — Fix migration v3→v4 tables creation
- `69d15b3` — Implement favorite buttons assignment logic
- `28b6989` — Add transaction context menu (edit/delete/validate)
- `a9d1d6f` — Remove radio buttons, add edit icon, open transactions screen
- (pending) — Add transaction validation toggle + sort DESC + default pending + optional category

### 🟡 P2 — Phases MVP suivantes

- [ ] Phase 0.1b: Polish HomeScreen (à finaliser)
- [ ] Phase 0.1f : Onboarding

### 🔵 P3 — Versions futures

- [ ] v0.2 : Prélèvements automatiques
- [ ] v0.3 : Import/Export + Sécurité
- [ ] v0.4 : Graphiques + Analytics

---

## 🐛 Bugs Connus

(Aucun pour l'instant)

---

## 📝 Notes Techniques

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

**Implémentation actuelle** :
- `transactionsProvider(accountId)` → transactions WHERE accountId = X
- `incomingTransfersProvider(accountId)` → transactions WHERE accountToId = X  
- `accountBalanceProvider` → Solde Actuel (status='validated' uniquement)
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

**Branche active** : `feat/money-tracker-init`  
**Inspiration** : Financisto (GitHub: dsolonenko/financisto)
