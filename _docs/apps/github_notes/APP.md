# GitHub Notes — Documentation

**Status** : 🚧 En développement  
**Version actuelle** : v0.1 MVP  
**Dernière update** : 2026-01-01  
**Roadmap** : Voir [`ROADMAP.md`](ROADMAP.md) pour le plan détaillé des versions

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
- ✅ Éditeur markdown simple (TextField multiline + scrollbar)
- ✅ Sauvegarde locale (cache Drift)
- ✅ Sync manuelle vers GitHub (bouton "Sync GitHub")
- ✅ Auth GitHub via Personal Access Token (saisie manuelle + secure storage)
- ✅ Détection conflits SHA + dialog résolution
- ✅ Dark theme support (system)
- ✅ Markdown quick help (bouton aide)

**Specs techniques** :
- **State** : Riverpod (Provider, StreamProvider, FutureProvider)
- **DB** : Drift (tables: `project_files`, `file_contents`, `app_settings`)
- **API** : GitHub REST API (`GET/PUT /repos/{owner}/{repo}/contents/{path}`)
- **UI** : dotlyn_ui theme + Material Icons
- **Security** : flutter_secure_storage pour GitHub token

**Non inclus v0.1** :
- ❌ Background sync automatique
- ❌ Preview markdown avancé (rendu HTML)
- ❌ OAuth GitHub (seulement token manuel)

---

## 📝 TODO

### 🔴 P1 — MVP v0.1 (Release prep)

**Backend** :
- [x] Models: `ProjectFile`, `FileContent`, `SyncStatus`
- [x] Drift schema: tables + migrations
- [x] GitHub API service: `fetchFile()`, `updateFile()`, `testToken()`
- [x] Providers: `projectFilesProvider`, `fileContentProvider`, `githubServiceProvider`
- [x] Secure storage: token storage via `flutter_secure_storage`

**UI** :
- [x] Screen: Files list (home)
- [x] Screen: File editor (scrollbar + markdown help)
- [x] Screen: Settings (GitHub token + add/remove files)
- [ ] Widget: FileCard extracted (reusable component)

**Setup** :
- [x] Bootstrap dependencies
- [x] Test API GitHub (avec token test)
- [ ] Tests unitaires de base (Drift + GitHub service mock)
- [ ] Build & run sur Android/iOS (device smoke test)
- [ ] Create GitHub label `github_notes`
- [ ] Release: version bump + CHANGELOG.md

**Note** : App mobile uniquement (Android/iOS). Pas de support web/desktop.

### 🟡 P2 — Améliorations v0.2

- [x] Détection conflits (compare SHA GitHub vs local)
- [ ] Preview markdown avancé (package flutter_markdown avec rendu)
- [ ] Background sync (chaque 15min si connecté)
- [ ] Historique versions locales (rollback)
- [ ] FileCard widget extracted (status badge, last sync)
- [ ] Widget library standardization
- [ ] Ajouter un bouton “Dupliquer” sur chaque carte de fichier suivi. Ce bouton ouvre le dialogue d’ajout de fichier, pré-rempli avec les paramètres du fichier source (modifiable avant validation).
- [ ] Repenser l’UI des actions : placer les icônes d’édition et de suppression au-dessus du texte de la carte pour alléger la présentation.
- [ ] Lors de l’ajout ou duplication, permettre de tester si le fichier distant existe déjà :
    - Si oui, proposer de le suivre directement.
    - Si non, proposer de le créer ou de modifier les paramètres avant validation.
- [ ] Permettre la synchronisation bidirectionnelle : si le fichier a été modifié sur GitHub, proposer de rapatrier la version distante (pull) au lieu d’écraser systématiquement avec la version locale. L’utilisateur doit pouvoir choisir entre :
    - Écraser GitHub avec la version locale (push)
    - Récupérer la version GitHub et remplacer le local (pull)
    - Fusionner manuellement en cas de conflit

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

---

## Configuration / Quickstart

Ce guide explique la configuration dev pour tester l'app `github_notes` (émulateur/devices, token GitHub, et points de debug courants).

### Prérequis
- Flutter (version compatible avec le monorepo).
- Melos installé si vous utilisez le monorepo.
- Un compte GitHub avec droits pour créer / modifier un repo de test.

### 1) Bootstrap & dépendances
Depuis la racine du monorepo :

```bash
melos bootstrap
```

Puis, pour travailler sur l'app :

```bash
cd apps/github_notes
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2) Générer un token GitHub (scopes)
1. Ouvrez GitHub → Settings → Developer settings → Personal access tokens.
2. Créez un token (classic) avec au minimum la scope `repo` (ou `repo:contents`) pour lire/écrire des fichiers.
3. Copiez le token — **NE PAS** le committer.

### 3) Injecter le token sur l'émulateur / device
Option A — via l'app (recommandé) :
- Lancez l'app en debug ou profile.
- Ouvrez `Settings` → collez le token → `Save token`.
- Appuyez sur `Test token` pour vérifier la validité. En debug builds, un bouton `Show token (debug)` est disponible pour vérifier la valeur stockée.

Option B — via `adb` (Android) pour tests rapides :
- Vous pouvez stocker une valeur temporaire dans `SharedPreferences` ou un endpoint de debug, mais l'app utilise `flutter_secure_storage`. Le moyen simple est de lancer l'app et coller le token via l'UI.

### 4) Vérifier l'horloge de l'émulateur
Si vous rencontrez des erreurs TLS ou des tokens refusés, vérifiez que l'horloge de l'émulateur est correcte :
- Android Emulator: Extended Controls → Settings → Date & Time → désactiver `Use network-provided time` et régler manuellement, ou exécuter :

```bash
adb shell date $(date +%m%d%H%M%Y)
```

(ou régler depuis l'UI de l'émulateur). Une horloge incorrecte peut provoquer des échecs d'authentification.

### 5) Créer un repo / fichier de test
- Créez un repo test sur GitHub (privé ou public).
- Notez `owner` et `repo` et le `path` du fichier `.md` (ex : `notes/test-note.md`).
- Dans l'app, `Add file` → renseigner owner/repo/path et créer le fichier.

### 6) Flux de test complet
1. Ouvrez l'app (`flutter run` depuis `apps/github_notes`).
2. Settings → collez `Personal Access Token` → Save → Test token.
3. Files → Add file (owner/repo/path).
4. Ouvrez le fichier, modifiez le contenu localement → Save local.
5. Appuyez `Sync` ou `Publish` pour envoyer la modification vers GitHub.
6. En cas de conflit (409), l'éditeur propose de `Fetch remote` ou `Overwrite` — utiliser `Fetch remote` pour récupérer la version distante.

### 7) Débogage rapide
- Voir le token (debug builds seulement) : Settings → `Show token (debug)` puis copier.
- Logs : `flutter run` pour voir la sortie et erreurs réseau.
- Si `Test token` renvoie invalide : revérifier le token, les scopes, et l'horloge de la machine/émulateur.

### 8) Sécurité
- Ne committez jamais de tokens.
- Pour la distribution, retirez tout bouton debug qui affiche le token.

### 9) Problèmes connus
- Horloge émulateur incorrecte → tokens refusés / TLS fail.
- Conflits 409 si le fichier distant a changé → choisir `Fetch remote` pour comparer.

---

## Notes & Liens
- Styleguide : see `_docs/dotlyn/STYLEGUIDE.md`.
- Checklist avant commit : `flutter analyze`, tests, update `APP.md` si nécessaire.
