# Release Notes Format (Store-Ready)

> **Objectif** : Convertir CHANGELOG → texte pour Google Play / App Store  
> **Statut** : BROUILLON — À copier-coller manuellement pour l'instant

---

## Contraintes stores

### Google Play Store
- **Max 500 caractères** (Release notes)
- **Format** : Plain text ou markdown simple
- **Langue** : Une version par langue (en, fr, etc.)

### Apple App Store
- **Max 4000 caractères** (What's New)
- **Format** : Plain text
- **Langue** : Une version par langue

---

## Template copier-coller (Google Play)

**Source** : Copier depuis CHANGELOG.md section `[0.2.0]` → headlines seulement

```
Version 0.2.0

🆕 New features:
• Offline editing support — work anywhere, sync later
• Export settings backup — easy migration to new device

✨ Improvements:
• Simplified file creation flow — faster, better offline UX

🐛 Bug fixes:
• Token visibility security — default hidden
• Sync button reliability — works on first click
```

**Longueur** : ~280 chars (OK pour limite 500)

---

## Template copier-coller (Apple App Store)

**Source** : Même headlines + plus de détails si besoin

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

**Longueur** : ~750 chars (bien sous limite 4000)

---

## Workflow manuel (copier-coller)

### Étape 1 : Préparer release dans CHANGELOG

```markdown
## [Unreleased]
...

→ Renommer en :

## [0.2.0] - 2026-01-15
...
```

### Étape 2 : Extraire headlines

Copier seulement les lignes avec `- **Headline**` depuis CHANGELOG.md :

```markdown
### Added 🆕
- **Offline editing support**
- **Export settings backup**

### Fixed 🐛
- **Token visibility security**
- **Sync button reliability**
```

### Étape 3 : Formater pour store

**Google Play** (court) :
```
Version 0.2.0

🆕 Offline editing + Export backup
✨ Simplified file creation
🐛 Token security + Sync reliability
```

**App Store** (détaillé) :
```
What's New in Version 0.2.0

🆕 Offline editing support
Work anywhere, sync later when online.

🆕 Export settings backup
Easy migration to new device.

🐛 Token security improved
Default hidden, auto-hide on exit.
```

### Étape 4 : Copier-coller dans console store

1. Ouvrir Google Play Console / App Store Connect
2. Nouvelle release → "Release notes" / "What's New"
3. Coller texte préparé
4. Sauvegarder

---

## Exemple complet (GitHub Notes v0.1.0)

### CHANGELOG.md (source)

```markdown
## [0.1.0] - 2026-01-10

### Added 🆕
- **Initial MVP release**
  - GitHub file tracking
  - Markdown editor with auto-save
  - Manual sync with conflict detection
  - Dark theme support

### Security 🔒
- Token sanitization and secure storage
```

### Google Play Release Notes (500 chars max)

```
Version 0.1.0 — Initial Release

🆕 GitHub markdown editor for mobile
• Track files from any GitHub repo
• Offline editing with auto-save
• Manual sync with conflict detection
• Dark theme support
• Secure token storage

Edit your dev notes (PROMPT_USER.md, APP.md) directly from your phone.
```

**Longueur** : 298 chars ✅

### App Store What's New (4000 chars max)

```
What's New in Version 0.1.0

GitHub Notes is a mobile markdown editor for developers who want quick access to their GitHub files.

🆕 Core Features

GitHub File Tracking
Configure owner/repo/path for any markdown file in your repositories. Track multiple files with custom nicknames.

Markdown Editor
Full-featured editor with auto-save (2 second debounce). Edit long documents with scrollbar support.

Offline Editing
Work without internet connection. All changes saved locally and synced when you're back online.

GitHub Sync
Manual sync with conflict detection using SHA verification. Choose to keep local or remote version when conflicts occur.

Dark Theme
System-aware dark theme for comfortable editing in any lighting condition.

🔒 Security

Personal Access Token secure storage using flutter_secure_storage. Token sanitization prevents invisible characters issues.

Perfect for editing development notes (PROMPT_USER.md, APP.md, USER-NOTES.md) directly from mobile.
```

**Longueur** : ~1100 chars ✅

---

## Future automation (optionnel)

**Script Python possible** (mais pas urgent) :

```python
# scripts/generate_release_notes.py
# Usage: python scripts/generate_release_notes.py apps/github_notes
# Output: release_notes_en.txt (copier-coller ready)

# Parse CHANGELOG.md
# Extract latest version headlines
# Format for Google Play (500 chars)
# Format for App Store (1000+ chars)
# Save to release_notes_en.txt
```

**Pour l'instant** : Copier-coller manuel depuis CHANGELOG suffit amplement.

---

**Version** : 1.0 (brouillon)  
**Date** : 2026-01-11  
**Statut** : PROPOSAL — Process manuel validé, automation optionnelle future
