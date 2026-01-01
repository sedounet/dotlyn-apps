# Secure Storage Pattern — Dotlyn Apps

## Overview

Ce guide documente le pattern standard pour stocker des données sensibles (tokens, credentials) dans les apps Dotlyn.

## Pattern Standard

### 1. Dépendance

Ajouter `flutter_secure_storage` dans `pubspec.yaml` :

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

### 2. Provider Riverpod

Créer un provider pour `FlutterSecureStorage` dans `lib/providers/` :

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});
```

### 3. Token Provider

Pour un token API (ex: GitHub), créer un `FutureProvider` :

```dart
final tokenProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return await storage.read(key: 'api_token');
});
```

### 4. Service avec Token

Injecter le token dans les services :

```dart
final apiServiceProvider = Provider<ApiService>((ref) {
  final tokenAsync = ref.watch(tokenProvider);
  return tokenAsync.when(
    data: (token) => ApiService(token: token),
    loading: () => ApiService(token: null),
    error: (_, __) => ApiService(token: null),
  );
});
```

**OU** lecture directe pour actions utilisateur :

```dart
Future<void> testToken() async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.read(key: 'api_token');
  final service = ApiService(token: token);
  // ... test
}
```

### 5. Écriture et Invalidation

Toujours invalider le provider après écriture :

```dart
Future<void> saveToken(String token) async {
  final storage = ref.read(secureStorageProvider);
  await storage.write(key: 'api_token', value: token);
  
  // Invalider pour forcer re-read
  ref.invalidate(tokenProvider);
}
```

## Checklist Sécurité

- ✅ **NE JAMAIS** commiter de tokens ou credentials
- ✅ Utiliser `flutter_secure_storage` (pas `SharedPreferences`) pour données sensibles
- ✅ Activer `encryptedSharedPreferences` sur Android
- ✅ Ajouter bouton "test token" pour valider avant usage
- ✅ Afficher erreurs utilisateur claires si token invalide
- ✅ Debug-only: bouton "show token" avec `kDebugMode` guard
- ✅ Release: retirer tout code qui affiche tokens en clair

## Exemples Réels

### GitHub Notes
- Token stocké : `github_token`
- Provider : `githubTokenProvider` (FutureProvider)
- Service : `githubServiceProvider` utilise token via provider
- UI : Settings screen avec Save/Test/Show (debug) token

### Pattern DB + Secure Storage

Si besoin de compatibilité avec DB existante :

```dart
// Écrire dans secure storage ET DB
await secureStorage.write(key: 'token', value: token);
await database.saveToken(token); // fallback legacy

// Lire priorité secure storage
final token = await secureStorage.read(key: 'token') 
    ?? await database.getToken();
```

## Troubleshooting

**Token non reconnu après save** :
- Vérifier invalidation du provider (`ref.invalidate(tokenProvider)`)
- Vérifier clé correcte (`key: 'api_token'`)

**Erreurs Android** :
- Activer `encryptedSharedPreferences: true` dans `AndroidOptions`
- Min SDK >= 23 (Android 6.0)

**Tests** :
- Mocker `FlutterSecureStorage` dans tests :

```dart
final mockStorage = MockFlutterSecureStorage();
when(mockStorage.read(key: 'token')).thenAnswer((_) async => 'test_token');
```

## Ressources

- [flutter_secure_storage package](https://pub.dev/packages/flutter_secure_storage)
- [GitHub Notes implementation](../apps/github_notes/lib/providers/github_provider.dart)

---

**Version** : 1.0  
**Date** : 2026-01-01  
**Apps utilisant ce pattern** : github_notes
