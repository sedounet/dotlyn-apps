# Migration vers Riverpod — sc_loop_analyzer

Objectif: supprimer `provider` (ChangeNotifier + Consumer) et adopter `flutter_riverpod` pour tout le state management.

Phases
1) Préparer les dépendances
   - Ajouter `flutter_riverpod` à `dependencies` dans `apps/sc_loop_analyzer/pubspec.yaml`.
   - Supprimer `provider` quand tous les usages sont migrés.
2) Ajouter les providers Riverpod (wrappers temporaires)
   - Créer un fichier `lib/providers/providers.dart` avec des `ChangeNotifierProvider` (Riverpod) qui wrap les classes existantes.
   - Permettre une migration progressive des écrans sans tout réécrire immédiatement.
3) Migrer les écrans / widgets
   - Remplacer `Consumer` / `Consumer2` (package:provider) par `ConsumerWidget` + `WidgetRef` et `ref.watch(...)`.
   - Convertir les providers un par un: `ProfileProvider`, `SessionProvider`, `GameplayTypeProvider`, `ShipProvider`, `ResourceProvider`.
4) Convertir les classes de providers
   - Option A (rapide): conserver les classes `ChangeNotifier` existantes mais exposées via Riverpod `ChangeNotifierProvider`.
   - Option B (propre): réécrire chaque provider en `Notifier` / `AsyncNotifier` avec un `state` immuable.
5) Nettoyage
   - Supprimer `provider` des dépendances.
   - Retirer tous les imports `package:provider/provider.dart`.
   - Garder uniquement `flutter_riverpod` + `ProviderScope` dans `main.dart`.

Plan détaillé (réécriture conseillée)
- Profile
  - Créer `final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() => ProfileNotifier());`
  - `ProfileState`: { List<Profile> profiles, bool isLoading }
  - Notifier: expose `loadProfiles`, `addProfile`, `updateProfile`, `deleteProfile`.
- GameplayType
  - Idem structure que Profile.
- Ship
  - Idem structure que Profile.
- Resource
  - Idem structure que Profile.
- Session
  - `SessionState`: { List<Session> sessions, Profile? activeProfile, List<TimestampEntry> timestamps, int currentStep, bool isComplete, bool isLoading }
  - Notifier: startSession, recordStep, saveSession, resetSession, loadSessions.

Stratégie de migration incrémentale (sécurisée)
- Étape 0: Ajouter `flutter_riverpod` et les providers wrappers (ChangeNotifierProvider) pour permettre `ref.watch` sans casser l'existant.
- Étape 1: Migrer `main.dart` pour utiliser `ProviderScope` et injecter les providers Riverpod; adapter les écrans principaux (`HomeScreen`, `TrackingScreen`, etc.) pour consommer via `ref.watch`.
- Étape 2: Migrer chaque provider en `Notifier`/`AsyncNotifier` (Option B propre). Faire un provider à la fois + tests.
- Étape 3: Supprimer `provider` de `pubspec.yaml` + imports restants.

Tests / validation
- `melos bootstrap`
- `flutter analyze` dans `apps/sc_loop_analyzer`
- `flutter test` (ajouter des tests unitaires simples sur les notifiers migrés).

Notes
- La persistance de locale est déjà couverte par `dotlyn_core` (LocaleService + localeProvider). Une fois migration faite, on n'a plus besoin d'adapter via ChangeNotifier.

Maintainer: @sedounet
Date: 2026-01-01
