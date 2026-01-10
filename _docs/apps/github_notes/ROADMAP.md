# GitHub Notes — Roadmap

> **Vision stratégique** : Plan d'évolution long terme de l'app  
> **Référence** : Voir [`APP.md`](APP.md) pour le TODO détaillé et l'état actuel

---

## 🎯 État Actuel

**v0.2** : UX/Theme (Done 2026-01-10)  
→ Détails complets dans [`APP.md`](APP.md)

**Next** : v0.3 → Standards Dotlyn (i18n + analytics + ads)

---

## ⭐ v0.3 — Early Standards (NEXT)

**Objectif** : Intégrer standards Dotlyn obligatoires (i18n + analytics + ads placeholder)  
**Référence** : [`APP_STANDARDS.md`](../../APP_STANDARDS.md)

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

**Version** : 1.2  
**Dernière mise à jour** : 2026-01-10  
**Maintainer** : @sedounet
