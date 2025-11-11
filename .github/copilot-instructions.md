# Instructions GitHub Copilot — Dotlyn Apps Monorepo

## 🎯 Contexte Projet

**Type** : Monorepo Flutter pour mini-apps Dotlyn  
**Structure** : Melos-based monorepo  
**Convention** : Apps indépendantes + packages partagés

---

## 📁 Structure Monorepo

```
dotlyn-apps/
├── _docs/              ← Documentation (apps + brand)
│   ├── apps/           ← Doc par app (APP.md + PITCH.md)
│   ├── dotlyn/         ← Brand (styleguide, assets)
│   └── DASHBOARD.md    ← Vue d'ensemble globale
├── apps/               ← Mini-apps Flutter indépendantes
├── packages/           ← Code partagé (dotlyn_ui, dotlyn_core)
└── .github/            ← Config CI/CD, Copilot
```

---

## 🎯 Règles de Travail

### 1. Gestion Multi-Apps

**Quand l'utilisateur dit** : "On travaille sur Timer"  
**Tu dois** :
- Considérer que TOUTES les actions concernent l'app Timer
- Code → `apps/timer/`
- Doc → `_docs/apps/timer/APP.md`
- Issues → Label `timer` sur GitHub

**Quand l'utilisateur dit** : "Update la TODO"  
**Tu dois** :
- Éditer `_docs/apps/[app-active]/APP.md` section TODO
- NE PAS créer de fichier TODO.md séparé
- NE PAS confondre avec une autre app

---

### 2. Système de Documentation

**Chaque app a EXACTEMENT 3 fichiers** :

#### APP.md (fichier de travail)
- Versions (v0.1 MVP, v0.2, v0.3+)
- TODO avec priorités :
  - 🔴 P1 = ASAP (bugs bloquants + débloqueurs techniques)
  - 🟡 P2 = Prochaine version
  - 🔵 P3 = Plus tard
- Liens vers issues GitHub (`→ #XX`)
- Notes en vrac

#### PITCH.md (vision stable)
- Concept
- Identité visuelle (référence styleguide)
- Public cible
- Différenciation
- Métriques succès

#### PROMPTS.md (instructions pour LLMs)
- Template structuré pour formuler des prompts à GPT-4 ou autres LLMs
- Sections : Objectif, Instructions détaillées, Contraintes design, Dépendances, Critères de validation, Points d'attention, Fichiers concernés, Références
- Usage : remplir les sections pertinentes avant de soumettre à un LLM pour effectuer des opérations en série
- Permet de structurer les demandes complexes et de maintenir le contexte projet

**NE JAMAIS** :
- Créer de fichier TODO.md séparé
- Créer de fichier MASTER.md
- Multiplier les fichiers de doc au-delà de ces 3 fichiers

---

### 3. Workflow Git & Issues

**Issues GitHub** :
- Une issue = Un bug OU Une feature
- Labels obligatoires : `[nom-app]` + `bug` ou `feature`
- Priorité dans le titre si P1 : `[P1] Description`

**Commits** :
- Format : `[app] type: description`
- Exemples :
  - `[timer] feat: add background service`
  - `[timer] fix: crash on Android 12+`
  - `[docs] update: timer APP.md TODO section`

**Branches** :
- `main` = stable
- `feat/[app]-[feature]` = nouvelle feature
- `fix/[app]-[bug]` = correction bug

---

### 4. Conventions Code Flutter

**Packages partagés** :
- `dotlyn_ui` : Composants UI, thème, assets (sons, fonts)
- `dotlyn_core` : Services, models, utils

**Import packages** :
```dart
// Toujours préférer les packages partagés
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
```

**Structure app** :
```
apps/[nom]/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── services/
│   ├── models/
│   └── widgets/
├── pubspec.yaml
└── README.md (court, lien vers _docs/)
```

---

### 5. Assets Partagés

**Sons, fonts, animations** :
- Stockés dans `packages/dotlyn_ui/lib/assets/`
- Accessibles via `DotlynAssets.sound('bell.mp3')`

**Assets spécifiques app** :
- Icônes, screenshots → `_docs/apps/[nom]/assets/`

**Brand assets** :
- Logos, templates → `_docs/dotlyn/brand-assets/`

---

### 6. Styleguide Dotlyn

**TOUJOURS respecter** `_docs/dotlyn/STYLEGUIDE.md` :
- Couleurs : Orange terre cuite (#E36C2D), Gris anthracite (#2C2C2C)
- Typo : Satoshi (titres), Manrope (UI)
- Icônes : Remix Icon uniquement
- Zone sécurité icônes : 640px diamètre

---

### 7. Dashboard Global

**Quand mettre à jour** `_docs/DASHBOARD.md` :
- Changement de version d'une app
- Ajout/suppression d'app
- Changement significatif de status

**Ne PAS** le mettre à jour pour :
- Petites modifs dans APP.md
- Commits quotidiens

---

## 🚫 À NE JAMAIS FAIRE

❌ Créer un fichier TODO.md séparé (utiliser APP.md section TODO)  
❌ Dupliquer la doc entre fichiers  
❌ Utiliser d'autres polices que Satoshi/Manrope  
❌ Utiliser d'autres icônes que Remix Icon  
❌ Créer des packages non partagés (code spécifique → dans app/)  
❌ Pusher sur `main` directement (toujours passer par PR)

---

## ✅ Checklist Avant Commit

- [ ] Code lint-free (`flutter analyze`)
- [ ] Tests passent (si existants)
- [ ] Doc à jour (APP.md si changement de features/bugs)
- [ ] Commit message respecte format `[app] type: description`
- [ ] Issue liée si applicable (`closes #XX`)

---

## 🎯 Exemples Concrets

### Exemple 1 : Ajout feature Timer
```
User: "Ajoute les notifications enrichies au timer"

Actions Copilot:
1. Créer branche: feat/timer-rich-notifications
2. Coder dans apps/timer/lib/services/notification_service.dart
3. Update _docs/apps/timer/APP.md:
   - Déplacer "Notifications enrichies" de P2 vers "En cours"
4. Commit: "[timer] feat: add rich notifications with actions"
5. Créer issue #XX si pas existante
6. Update APP.md avec lien: "→ #XX"
```

### Exemple 2 : Bug critique
```
User: "Le timer crash sur Android 12+"

Actions Copilot:
1. Créer issue GitHub: "[P1] Timer crash on Android 12+"
2. Label: timer, bug, P1
3. Update _docs/apps/timer/APP.md section "🔴 P1":
   - [ ] Bug: Timer crash Android 12+ → #XX
4. Créer branche: fix/timer-android12-crash
5. Investiguer + fix
6. Commit: "[timer] fix: resolve crash on Android 12+ (closes #XX)"
```

### Exemple 3 : Nouvelle app
```
User: "Créer une nouvelle app Notes"

Actions Copilot:
1. Créer apps/notes/
2. Créer _docs/apps/notes/APP.md (template complet)
3. Créer _docs/apps/notes/PITCH.md
4. Créer label GitHub "notes"
5. Update _docs/DASHBOARD.md (ajouter Notes)
6. Commit: "[notes] init: create new notes app structure"
```

---

**Version** : 1.0  
**Dernière update** : 2025-11-03  
**Maintainer** : @sedounet
