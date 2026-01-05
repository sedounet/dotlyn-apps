Raptor mini (Preview) — Plan de travail automatisé pour `github_notes`

## Objectif 🎯
Préparer et exécuter une série de refactors pour améliorer la maintenabilité, testabilité et qualité du code de l'app `github_notes`. Les refactors doivent être petits, testés et itératifs afin de réduire le risque (petites PRs).

---

## Contexte
- Basé sur l'audit rapide réalisé (settings, add/edit forms, GitHub service, file_card, providers).
- Priorités initiales : extraire le formulaire Add/Edit, isoler la vérification GitHub, déplacer la logique DB/GitHub hors des Widgets, et ajouter des tests.

---

## Tâches (priorisées) ✅
1. [P1] **(DONE)** Extraire le formulaire Add/Edit dans `lib/widgets/project_file_form.dart` (ProjectFileForm)
   - Description : Reusable form for `owner/repo/path/nickname` with validators and returns `ProjectFileData` on submit.
   - Done: Widget added, **2 widget tests** added (`validation shows errors` + `submits when valid`), tests pass locally.
   - Branch: `feat/githubnotes-refactor-form` — merged (2026-01-03).

2. [P1] **(TODO - lightweight)** Extraire la logique "check file exists on GitHub" dans un service testable (`lib/services/file_check_service.dart` or extend `lib/services/github_service.dart`)
   - Description : method `Future<FileCheckResult> checkFileExists(owner, repo, path)` that returns `{exists, statusCode, message}` or throws controlled exceptions. **Implementation to remain minimal:** no heavy retry/backoff logic; focus on clear mapping of HTTP statuses and network errors.
   - Goal: minimally testable (mock HTTP), cover 200 / 404 / 401/403 / 5xx and network unreachable cases. Keep API small and easy to review.
   - Estimation : 0.5 day (light)

3. [P1] **(TODO)** Créer un `ProjectFilesNotifier` (Riverpod Notifier)
   - Description : move `addProjectFile`, `updateProjectFile`, `deleteProjectFile` and GitHub interactions into a Notifier with unit tests (Drift in-memory DB).
   - Goal: remove direct DB calls from UI, simplify widget tests, avoid `use_build_context_synchronously` patterns.
   - Estimation : 1 day

4. [P2] Remplacer le formulaire ad-hoc par `Form` + `TextFormField` + validators
   - Avantages : validation déclarative, messages d'erreur affichés automatiquement.
   - Estimation : 0.5 jour

5. [P2] Introduire des tests unitaires
   - Tests pour : `GitHubService` (mock HTTP), `ProjectFilesNotifier` (Drift in-memory DB), widget tests pour le formulaire/dialog.
   - Estimation : 2-3 jours

6. [P3] i18n : ARB en/fr pour toutes les nouvelles chaînes UI liées aux settings & dialog
   - Avantages : conforme `APP_STANDARDS`, prêt pour release multi-langue.
   - Estimation : 1 jour

7. [P3] Petits nettoyages : enums pour actions popup (avoid magic strings), centraliser SnackBar util, supprimer imports inutiles
   - Estimation : 0.5 jour

---

## Critères de succès ✅
- Chaque PR passe : `flutter analyze`, `dart format`, tests unitaires locaux.
- Le formulaire Add/Edit est testé (widget tests) et fonctionne identiquement (UX inchangée si non demandé autrement).
- Le service de vérification GitHub est mockable et a des tests couvrant 200 / 404 / 5xx.
- Les operations DB (add/update/delete) sont découpées dans un Notifier testé.
- Pas de régressions visuelles et `flutter analyze` est clean.

---

## Artefacts à produire
- `lib/widgets/project_file_form.dart` (widget réutilisable)
- `lib/services/file_check_service.dart` (ou ajout à `GitHubService`)
- `lib/providers/project_files_notifier.dart` (Riverpod Notifier)
- Tests : `test/services/file_check_service_test.dart`, `test/providers/project_files_notifier_test.dart`, `test/widgets/project_file_form_test.dart`
- Mise à jour de `_docs/apps/github_notes/APP.md` (TODOs et statut)

---

## Plan d'exécution & étapes immédiates (ordre recommandé)
1. Créer la branche `feat/githubnotes-refactor-form` → Extraire `project_file_form` et écrire 1-2 widget tests.
2. PR petite, review + merge.
3. Créer la branche `feat/githubnotes-filecheck-service` → extraire la vérification GitHub, ajouter tests (mock HTTP).
4. PR, review + merge.
5. Créer `feat/githubnotes-notifier` → déplacer add/update/delete dans un Notifier, modifier UI pour appeler Notifier.
6. Ajouter tests d'intégration Drift (in-memory) et tests widget pour dialogs.
7. Clean up : enums/actions, utilities, i18n.

---

## Estimations & Priorités
- P1 (High): Extraire Form / FileCheck / Notifier — haute valeur, faible/medium risque.
- P2 (Medium): Validators + Tests + Cleanup.
- P3 (Low): i18n + UX optims + improvements.

---

## Notes spécifiques
- Toutes les modifications doivent respecter les conventions Dotlyn (imports `dotlyn_ui`, theming, tests, `flutter pub run build_runner` si nécessaire).
- Conserver l'UX visible par défaut; tout changement UX doit être listé dans la PR description et validé par revue.

---

## Next step (automatisé par Raptor mini)
- Raptor mini: créer la première PR `feat/githubnotes-refactor-form` qui extrait `project_file_form` et ajoute 2 widget tests minimalistes (valid submission + validation error). Attendre validation humaine avant poursuivre.

---

*Fait le : 2026-01-03*  
*Auteur automatique : Raptor mini (Preview)*
