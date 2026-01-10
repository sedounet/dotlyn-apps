# Branching simple — Dotlyn Apps

But: proposer une convention légère pour un seul développeur travaillant sur plusieurs petites apps.

Principe général
- `main` : source of truth, toujours stable (testé avant merge).
- Workflow : branch → commits → test local → merge direct → suppression branche.
- Pas de PR obligatoire (optionnel si tu veux CI automatique GitHub Actions).

Format de nommage
- Très simple : `type[/app]-short-description`
  - `type` : `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
  - `/app` : optionnel, nom de l'app (ex: `github_notes`, `money_tracker`) si la tâche concerne une app spécifique
  - `short-description` : court, kebab-case (sans accents)

Exemples
- `feat/github_notes-add-project-file-form`
- `fix/money-tracker-amount-rounding`
- `chore/update-deps`

Workflow pratique (solo, sans PR obligatoire)
1. Créer branche depuis `main` :
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feat/<app>-short-desc
   ```

2. Travailler et commiter (commits clairs) :
   ```bash
   git add .
   git commit -m "[app] type: courte description"
   # Répéter pour chaque unité logique (ex: plusieurs P1)
   ```

3. Pousser la branche (sauvegarde) :
   ```bash
   git push -u origin feat/<app>-short-desc
   ```

4. Avant merge : vérifier localement :
   ```bash
   melos run analyze    # Lint/analyze
   flutter test         # Si tests présents
   ```

5. Merger dans `main` (direct, pas de PR nécessaire) :
   ```bash
   git checkout main
   git pull origin main
   git merge --no-ff feat/<app>-short-desc   # Conserve l'historique branche
   git push origin main
   ```

6. Supprimer la branche (locale + distante) :
   ```bash
   git branch -d feat/<app>-short-desc
   git push origin --delete feat/<app>-short-desc
   ```

Note : PR optionnelle — utile si tu veux CI GitHub Actions automatique ou garder trace discussion, mais pas obligatoire pour solo.

Suppression des branches
- Locale : `git branch -d <branch>` (ou `-D` si besoin).
- Distante : `git push origin --delete <branch>`.

Cas particuliers
- Travail simultané sur plusieurs apps : créez une branche par batch de features (ex: `feat/p1-batch` ou `chore/multiple-apps-cleanup`), plusieurs commits dedans, merge quand tout est prêt.
- Hotfix urgent : `hotfix/<short-desc>` mergé rapidement après test minimal.
- Batch de P1 : autoriser plusieurs commits dans une branche (ex: 3–5 P1 traités), merger quand le batch est complet et testé.

Options de merge
- **Merge standard** (`git merge --no-ff`) : conserve l'historique détaillé des commits dans `main` (recommandé si tu veux trace complète).
- **Squash merge** (`git merge --squash`) : compresse tous les commits en un seul dans `main` (plus propre si beaucoup de micro-commits).

Labels GitHub (issues/PR)
- **Quand créer** : créer les labels une fois que les premières issues utilisateurs ou collaborateurs sont ouvertes.
- **Labels recommandés** : `github_notes` (app), `bug`/`feature`/`chore`/`docs` (type), `P1`/`P2`/`P3` (priorité).
- **Règle** : toujours ajouter le label app + type + priorité si applicable.
- **Workflow simple** : extraire item de USER-NOTES.md → ajouter dans APP.md TODO → ouvrir issue si nécessaire → appliquer labels.

Conseil
- Rester simple : le but est de ne pas perdre de temps sur la gestion des branches.

Version: 1.0
Date: 2026-01-10
