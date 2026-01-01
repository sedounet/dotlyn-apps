# GitHub Notes — Documentation

**Status** : 🚧 En développement  
**Version actuelle** : v0.1 MVP  
**Dernière update** : 2025-12-31

---

## 📋 Vision

App de prise de notes GitHub-sync pour faciliter le workflow de développement avec VS Code IA.

**Objectif** : Accès rapide depuis mobile aux fichiers markdown de travail (PROMPT_USER.md, APP.md) avec édition offline et sync GitHub.

---

## 🎯 Versions

### v0.1 MVP — Fonctionnalités de base

**Fonctionnalités** :
- ✅ Configuration de fichiers trackés (owner/repo/path/nickname)
- ✅ Liste des fichiers configurés
- ✅ Éditeur markdown simple (TextField multiline)
- ✅ Sauvegarde locale (cache Drift)
- ✅ Sync manuelle vers GitHub (bouton "Push")
- ✅ Auth GitHub via Personal Access Token (saisie manuelle)

**Specs techniques** :
- **State** : Riverpod (Provider, StreamProvider, NotifierProvider)
- **DB** : Drift (tables: `project_files`, `file_contents`)
- **API** : GitHub REST API (`GET/PUT /repos/{owner}/{repo}/contents/{path}`)
- **UI** : dotlyn_ui theme + Material Icons

**Non inclus v0.1** :
- ❌ Détection conflits (si fichier modifié sur GitHub)
- ❌ Background sync automatique
- ❌ Preview markdown avancé
- ❌ OAuth GitHub (seulement token manuel)

---

## 📝 TODO

### 🔴 P1 — MVP v0.1 (ASAP)

**Backend** :
- [ ] Models: `ProjectFile`, `FileContent`, `SyncStatus`
- [ ] Drift schema: tables + migrations
- [ ] GitHub API service: `fetchFile()`, `updateFile()`
- [ ] Providers: `projectFilesProvider`, `fileContentProvider`, `githubServiceProvider`

**UI** :
- [ ] Screen: Files list (home)
- [ ] Screen: File editor
- [ ] Screen: Settings (GitHub token + add/remove files)
- [ ] Widget: FileCard (status badge, last sync)

**Setup** :
- [x] Bootstrap dependencies
- [ ] Test API GitHub (avec token test)
- [ ] Build & run sur Android/iOS

**Note** : App mobile uniquement (Android/iOS). Pas de support web/desktop.

### 🟡 P2 — Améliorations v0.2

- [ ] Détection conflits (compare SHA GitHub vs local)
- [ ] Preview markdown (package flutter_markdown)
- [ ] Background sync (chaque 15min si connecté)
- [ ] Historique versions locales (rollback)

### 🔵 P3 — Plus tard

- [ ] OAuth GitHub flow complet
- [ ] Support multi-comptes GitHub
- [ ] Édition collaborative (notif si autre commit)
- [ ] Export local (.md file)

---

## 🔗 Liens

- PITCH.md : [`_docs/apps/github_notes/PITCH.md`](PITCH.md)
- Repo GitHub : `dotlyn-apps/apps/github_notes`

---

## 📌 Notes en vrac

- **GitHub API rate limit** : 60 req/h sans auth, 5000 req/h avec token
- **Token scope requis** : `repo` (accès privé) ou `public_repo` (public seulement)
- **SHA verification** : GitHub retourne SHA du fichier, stocker en local pour détecter conflits
- **Offline strategy** : Toujours charger cache local d'abord, sync en arrière-plan
- **Error handling** : Toast pour erreurs réseau, dialog pour conflits
