# Versioning & CHANGELOG & Release Notes

> **Statut** : DÉFINITIF — Guide complet versioning + CHANGELOG + stores  
> **Date** : 2026-01-11  
> **Principe** : Semantic versioning strict + format store-ready

---

## � Scope du Versioning

**Ce guide couvre** :
1. **Apps individuelles** : `apps/[app]/CHANGELOG.md` — versioning indépendant par app (ex: github_notes v0.1.0, money_tracker v0.2.0)
2. **Monorepo global** : `CHANGELOG.md` (racine) — versioning du workflow, docs, infrastructure, packages partagés (ex: dotlyn-apps v2.0.0)

**Distinction** :
- **App releases** → Tag Git : `apps/[app]-vX.Y.Z` (ex: `apps/github_notes-v0.1.0`)
- **Monorepo releases** → Tag Git : `dotlyn-vX.Y.Z` (ex: `dotlyn-v2.0.0`)

---

## �🔢 Semantic Versioning

### Format

```
MAJOR.MINOR.PATCH
```

**Exemples** : 1.0.0, 0.2.5, 2.1.3

### Règles de Décision

#### MAJOR (breaking changes)

**Quand incrémenter** :
- API breaking change (suppression endpoint, changement signature)
- DB schema incompatible (migration impossible sans perte données)
- Comportement radical différent (ex : offline-first → online-only)
- Format fichier incompatible

**Exemples** :
- v1.0.0 → v2.0.0 : Migration DB avec suppression colonne
- v0.5.0 → v1.0.0 : Première release stable (sortie beta)

**Impact utilisateur** : **HAUT** — Peut nécessiter migration manuelle

---

#### MINOR (new features, backwards-compatible)

**Quand incrémenter** :
- Nouvelle feature (ex : export settings, offline mode)
- Amélioration UX majeure (ex : dark mode, nouveau screen)
- Ajout API endpoint (sans casser existant)
- DB schema additive (ajout colonne avec default)

**Exemples** :
- v0.1.0 → v0.2.0 : Ajout offline editing
- v1.2.0 → v1.3.0 : Ajout export backup

**Impact utilisateur** : **MOYEN** — Nouvelles features disponibles

---

#### PATCH (bug fixes, no new features)

**Quand incrémenter** :
- Bug fix (crash, erreur logique)
- Performance improvement (pas de nouvelle feature)
- Security fix
- Typo, wording
- Refactoring interne (pas visible utilisateur)

**Exemples** :
- v0.1.0 → v0.1.1 : Fix crash Android 12
- v1.2.3 → v1.2.4 : Fix token validation bug

**Impact utilisateur** : **BAS** — Corrections uniquement

---

### Cas Particuliers

#### Pre-release (v0.x.y)

**Convention** :
- `v0.x.y` = Beta, pas encore stable
- MINOR peut contenir breaking changes (toléré en beta)
- PATCH = bug fixes uniquement

**Transition stable** :
```
v0.9.5 → v1.0.0 (première release stable)
```

#### Hotfix

**Pattern** :
```
v1.2.3 (stable)
↓
v1.2.4 (hotfix bug critique)
```

**Workflow** :
1. Branch `hotfix/app-critical-fix` depuis tag `v1.2.3`
2. Fix + tests
3. Tag `v1.2.4`
4. Merge back dans `main` ET release branch si applicable

---

## 📄 CHANGELOG Format

### Structure Complète

