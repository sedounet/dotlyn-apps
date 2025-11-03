# Dotlyn Apps — Monorepo

> Monorepo Flutter pour toutes les mini-apps Dotlyn

---

## 🎯 Structure

```
dotlyn-apps/
├── _docs/              ← Documentation (apps + brand)
├── apps/               ← Mini-apps Flutter
├── packages/           ← Code partagé (UI, core)
├── .github/            ← Config CI/CD, Copilot
└── melos.yaml          ← Config monorepo
```

---

## 📱 Apps

### ⏱️ Timer
**Status** : 🚧 MVP en cours  
**Doc** : [_docs/apps/timer/](./_docs/apps/timer/)

---

## 🚀 Quick Start

### Prérequis
- Flutter SDK 3.x
- Dart 3.x
- Melos : `dart pub global activate melos`

### Installation

```bash
# Cloner le repo
git clone https://github.com/sedounet/dotlyn-apps.git
cd dotlyn-apps

# Bootstrap melos
melos bootstrap

# Lancer une app
cd apps/timer
flutter run
```

---

## 📚 Documentation

- [Brand Dotlyn](./_docs/dotlyn/) — Styleguide, polices, assets
- [Dashboard](./_docs/DASHBOARD.md) — Vue d'ensemble toutes apps

---

## 🛠️ Développement

### Ajouter une nouvelle app

1. Créer dossier `apps/[nom]/`
2. Créer docs `_docs/apps/[nom]/APP.md` et `PITCH.md`
3. Update `DASHBOARD.md`
4. Créer label GitHub `[nom]`

### Packages partagés

- **dotlyn_ui** : Composants UI, thème, assets (sons, fonts)
- **dotlyn_core** : Services, models, utils communs

---

**Marque** : Dotlyn  
**Licence** : Propriétaire  
**Maintainer** : @sedounet
