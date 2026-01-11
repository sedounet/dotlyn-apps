# Workflow Complet — Process de bout en bout

> **Statut** : BROUILLON — Process complet du nouveau fonctionnement  
> **Date** : 2026-01-11  
> **Version** : 1.0

---

## 🎯 Vue d'ensemble

**Objectif** : Process cohérent de la prise en charge d'une tâche jusqu'à la release store, avec documentation tracée et exploitable.

**Principes** :
- Issues locales par défaut (#N), GitHub optionnel (feature verrouillée)
- APP.md = vue actionable courte (<200 lignes)
- CHANGELOG.md = archive permanente + format store
- Commit SHA systématique pour traçabilité
- Versioning sémantique strict

---

## 📋 Process détaillé

### ÉTAPE 1 : Début de session de travail

**1.1 Consulter APP.md**

Ouvrir `_docs/apps/[app]/APP.md` et identifier priorités :

```markdown
### 🔴 P1 — ASAP
- [ ] #1: Fix token visibility (from USER-NOTES 2026-01-11)
- [ ] #2: Investigate Sync failure (intermittent)

### 🟡 P2 — Next release
- [ ] #10: Export settings backup
- [ ] #11: Three-way merge dialog
```

**1.2 Choisir une tâche**

Critères :
- P1 en premier (bugs bloquants)
- Si plusieurs P1, prendre le plus simple pour démarrer
- Vérifier dépendances (certaines tâches bloquent d'autres)

**Action** : Choisir #1 (Fix token visibility)

---

### ÉTAPE 2 : Démarrer le travail

**2.1 Créer branche**

```powershell
git checkout main
git pull origin main
git checkout -b fix/github_notes-token-visibility
```

**Format branche** : `type/app-short-description`
- Types : `feat`, `fix`, `chore`, `docs`, `refactor`, `test`

**2.2 Déplacer issue vers In Progress dans APP.md**

```markdown
### 🚧 In Progress

- [ ] #1: Fix token visibility — branch: fix/github_notes-token-visibility, started: 2026-01-11, ETA: 2026-01-11

### 🔴 P1 — ASAP

~~- [ ] #1: Fix token visibility~~  ← Retirer de P1
- [ ] #2: Investigate Sync failure
```

**Commit documentation** :
```powershell
git add _docs/apps/github_notes/APP.md
git commit -m "[github_notes] docs: move issue #1 to In Progress"
git push origin fix/github_notes-token-visibility
```

---

### ÉTAPE 3 : Développement

**3.1 Coder + commits**

Faire le travail technique, commits réguliers :

```powershell
# Fix 1 : Masquer token par défaut
git add lib/screens/settings_screen.dart
git commit -m "[github_notes] fix: hide token by default in settings"

# Fix 2 : Auto-hide lors sortie settings
git add lib/screens/settings_screen.dart
git commit -m "[github_notes] fix: auto-hide token when leaving settings"
```

**3.2 Ajouts organiques (si applicable)**

Si questions/idées pendant dev → Parking Lot temporaire dans APP.md :

```markdown
### 🗨️ Parking Lot

- [ ] Question: Should we add a "Copy token" button? (asked 2026-01-11)
- [ ] Idea: Use biometric auth to show token (future security layer)
```

**Pas de commit** pour Parking Lot pendant dev (trier en fin de session)

---

### ÉTAPE 4 : Tests et validation

**4.1 Tests locaux**

```powershell
cd apps/github_notes
flutter analyze  # Doit passer (0 errors)
flutter test     # Si tests existent, doivent passer
```

**4.2 Test device physique**

```powershell
flutter run --release -d <device-id>
```

Vérifier :
- Token caché par défaut ✓
- Auto-hide fonctionne ✓
- Pas de régression autres features ✓

---

### ÉTAPE 5 : Documentation pré-commit

**5.1 Cocher issue dans APP.md**

```markdown
### 🚧 In Progress

~~- [ ] #1: Fix token visibility~~  ← Retirer de In Progress

### ✅ Recently Done

- [x] #1: Fix token visibility — Done 2026-01-11 (commit abc1234)
```

**Note** : Récupérer SHA court (7 chars) :
```powershell
git log -1 --pretty=format:"%h"
# Output: abc1234
```

**5.2 Ajouter à CHANGELOG.md [Unreleased]**

Ouvrir `apps/github_notes/CHANGELOG.md` (ou `_docs/apps/github_notes/CHANGELOG.md` si centralisé) :

```markdown
## [Unreleased]

### Fixed 🐛
- **Token visibility security**
  - Technical: Token hidden by default, auto-hide when leaving settings
  - User benefit: Prevents accidental token exposure
  - (commit abc1234, closes #1)
```

**Pattern strict** :
- Headline user-facing (80 chars max, store-ready)
- Technical details (indent)
- User benefit explicite
- Commit SHA + issue # référence

---

### ÉTAPE 6 : Commit final et merge

**6.1 Commit documentation**

```powershell
git add _docs/apps/github_notes/APP.md
git add apps/github_notes/CHANGELOG.md
git commit -m "[github_notes] docs: mark issue #1 done; update CHANGELOG"
```

**6.2 Merge dans main**

```powershell
git checkout main
git pull origin main
git merge --no-ff fix/github_notes-token-visibility
git push origin main
```

**6.3 Supprimer branche**

```powershell
git branch -d fix/github_notes-token-visibility
git push origin --delete fix/github_notes-token-visibility
```

---

### ÉTAPE 7 : Fin de session

**7.1 Trier Parking Lot**

Si items ajoutés pendant session, trier :

```markdown
### 🗨️ Parking Lot

- [ ] Question: Should we add "Copy token" button?
  → Décision : Non, risque sécurité. Supprimer.

- [ ] Idea: Biometric auth to show token
  → Promouvoir vers P3 :

### 🔵 P3 — Backlog
- [ ] #25: Biometric auth to reveal token (from Parking Lot 2026-01-11)
```

**Commit tri Parking Lot** :
```powershell
git add _docs/apps/github_notes/APP.md
git commit -m "[github_notes] docs: triage Parking Lot items"
git push origin main
```

**7.2 Vérifier Recently Done**

Si > 15 items dans Recently Done :

1. Copier 5-10 plus anciens vers CHANGELOG [Unreleased]
2. Supprimer de Recently Done dans APP.md
3. Commit : `[github_notes] docs: archive old Done items to CHANGELOG`

---

### ÉTAPE 8 : Répéter pour autres tâches

Recommencer Étapes 1-7 pour chaque issue P1/P2 jusqu'à version complète.

---

## 📦 Process Release

### ÉTAPE R1 : Préparer release

**R1.1 Décider version**

Consulter CHANGELOG [Unreleased] :
- Si `Added` non vide → MINOR bump (ex: 0.1.0 → 0.2.0)
- Si seulement `Fixed` → PATCH bump (ex: 0.1.0 → 0.1.1)
- Si breaking changes → MAJOR bump (rare en v0.x)

**Référence** : `VERSIONING_RULES.md`

**R1.2 Nettoyer APP.md**

Vérifier :
- In Progress vide (toutes tâches terminées)
- Parking Lot trié
- Recently Done < 15 items (si plus, archiver vers CHANGELOG)

**R1.3 Finaliser CHANGELOG**

Renommer `[Unreleased]` → `[0.2.0] - 2026-01-15` :

```markdown
## [Unreleased]

← Renommer en :

## [0.2.0] - 2026-01-15

### Added 🆕
- **Offline editing support**
  - Technical: Create/edit files without network
  - User benefit: Work anywhere, sync when online
  - (commit 4f2a8b3, closes #12)

### Fixed 🐛
- **Token visibility security**
  - Technical: Hidden by default, auto-hide on exit
  - User benefit: Better security
  - (commit abc1234, closes #1)
```

Créer nouvelle section `[Unreleased]` vide en haut.

**Commit** :
```powershell
git add apps/github_notes/CHANGELOG.md
git commit -m "[github_notes] release: prepare v0.2.0 changelog"
git push origin main
```

---

### ÉTAPE R2 : Extraire release notes

**R2.1 Copier headlines depuis CHANGELOG**

Ouvrir `CHANGELOG.md` section `[0.2.0]`, copier headlines :

```
🆕 Added:
• Offline editing support
• Export settings backup

🐛 Fixed:
• Token visibility security
• Sync reliability improvement
```

**R2.2 Formater pour stores**

**Google Play** (500 chars max) :
```
Version 0.2.0

🆕 New features:
• Offline editing — work anywhere, sync later
• Export settings backup — easy device migration

🐛 Bug fixes:
• Token security — hidden by default
• Sync reliability — fixed first-click failure
```

Longueur : ~230 chars ✓

**App Store** (4000 chars max) :
Ajouter plus de détails si nécessaire (voir `RELEASE_NOTES_FORMAT.md`)

**R2.3 Sauvegarder notes**

Créer `apps/github_notes/release_notes_en.txt` (copier-coller ready) :

```powershell
echo "Version 0.2.0..." > apps/github_notes/release_notes_en.txt
git add apps/github_notes/release_notes_en.txt
git commit -m "[github_notes] release: add v0.2.0 release notes for stores"
git push origin main
```

---

### ÉTAPE R3 : Build et release

**R3.1 Update version dans pubspec.yaml**

```yaml
version: 0.2.0+2  # version+buildNumber
```

Commit :
```powershell
git add apps/github_notes/pubspec.yaml
git commit -m "[github_notes] release: bump version to 0.2.0"
git push origin main
```

**R3.2 Créer tag Git**

```powershell
git tag -a github_notes-v0.2.0 -m "GitHub Notes v0.2.0: Offline editing + Export backup"
git push origin github_notes-v0.2.0
```

**R3.3 Build release**

```powershell
cd apps/github_notes
flutter build appbundle --release  # Android
flutter build ipa --release        # iOS (si Mac)
```

**R3.4 Upload stores**

1. Google Play Console → Nouvelle release
2. Coller `release_notes_en.txt` dans "Release notes"
3. Upload APK/AAB
4. Publish

---

### ÉTAPE R4 : Post-release

**R4.1 Update APP.md header**

```markdown
# GitHub Notes — Documentation

**Status** : ✅ v0.2.0 Released  
**Version actuelle** : v0.2.0 (stable)  
**Dernière update** : 2026-01-15
```

**R4.2 Archiver Recently Done (optionnel)**

Si items Done très anciens (> 1 mois), déplacer vers CHANGELOG permanent.

**R4.3 Commit post-release**

```powershell
git add _docs/apps/github_notes/APP.md
git commit -m "[github_notes] docs: update status to v0.2.0 released"
git push origin main
```

---

## 🔒 Issues GitHub (feature VERROUILLÉE)

### Statut actuel

**DÉSACTIVÉ PAR DÉFAUT** — Issues locales (#N) uniquement

### Conditions déverrouillage

Issues GitHub activées seulement si :
- ✅ Collaboration externe prévue (contributeurs)
- ✅ Beta publique avec testeurs externes
- ✅ Besoin tracking public (communauté GitHub)
- ✅ gh CLI installé et configuré

### Si activation future

1. Installer gh CLI : `winget install GitHub.cli`
2. Login : `gh auth login`
3. Créer labels : 
   ```powershell
   gh label create "github_notes" --color E36C2D
   gh label create "P1" --color FF0000
   ```
4. Update process : issues locales peuvent escalader vers GH
5. Pattern APP.md : `- [ ] #10: Feature → [GH#42](...)`

**Référence** : `ISSUES_LOCAL_VS_GITHUB.md` (activation manuelle requise)

---

## 📊 Checklist rapide

### Avant chaque session
- [ ] Pull main : `git pull origin main`
- [ ] Lire APP.md P1/P2
- [ ] Choisir issue #N

### Pendant dev
- [ ] Branche : `type/app-short-desc`
- [ ] Move issue vers In Progress
- [ ] Commits réguliers avec messages clairs
- [ ] Questions → Parking Lot (trier plus tard)

### Après dev (avant merge)
- [ ] `flutter analyze` passe (0 errors)
- [ ] `flutter test` passe (si tests)
- [ ] Device test (release build)
- [ ] Cocher issue → Recently Done (avec SHA)
- [ ] Update CHANGELOG [Unreleased] (headline + détails)
- [ ] Commit doc + merge main + delete branch

### Fin session
- [ ] Trier Parking Lot (promouvoir ou supprimer)
- [ ] Archiver Recently Done si > 15 items
- [ ] Push all changes

### Release (quand prêt)
- [ ] Décider version (MAJOR.MINOR.PATCH)
- [ ] Renommer [Unreleased] → [version] - date
- [ ] Extraire release notes (copier headlines)
- [ ] Update pubspec.yaml version
- [ ] Tag Git : `app-vX.Y.Z`
- [ ] Build release
- [ ] Upload stores + coller release notes
- [ ] Update APP.md status

---

## 🎯 Exemple complet (fictif)

### Jour 1 : Fix bug #1

```
09:00 — Consulter APP.md P1
09:05 — git checkout -b fix/github_notes-token-visibility
09:10 — Déplacer #1 vers In Progress (commit doc)
09:15 — Coder fix
10:30 — Tests locaux OK
10:45 — Device test OK
11:00 — Cocher #1 Done (commit abc1234)
11:10 — Update CHANGELOG [Unreleased]
11:15 — Commit doc + merge main + delete branch
11:20 — Trier Parking Lot (1 idea → P3)
11:25 — Push all
```

### Jour 2-5 : Autres P1

```
Répéter process pour #2, #3, #4...
CHANGELOG [Unreleased] se remplit progressivement
```

### Jour 6 : Release v0.2.0

```
14:00 — Vérifier In Progress vide, P1 terminés
14:10 — Décider version : MINOR (features Added)
14:15 — Renommer [Unreleased] → [0.2.0] - 2026-01-15
14:20 — Extraire release notes (copier headlines)
14:30 — Update pubspec.yaml → 0.2.0+2
14:35 — git tag github_notes-v0.2.0
14:40 — flutter build appbundle --release
15:00 — Upload Google Play + coller release notes
15:10 — Update APP.md status "v0.2.0 Released"
15:15 — Push all
```

---

## 📝 Résumé des fichiers impactés

À chaque cycle de dev (issue #N) :

1. **APP.md** : P1 → In Progress → Recently Done
2. **CHANGELOG.md** : Ajout dans [Unreleased]
3. **Code** : Fichiers modifiés techniques
4. **Git** : Branche feat/fix, commits, merge, tag

À chaque release :

5. **CHANGELOG.md** : [Unreleased] → [version]
6. **pubspec.yaml** : Bump version
7. **release_notes_en.txt** : Copier headlines
8. **Stores** : Upload + release notes

---

**Version** : 1.0 (brouillon)  
**Date** : 2026-01-11  
**Statut** : PROPOSAL — Process complet cohérent, à valider avant application  
**Issues GitHub** : ⛔ VERROUILLÉ (feature désactivée par défaut)