```markdown
# Changelog

Toutes les modifications notables de ce projet sont documentées ici.

Format basé sur [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).  
Versioning basé sur [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

<!-- Section active quotidienne -->

### Added 🆕
- **User-facing headline** (store-ready, max 80 chars)
  - Technical details: implementation specifics
  - User benefit: why it matters for user
  - (commit abc1234, closes #5)

### Changed ✨
- **Behavior modification headline**
  - Technical: internal changes
  - Impact: how usage changes
  - (commit def5678)

### Fixed 🐛
- **Bug fix headline**
  - Technical: root cause + solution
  - Impact: what works now
  - (commit ghi9012, closes #3)

### Code Quality 🔧
- **Internal improvement headline**
  - Details: refactoring, optimization, etc.
  - (commit jkl3456)

---

## [0.2.0] - 2026-01-15

### Added 🆕
- **Offline editing support**
  - Technical: Create/edit files without network, sync when online
  - User benefit: Work anywhere, connectivity-independent
  - (commit 4f2a8b3, closes #12)

- **Export settings backup**
  - Technical: JSON export via Share sheet
  - User benefit: Easy device migration or restore after reinstall
  - (commit 8d3c1f9, closes #10)

### Changed ✨
- **Simplified file creation flow**
  - Technical: Removed GitHub validation on add, validate at sync
  - Impact: Faster file addition, better offline UX
  - (commit a5b9e2c)

### Fixed 🐛
- **Token visibility security**
  - Technical: Default hidden, auto-hide when leaving settings
  - Impact: Prevents accidental token exposure
  - (commit 7e4d2a1, closes #1)

- **Sync button intermittent failure**
  - Technical: Resolved race condition in first-click handler
  - Impact: Reliable sync on first attempt
  - (commit 3c8f5b2, closes #2)

### Code Quality 🔧
- **Refactored file list widget**
  - Extracted reusable FileListWidget component
  - Improved maintainability
  - (commit 9e5d4c8)

---

## [0.1.0] - 2026-01-10

### Added 🆕
- **Initial MVP release**
  - GitHub file tracking (owner/repo/path)
  - Markdown editor with auto-save (2s debounce)
  - Manual sync with conflict detection (SHA verification)
  - Personal Access Token secure storage
  - Dark theme support (system-aware)
  - (commit d8b2ac6)

### Security 🔒
- INTERNET permission for GitHub API
- Token sanitization (trim, remove invisible chars)
- flutter_secure_storage for token persistence
```

### Règles Strictes

**[Unreleased] Section** :
- ❌ **PAS de dates** (ajoutées au release)
- ✅ **Section active** mise à jour quotidiennement
- ✅ **Catégories** : Added, Changed, Fixed, Code Quality (+ Security/Deprecated si nécessaire)

**Catégories Usage** :
- **Added** : Nouvelles features visibles utilisateur
- **Changed** : Modifications comportement existant
- **Fixed** : Corrections bugs
- **Code Quality** : Refactoring, optimisation, amélioration interne (pas visible utilisateur)
- **Security** : Fixes sécurité (rare, highlight important)
- **Deprecated** : Features en voie de suppression (v2.0+)

**Format Entrées** :
```markdown
- **Headline user-facing** (max 80 chars, store-ready)
  - Technical: détails implémentation
  - Impact/Benefit: ce que ça apporte utilisateur
  - (commit SHA7CHAR, closes #N)
```

**Commit SHA** :
- ✅ **OBLIGATOIRE** : 7 premiers caractères (`abc1234`)
- ✅ **Issue reference** : `closes #N` ou `from issue #N`

---

## 🚀 Release Workflow

### Étape 1 : Décider Version

**Questions** :
1. Breaking changes ? → MAJOR
2. Nouvelles features ? → MINOR
3. Bug fixes uniquement ? → PATCH

**Exemple** :
- Current : v0.1.5
- Changes : Offline mode (new feature) + bug fixes
- Decision : v0.2.0 (MINOR)

### Étape 2 : Renommer [Unreleased]

**CHANGELOG.md** :

```markdown
## [Unreleased]

[vide]

---

## [0.2.0] - 2026-01-15

[Contenu ex-Unreleased collé ici]
```

### Étape 3 : Tag Git

```bash
git tag v0.2.0 -m "Release v0.2.0: Offline editing + export backup"
git push origin v0.2.0
```

### Étape 4 : Update APP.md

```markdown
## ✅ Versions Complétées

### v0.2.0 (2026-01-15) — Offline Edition
- Offline editing support
- Export settings backup
- Bug fixes (token visibility, sync reliability)
```

### Étape 5 : Créer Release Notes Stores

Voir section suivante.

---

## 📱 Release Notes — Stores Format

### Google Play Store

**Contraintes** :
- **Max 500 caractères**
- Format : Plain text ou markdown simple
- Une version par langue (en, fr)

**Template** :

```
Version 0.2.0

🆕 New features:
• Offline editing — work anywhere, sync later
• Export settings backup — easy device migration

✨ Improvements:
• Simplified file creation — faster workflow

🐛 Bug fixes:
• Token security — default hidden
• Sync reliability — works first time
```

**Longueur** : ~280 chars (sous limite 500)

**Workflow** :
1. Copier headlines depuis CHANGELOG [0.2.0]
2. Condenser si nécessaire (retirer technical details)
3. Coller dans Google Play Console → Release → Release notes

---

### Apple App Store

**Contraintes** :
- **Max 4000 caractères**
- Format : Plain text
- Une version par langue

**Template** :

