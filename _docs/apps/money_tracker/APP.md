# Money Tracker — Documentation de développement

> **Status** : 🚧 En développement (Phase 0.1a)  
> **Version actuelle** : -  
> **Dernière mise à jour** : 2025-12-13

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

#### Phase 0.1a - Fondations (En cours)
- [x] Setup projet + Drift
- [x] Schemas BDD (accounts, categories, transactions, beneficiaries)
- [x] UI statique avec données fictives
- [x] Navigation basique
- [x] Thème Dotlyn
- [ ] Validation manuelle

#### Phase 0.1b - CRUD Comptes (À venir)
- [ ] Providers Riverpod accounts
- [ ] Ajout/modif/suppression comptes
- [ ] Compte actif en state
- [ ] Home affiche solde dynamique

#### Phase 0.1c - CRUD Opérations (À venir)
- [ ] Providers Riverpod transactions
- [ ] Bottom sheet ajout opération fonctionnel
- [ ] Liste opérations scroll infini
- [ ] Modification/suppression opérations
- [ ] Calcul Solde Réel (transactions validées)
- [ ] Calcul Solde Disponible (réel + en attente)

#### Phase 0.1d - Filtres & Polish (À venir)
- [ ] Filtres date (Jour, Semaine, Mois, Année)
- [ ] Filtre catégorie multi-select
- [ ] Bénéficiaires CRUD
- [ ] Toggle masquage montants
- [ ] Thème clair/sombre
- [ ] Modale détail calcul solde
- [ ] Menu contextuel opération
- [ ] Swipe comptes

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

### 🔴 P1 — Phase 0.1a (En cours)

- [ ] Valider phase 0.1a manuellement
- [ ] Commit phase 0.1a
- [ ] Générer PROMPT_AI phase 0.1b

### 🟡 P2 — Phases MVP suivantes

- [ ] Phase 0.1b : CRUD Comptes
- [ ] Phase 0.1c : CRUD Opérations
- [ ] Phase 0.1d : Filtres & Polish
- [ ] Phase 0.1e : Analytics & Pub
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
- **Solde Réel** = Ce qui est sur le compte bancaire à l'instant T
- **Solde Disponible** = Réel - opérations "En attente"

### Statuts Opération
- **En attente** = Saisi mais pas encore débité par banque
- **Validé** = Débité/crédité sur compte bancaire

### Catégories Profils Onboarding
- **Simple** : 6 catégories (Courses, Factures, Loisirs, Autre...)
- **Standard** : 10 catégories (Alimentaire, Transport, Logement, Santé...)
- **Détaillé** : 15 catégories (détail complet courses/restaurants, essence...)

### Données Fictives Phase 0.1a
**À SUPPRIMER en phase 0.1b** :
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
