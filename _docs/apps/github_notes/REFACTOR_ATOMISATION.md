# Refactoring — Atomisation du code GitHub Notes

> **Objectif** : Identifier les opportunités d'extraction et de séparation de responsabilités  
> **Date analyse** : 2026-01-10  
> **Méthode** : Préparation pour passe IA économe

---

## 📊 Analyse de complexité

### Fichiers principaux
- **file_editor_screen.dart** : 510 lignes
  - 7 méthodes privées + build()
  - Responsabilités : UI + DB + GitHub sync + auto-save
  
- **settings_screen.dart** : 618 lignes
  - 9 méthodes privées + build()
  - Responsabilités : UI + token management + file CRUD

---

## 🎯 Opportunités d'extraction

### 1. file_editor_screen.dart

#### 🔴 Priorité 1 — Méthode `_syncToGitHub()` (210+ lignes)
**Localisation** : Lines 142-350  
**Problème** : Méga-fonction avec 5 responsabilités distinctes  
**Complexité** : Gère config, fetch remote, conflict detection, push, update DB

**Extraction proposée** :
```dart
// services/sync_service.dart
class SyncService {
  Future<SyncResult> syncFile({
    required String content,
    required ProjectFile file,
    String? localSha,
  });
  
  // Private helpers
  Future<RemoteFile?> _fetchRemote();
  Future<ConflictResolution?> _showConflictDialog();
  Future<void> _pushToGitHub();
}

// models/sync_result.dart
sealed class SyncResult {
  const SyncResult();
}
class SyncSuccess extends SyncResult { final String sha; }
class SyncOffline extends SyncResult {}
class SyncConflict extends SyncResult { final String remoteSha; }
class SyncError extends SyncResult { final String message; }
```

**Bénéfices** :
- Testabilité (mock SyncService)
- Réutilisable pour batch sync futur
- Séparation UI / logique métier

---

#### 🟡 Priorité 2 — Dialogs embarqués (inline config, conflict)
**Localisation** : 
- Config dialog : Lines ~160-210
- Conflict dialog : Lines ~270-310

**Problème** : Code UI embarqué dans logique métier

**Extraction proposée** :
```dart
// widgets/sync_dialogs.dart
class ConfigDialog extends StatelessWidget {
  static Future<ProjectFile?> show(BuildContext context, ProjectFile current);
}

class ConflictDialog extends StatelessWidget {
  static Future<ConflictChoice?> show(BuildContext context, {
    required String remoteSha,
    required String localSha,
  });
}

enum ConflictChoice { cancel, fetchRemote, overwriteGitHub }
```

**Bénéfices** :
- Réutilisable dans settings_screen
- Tests widgets isolés
- Séparation responsabilités

---

#### 🟢 Priorité 3 — Auto-save logic
**Localisation** : Lines 46-52 (_scheduleAutoSave), Lines 113-140 (_saveLocal)

**Problème** : Timer + debounce mélangé avec écran

**Extraction proposée** :
```dart
// utils/auto_save_mixin.dart
mixin AutoSaveMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoSaveTimer;
  
  void scheduleAutoSave(VoidCallback callback, {Duration delay = const Duration(seconds: 2)});
  
  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

// Usage
class _FileEditorScreenState extends State<FileEditorScreen> with AutoSaveMixin {
  // ...
  onChanged: (_) => scheduleAutoSave(_saveLocal);
}
```

**Bénéfices** :
- Réutilisable dans d'autres éditeurs
- Pattern Mixin standard Flutter
- Gestion dispose automatique

---

### 2. settings_screen.dart

#### 🔴 Priorité 1 — Token management bloc
**Localisation** : Lines 55-145 (_loadToken, _saveToken, _testToken + UI section)

**Problème** : Logique token éparpillée + UI mélangée

**Extraction proposée** :
```dart
// services/token_service.dart
class TokenService {
  final FlutterSecureStorage _storage;
  final GitHubService _githubService;
  
  Future<String?> loadToken();
  Future<void> saveToken(String token);
  Future<TokenValidation> validateToken();
}

class TokenValidation {
  final bool isValid;
  final String? username;
  final String? error;
}

// widgets/token_settings_section.dart
class TokenSettingsSection extends ConsumerWidget {
  // Formulaire token isolé avec son state
}
```

**Bénéfices** :
- Service réutilisable dans onboarding futur
- Tests métier sans UI
- Widget isolé testable

---