```
What's New in Version 0.2.0

🆕 New Features

Offline Editing Support
Work on your files anywhere, even without internet. Changes sync automatically when you're back online.

Export Settings Backup
Easily backup your tracked files configuration as JSON. Restore on new device or after reinstall.

✨ Improvements

Simplified File Creation
No more waiting for GitHub validation when adding files. Create locally, validate at sync time for faster workflow.

🐛 Bug Fixes

Token Visibility Security
Your GitHub token is now hidden by default and auto-hides when leaving settings for better security.

Sync Button Reliability
Fixed intermittent failure on first sync attempt. Now works reliably every time.
```

**Longueur** : ~750 chars (sous limite 4000)

**Workflow** :
1. Copier headlines + technical details depuis CHANGELOG [0.2.0]
2. Reformuler user-friendly (retirer jargon technique)
3. Coller dans App Store Connect → Version Information → What's New

---

### Extraction Automatisée (Future)

**Pattern regex** pour extraire headlines :

```regex
^- \*\*(.+?)\*\*$
```

**Script PowerShell** (exemple) :

```powershell
# Extraire headlines de CHANGELOG [0.2.0]
$content = Get-Content "apps/app/CHANGELOG.md" -Raw
$version = "## \[0.2.0\].*?(?=\n## \[|$)"
$matches = [regex]::Matches($content, $version, [Text.RegularExpressions.RegexOptions]::Singleline)

foreach ($match in $matches) {
    $headlines = [regex]::Matches($match.Value, '- \*\*(.+?)\*\*')
    foreach ($h in $headlines) {
        Write-Output $h.Groups[1].Value
    }
}
```

Output :
```
Offline editing support
Export settings backup
Simplified file creation flow
Token visibility security
Sync button intermittent failure
```

---

## 📊 Decision Tree

### Flowchart Versioning

```
Changements prêts ?
  ↓
Breaking changes ?
  → OUI → MAJOR (v2.0.0)
  → NON ↓
Nouvelles features ?
  → OUI → MINOR (v0.2.0)
  → NON ↓
Bug fixes uniquement ?
  → OUI → PATCH (v0.1.1)
```

### Examples Décisions

| Changement                              | Current | New   | Raison        |
| --------------------------------------- | ------- | ----- | ------------- |
| Fix crash Android 12                    | 0.1.0   | 0.1.1 | PATCH (fix)   |
| Add offline mode                        | 0.1.5   | 0.2.0 | MINOR (feat)  |
| Migration DB incompatible               | 0.9.0   | 1.0.0 | MAJOR (break) |
| Refactor internal code (no user impact) | 0.2.3   | 0.2.4 | PATCH (qual)  |
| Add export + fix bugs                   | 0.1.0   | 0.2.0 | MINOR (feat)  |

---

## 🔗 Workflow Integration

### Lien avec APP.md

**Lors release** :

1. CHANGELOG [Unreleased] → [0.2.0]
2. APP.md Recently Done items → Vérifier présence dans CHANGELOG
3. APP.md Versions Complétées → Ajouter nouvelle version

**Cohérence** :
- Recently Done items doivent être dans CHANGELOG [Unreleased] ou [version]
- Si Recently Done > 15 items, archiver dans CHANGELOG

### Lien avec Commits

**Pattern commit** :

```
[app] type: description (closes #N)
```

**Types** :
- `feat` → CHANGELOG Added
- `fix` → CHANGELOG Fixed
- `refactor` → CHANGELOG Code Quality
- `perf` → CHANGELOG Code Quality
- `chore` → (pas dans CHANGELOG sauf si impact user)

**Exemple workflow** :

```bash
# Commit
git commit -m "[app] feat: add offline editing (closes #12)"

# CHANGELOG [Unreleased]
### Added
- **Offline editing support**
  - (commit 4f2a8b3, closes #12)

# APP.md Recently Done
- [x] #12: Add offline editing — Done 2026-01-15 (commit 4f2a8b3)
```

---

## ✅ Checklist Release

Avant de publier v0.2.0 :

- [ ] Tous tests passent (`flutter test`)
- [ ] Analyzer clean (`flutter analyze`)
- [ ] CHANGELOG [Unreleased] → [0.2.0] - YYYY-MM-DD
- [ ] APP.md Versions Complétées mis à jour
- [ ] Tag Git créé (`v0.2.0`)
- [ ] Release notes stores préparées (Google Play + App Store)
- [ ] Build release (`flutter build apk --release` / `flutter build ipa`)
- [ ] Upload sur stores
- [ ] Annonce release (Twitter/blog si applicable)

---

## 📚 Références

- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- **Workflow complet** : [WORKFLOW.md](WORKFLOW.md)
- **Pre-commit checklist** : `_docs/PRE_COMMIT_CHECKLIST.md`

---

**Version** : 1.0  
**Date** : 2026-01-11  
**Maintainer** : @sedounet
