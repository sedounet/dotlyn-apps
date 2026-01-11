# Template Nouvelle App — README

> **Objectif** : Template complet pour créer une nouvelle app dans le monorepo Dotlyn Apps  
> **Usage** : Copier ce dossier, renommer fichiers, remplir sections

---

## 📁 Fichiers Inclus

1. **APP.md.template** → Renommer en `APP.md`
   - Documentation de développement
   - Workflow v2.0 (In Progress, P1/P2/P3, Recently Done)
   - Issues locales #N avec SHA commits

2. **CHANGELOG.md.template** → Renommer en `CHANGELOG.md`
   - Format Keep a Changelog
   - Structure [Unreleased] + versions numérotées
   - Store-ready

3. **PITCH.md.template** → Renommer en `PITCH.md`
   - Vision stable de l'app
   - Identité visuelle, public cible, différenciation

4. **USER-NOTES.md.template** → Renommer en `USER-NOTES.md`
   - Notes personnelles utilisateur (lecture seule Copilot)
   - Bugs, idées, observations

---

## 🚀 Workflow Création Nouvelle App

### Étape 1 : Copier Template

```powershell
# Depuis racine monorepo
Copy-Item "_docs/templates/new-app" "_docs/apps/[nom_app]" -Recurse

# Renommer templates
cd _docs/apps/[nom_app]
Rename-Item "APP.md.template" "APP.md"
Rename-Item "CHANGELOG.md.template" "CHANGELOG.md"
Rename-Item "PITCH.md.template" "PITCH.md"
Rename-Item "USER-NOTES.md.template" "USER-NOTES.md"
```

### Étape 2 : Remplir Templates

- **APP.md** : Remplacer `[APP_NAME]`, `YYYY-MM-DD`, remplir Vision, features P1/P2/P3
- **CHANGELOG.md** : Remplacer `[APP_NAME]`, `YYYY-MM-DD`, décrire features MVP
- **PITCH.md** : Remplir concept, persona, différenciation, métriques
- **USER-NOTES.md** : Remplacer `[APP_NAME]`, prêt à utiliser

### Étape 3 : Créer Structure Code

```powershell
# Créer app Flutter
cd apps/
flutter create [nom_app] --org dev.dotlyn

# Structure standard
cd [nom_app]/lib
mkdir data models providers screens services widgets
mkdir data/database
mkdir l10n
```

### Étape 4 : Configurer pubspec.yaml

Ajouter dépendances standard :
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0
  dotlyn_ui:
    path: ../../packages/dotlyn_ui
  dotlyn_core:
    path: ../../packages/dotlyn_core

dev_dependencies:
  drift_dev: ^2.14.0
  build_runner: ^2.4.0
```

### Étape 5 : Bootstrap

```powershell
# Depuis racine monorepo
melos bootstrap

# Depuis app
cd apps/[nom_app]
flutter pub get
```

### Étape 6 : Commit Initial

```powershell
git add .
git commit -m "[nom_app] init: create new app structure

- Add APP.md, CHANGELOG.md, PITCH.md, USER-NOTES.md
- Add Flutter project structure
- Configure dotlyn_ui + dotlyn_core dependencies"
```

---

## 📋 Checklist Création App

- [ ] Templates copiés et renommés
- [ ] APP.md rempli (Vision, P1 features minimum)
- [ ] CHANGELOG.md initialisé (version 0.1.0 skeleton)
- [ ] PITCH.md rempli (concept, persona, différenciation)
- [ ] USER-NOTES.md prêt
- [ ] Structure code Flutter créée
- [ ] pubspec.yaml configuré (dotlyn_ui, dotlyn_core)
- [ ] melos bootstrap exécuté
- [ ] flutter analyze passe (0 errors)
- [ ] Commit initial fait
- [ ] Label GitHub créé (si utilise issues)
- [ ] DASHBOARD.md mis à jour (ajouter nouvelle app)

---

## 📚 Références

- **Workflow v2.0** : `_docs/workflow-proposals/`
- **APP Standards** : `_docs/APP_STANDARDS.md` (i18n, analytics, ads à intégrer v0.2+)
- **Styleguide** : `_docs/dotlyn/STYLEGUIDE.md`
- **Branching** : `_docs/BRANCHING.md`
- **Pre-Commit Checklist** : `_docs/PRE_COMMIT_CHECKLIST.md`
- **Copilot Instructions** : `.github/copilot-instructions.md`

---

**Version** : 1.0  
**Dernière mise à jour** : 2026-01-11  
**Maintainer** : @sedounet