#### 🟡 Priorité 2 — File CRUD operations
**Localisation** : Lines 146-320 (_showAddFileDialog, _showEditFileDialog, etc.)

**Problème** : 2 dialogs presque identiques avec duplication

**Extraction proposée** :
```dart
// widgets/project_file_dialog.dart
class ProjectFileDialog extends StatelessWidget {
  final ProjectFile? initialFile; // null = add mode
  static Future<ProjectFile?> show(BuildContext context, {ProjectFile? initial});
}

// services/project_file_service.dart
class ProjectFileService {
  Future<void> addFile(ProjectFileData data);
  Future<void> updateFile(int id, ProjectFileData data);
  Future<void> deleteFile(int id);
  Future<void> duplicateFile(ProjectFile source);
}
```

**Bénéfices** :
- Un seul dialog pour add/edit
- Logique CRUD centralisée
- Moins de duplication

---

#### 🟢 Priorité 3 — Theme/Language settings
**Localisation** : Lines 100-122 (_saveThemeMode, _saveLanguage)

**Problème** : Settings basiques avec boilerplate

**Extraction proposée** :
```dart
// services/app_settings_service.dart
class AppSettingsService {
  final FlutterSecureStorage _storage;
  
  Future<void> setThemeMode(ThemeMode mode);
  Future<ThemeMode> getThemeMode();
  Future<void> setLanguage(String lang);
  Future<String> getLanguage();
}
```

**Bénéfices** :
- Abstraction storage
- Testable sans secure_storage mock
- Évolutif (ajout settings facile)

---

### 3. github_service.dart

#### 🟢 Priorité 3 — Error handling duplication
**Localisation** : Répété dans fetchFile, updateFile, deleteFile

**Problème** : Try-catch identiques partout

**Extraction proposée** :
```dart
// services/github_service.dart (internal)
Future<T> _handleGitHubRequest<T>(Future<http.Response> Function() request) async {
  try {
    final response = await request();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _parseResponse<T>(response);
    }
    throw GitHubApiException(response.statusCode, _parseErrorMessage(response));
  } on SocketException {
    throw GitHubApiException(0, 'No network connection');
  } catch (e) {
    throw GitHubApiException(-1, 'Unexpected error: $e');
  }
}
```

**Bénéfices** :
- DRY (Don't Repeat Yourself)
- Error handling centralisé
- Ajout retry logic facile

---

## 📋 Plan d'action recommandé

### Phase 1 — Quick wins (1-2h)
1. ✅ Extraire ConflictDialog et ConfigDialog en widgets
2. ✅ Créer TokenService
3. ✅ Créer AppSettingsService

### Phase 2 — Refactor majeur (3-4h)
1. ✅ Créer SyncService avec SyncResult sealed class
2. ✅ Créer ProjectFileService
3. ✅ Migrer file_editor_screen vers SyncService
4. ✅ Unifier ProjectFileDialog (add/edit)

### Phase 3 — Polish (1h)
1. ✅ Extraire AutoSaveMixin
2. ✅ Refactor github_service error handling
3. ✅ Tests unitaires services

---

## 🎯 Critères de succès

**Avant** :
- file_editor_screen.dart : 510 lignes, 7 méthodes privées
- settings_screen.dart : 618 lignes, 9 méthodes privées
- Testabilité : ⚠️ difficile (UI + logique mélangées)

**Après cible** :
- file_editor_screen.dart : ~250 lignes, 3-4 méthodes privées
- settings_screen.dart : ~350 lignes, 4-5 méthodes privées
- Nouveaux fichiers : 6-8 services/widgets
- Testabilité : ✅ facile (services isolés)

**Métriques** :
- Réduction 40% lignes screens
- +200 lignes tests unitaires services
- 0 régression fonctionnelle

---

## 💡 Prompt IA suggéré (économe)

```
Context: Flutter app avec Riverpod + Drift, screens trop longs.

Task: Extraire SyncService de file_editor_screen.dart

Input files:
- apps/github_notes/lib/screens/file_editor_screen.dart (lines 142-350)
- apps/github_notes/lib/services/github_service.dart (référence API)

Output:
1. services/sync_service.dart avec SyncService class
2. models/sync_result.dart avec sealed class
3. Modifier file_editor_screen.dart pour utiliser SyncService
4. Provider Riverpod pour SyncService

Constraints:
- Garder même comportement utilisateur
- Pas de changement UI
- Tests unitaires pour SyncService
```

---

**Version** : 1.0  
**Prochaine review** : Après Phase 1 (estimer gains réels)
