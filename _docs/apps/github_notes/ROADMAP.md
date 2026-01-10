# GitHub Notes — Roadmap

> **Objectif** : Évolution progressive de l'app avec intégration early des standards Dotlyn (analytics, localization, ads)  
> **Référence standards** : [`_docs/APP_STANDARDS.md`](../../APP_STANDARDS.md)

---

## 🎯 Vision Long Terme

**v0.1** : MVP (édition offline, sync manuel)  
**v0.2** : UX/Polish (dark theme, editor)  
**v0.3** : Early Standards (i18n + analytics + ads placeholder) ⭐ **PRIORITAIRE**  
**v0.4** : Auto-sync + conflict UI  
**v0.5** : OAuth + multi-compte  
**v1.0** : Release publique (tests, CI, polish)

---

## ✅ v0.1 — MVP (DONE)

**Date** : 2026-01-01  
**Objectif** : Édition offline + sync manuel GitHub

### Fonctionnalités
- ✅ Base de données locale (Drift) : `ProjectFiles`, `FileContents`, `AppSettings`
- ✅ CRUD fichiers markdown (ajout/édition/suppression)
- ✅ Sync manuel vers GitHub (push/pull avec SHA conflict detection)
- ✅ Stockage sécurisé du token (flutter_secure_storage)
- ✅ UI Material 3 : Files list + Editor + Settings
- ✅ Tests unitaires DB (6 tests passing)

### Livrables
- Code : `apps/github_notes/lib/`
- Tests : `apps/github_notes/test/database_test.dart`
- Docs : `APP.md`, `PITCH.md`, `USER-NOTES.md`

---

## 🚧 v0.2 — UX & Theming

**Objectif** : Dark theme complet + polish editor

### P1 (Bloquant)
- [ ] Dark theme persistant (DotlynTheme.darkTheme appliqué correctement)
- [ ] Theme switcher dans Settings avec sauvegarde en DB
- [ ] Correction des contrastes en mode sombre (couleurs texte/fond)
- [x] Theme switcher implemented and persisted (implemented on dev branch)
- [x] Replace hard-coded semantic colors with `DotlynColors` tokens

### QA Checklist (P1 completed - required verification)

- [ ] Verify theme toggle applies instantly without restart (use Settings > Theme)
- [ ] Verify saved mode persists after app restart (system/light/dark)
- [ ] Check files list screen contrast (light & dark) — text readable, buttons visible
- [ ] Check editor screen contrast (caret, selection, text color, background)
- [ ] Check Settings snackbars and icons use semantic tokens (success/error)
- [ ] Run `flutter analyze` and `flutter test` for `apps/github_notes`
- [ ] Manual smoke: run on device/emulator and toggle theme while open editor

Notes:
- Implementation added `themeModeProvider` (`apps/github_notes/lib/providers/theme_provider.dart`) and wired `MaterialApp.themeMode` to it.
- Settings now uses the provider to persist and apply changes (secure storage backed).
- A feature branch `fix/github-notes-p1-theme-switch` was created and pushed with the changes and token color fixes.


### P2 (Important)
- [ ] Scrollbar visible dans l'éditeur
- [ ] Caret aligné en haut après chargement fichier
- [ ] Markdown quick-help modal (bouton ?)
- [ ] Animations de transition (navigation screens)

### Critères de succès
- Theme toggle fonctionne et persiste après redémarrage
- Pas de problème de lisibilité en dark mode
- Éditeur fluide et confortable

---

## ⭐ v0.3 — Early Standards (i18n + Analytics + Ads)

**Objectif** : Intégrer dès maintenant les standards Dotlyn obligatoires

### P1 (Bloquant release)
- [ ] **Localization (i18n)** :
  - Ajouter `flutter_localizations` + `intl` dans `pubspec.yaml`
  - Créer `l10n/app_en.arb` et `l10n/app_fr.arb`
  - Externaliser TOUS les strings hardcodés
  - Configurer `MaterialApp.localizationsDelegates`
  - Support `en` et `fr` minimum

- [ ] **Analytics** :
  - Créer `lib/services/analytics_service.dart` (abstraction)
  - Implémenter provider analytics (Firebase Analytics ou équivalent)
  - Capturer events clés : `app_open`, `file_opened`, `file_saved`, `sync_success`, `sync_conflict`
  - Ajouter toggle opt-in/opt-out dans Settings (`analyticsEnabled` en DB)
  - Privacy : respecter le choix utilisateur

