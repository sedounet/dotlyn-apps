# Pre-Commit Checklist — Dotlyn Apps

> **CRITICAL** : Cette checklist doit être exécutée AVANT CHAQUE commit. Aucune exception.

---

## ✅ Checklist Obligatoire (Order Strict)

### Phase 1 : Vérification Code

**1.1 Lancer l'analyzer**
```powershell
cd apps/[app]
flutter analyze
```
- ❌ **Si erreurs** → FIX immédiatement, retour 1.1
- ✅ **Si "No issues found"** → passer 1.2

**1.2 Vérifier imports inutilisés**
```powershell
# Avant de supprimer un import, vérifier usage dans le fichier
grep -r "SymbolName" path/to/file.dart
```
- ❌ **Si utilisé** → NE PAS supprimer
- ✅ **Si non utilisé** → supprimer, relancer 1.1

**1.3 Lancer tests (si existants)**
```powershell
cd apps/[app]
flutter test
```
- ❌ **Si échecs** → FIX, retour 1.1
- ✅ **Si tous passent** → passer Phase 2

---

### Phase 2 : Documentation

**2.1 Marquer l'item comme fait dans APP.md**
- Cocher `[x]` dans section TODO P1/P2/P3
- Ajouter date + commit SHA (optionnel mais recommandé)

Exemple :
```markdown
- [x] Help tooltips sur Add File dialog — **Done 2026-01-10** (commit d8b2ac6)
```

**2.2 Mettre à jour CHANGELOG.md (section Unreleased)**
```markdown
## [Unreleased]

### 2026-01-10 — Brief description
- **Fixed**: Short description of fix
- **Added**: Short description of feature
```

**2.3 Vérifier USER-NOTES.md (si applicable)**
- Si l'item vient de USER-NOTES → **NE PAS supprimer automatiquement**
- Proposer suppression à l'utilisateur
- Après validation → supprimer notes traitées

---

### Phase 3 : Git Operations

**3.1 Vérifier fichiers modifiés**
```powershell
git status
```
- Lister tous les fichiers changés
- Vérifier qu'aucun fichier indésirable (ex: `.env`, tokens) n'est inclus

**3.2 Préparer message commit**
Format : `[app] type: description`
- Types : `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
- Description : court, impératif (ex: "add tooltips", pas "added tooltips")

Exemples :
```
[github_notes] feat: add tooltips to Add File dialog
[github_notes] fix: remove unused imports in settings_screen
[github_notes] chore: mark P2 tooltips done; update CHANGELOG
[docs] update: add CHANGELOG to standards
```

**3.3 Proposer commit à l'utilisateur**
- ❌ **NE JAMAIS committer automatiquement**
- ✅ Proposer : "✅ Changements prêts : [liste fichiers]. Commit avec message `[app] type: description` ?"
- ⏸️ **ATTENDRE validation utilisateur**

**3.4 Exécuter commit & push (après validation)**
```powershell
git add [files]
git commit -m "[app] type: description"
git push origin main
git --no-pager log -1 --pretty=format:"%h %s"
```

---

## 🚫 À NE JAMAIS FAIRE

❌ Committer sans lancer `flutter analyze`  
❌ Marquer un item comme fait avant que les tests passent  
❌ Supprimer un import sans vérifier son usage (`grep` obligatoire)  
❌ Committer automatiquement sans proposer à l'utilisateur  
❌ Pousser sur `main` sans avoir vérifié `git status`  
❌ Oublier de mettre à jour `CHANGELOG.md` section `[Unreleased]`  
❌ Modifier `USER-NOTES.md` sans validation utilisateur

---

## 🔄 Workflow Complet (Résumé)

```
1. Code changes
   ↓
2. flutter analyze (MUST be clean)
   ↓
3. flutter test (if tests exist)
   ↓
4. Update APP.md TODO (check item, add date)
   ↓
5. Update CHANGELOG.md [Unreleased]
   ↓
6. git status (verify files)
   ↓
7. Propose commit message to user
   ↓
8. WAIT for user validation
   ↓
9. git add + commit + push
   ↓
10. Show commit SHA
```

---

## 📋 Template Proposition Commit

```
✅ Changements prêts :
- apps/[app]/lib/[file].dart
- _docs/apps/[app]/APP.md
- apps/[app]/CHANGELOG.md

Commit avec message `[app] type: description` ?
```

---

**Version** : 1.0  
**Date** : 2026-01-10  
**Maintainer** : @sedounet