- [ ] **Ads Placeholder** :
  - Créer `lib/widgets/ad_banner_placeholder.dart`
  - Réserver espace 50-60dp en bas des screens (Files list + Editor)
  - Feature flag `showAds` (false par défaut)
  - Layout adaptable (safe area + banner height)

### P2 (Nice to have)
- [ ] Logs analytics en console (dev mode)
- [ ] Screen tracking automatique (route observer)

### Critères de succès
- Tous les textes UI sont dans les ARB files
- Changement de langue fonctionne (en/fr)
- Events analytics loggés (même si pas encore envoyés à un backend)
- Placeholder banner ne casse pas la mise en page

### Livrables
- `l10n/app_en.arb`, `l10n/app_fr.arb`
- `lib/services/analytics_service.dart`
- `lib/widgets/ad_banner_placeholder.dart`
- Update `settings_screen.dart` (analytics toggle)

---

## 🔄 v0.4 — Auto-sync & Conflict UX

**Objectif** : Améliorer workflow sync

### P1
- [ ] Auto-sync optionnel (toggle Settings + interval configurable)
- [ ] Service background sync (WorkManager / Background Fetch)
- [ ] Conflict resolution UI améliorée (diff view simple)

### P2
- [ ] Historique versions locales (snapshot avant sync)
- [ ] Retry automatique si échec réseau
- [ ] Notifications push (sync réussi/échoué)

### Critères de succès
- Auto-sync fonctionne en arrière-plan sans drain batterie
- Conflicts résolus facilement par l'utilisateur

---

## 🔐 v0.5 — OAuth & Multi-compte

**Objectif** : Remplacer token PAT par OAuth + support multi-comptes

### P1
- [ ] Implémenter OAuth GitHub flow (redirect URI + web view)
- [ ] Stockage sécurisé des tokens par compte
- [ ] Account switcher UI (dropdown Settings)
- [ ] Migration des utilisateurs existants (PAT → OAuth optionnel)

### P2
- [ ] Support organisations GitHub (accès repos orga)
- [ ] Créer PR drafts depuis l'app
- [ ] Token refresh automatique

### Critères de succès
- OAuth complète sans friction
- Multi-compte fonctionne (switch rapide)
- Tokens stockés de manière sécurisée

---

## 🚀 v1.0 — Release Publique

**Objectif** : App stable, testée, documentée, prête pour stores

### P1 (Release blockers)
- [ ] Tests unitaires complets (>80% coverage)
- [ ] Tests d'intégration (GitHub service + DB)
- [ ] CI/CD (GitHub Actions : analyze, test, build)
- [ ] Smoke tests sur devices physiques (Android + iOS)
- [ ] Privacy policy + Terms of service
- [ ] Store listings (screenshots, descriptions)
- [ ] Analytics opérationnelles (Firebase/Posthog)
- [ ] Ads SDK intégré (AdMob ou équivalent)

### P2 (Post-release)
- [ ] Widget home screen (quick add note)
- [ ] Search/filter fichiers
- [ ] Tags/labels pour organisation
- [ ] Export backup (ZIP local)

### Critères de succès
- App publiée sur Google Play + Apple App Store
- Crash-free rate > 99%
- 10+ utilisateurs actifs premiers 30 jours

---

## 📊 Métriques & KPIs

### MVP (v0.1-0.3)
- Nombre d'utilisateurs early access : 5+
- Syncs réussis / total : >90%
- Temps moyen édition → sync : <30s

### Release (v1.0)
- Utilisateurs actifs mensuels (MAU) : 50+
- Retention D7 : >30%
- Syncs réussis / total : >95%
- eCPM ads (si activées) : >$0.50

---

## 🔗 Références

- **Standards Dotlyn** : [`_docs/APP_STANDARDS.md`](../../APP_STANDARDS.md)
- **App Doc** : [`APP.md`](APP.md)
- **Pitch** : [`PITCH.md`](PITCH.md)
- **User Feedback** : [`USER-NOTES.md`](USER-NOTES.md)

---

**Version** : 1.0  
**Dernière mise à jour** : 2026-01-01  
**Maintainer** : @sedounet
