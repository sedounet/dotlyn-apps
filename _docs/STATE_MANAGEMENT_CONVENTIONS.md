# State Management Conventions — Dotlyn Apps

Objectif : éviter les ambiguïtés et conflits (Riverpod vs provider) rencontrés lors de l'intégration i18n.

Principes généraux
- Une app = un pattern de state management principal. Choisir `provider` OU `riverpod` pour l'app entière.
- Pour les nouvelles apps ou code refactorisé : préférer `flutter_riverpod`.
- Pour les apps legacy qui utilisent `provider` (ChangeNotifier) : garder `provider` jusqu'à migration planifiée.

Import conventions (strictes)
- Ne jamais importer les deux packages globalement sans qualification.
- Si un fichier a besoin de `provider` + `riverpod`, importer de façon sélective/qualifiée :

  - Alias / qualified import (provider usage):

    ```dart
    import 'package:provider/provider.dart' as provider;
    // usage:
    provider.ChangeNotifierProvider(create: (_) => MyProvider());
    ```

  - Riverpod import minimal (only what you need):

    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope, ConsumerWidget, WidgetRef;
    // usage:
    runApp(const ProviderScope(child: MyApp()));
    class MyApp extends ConsumerWidget { ... }
    ```

  - Alternatively use `hide`/`show` to exclude conflicting symbols:

    ```dart
    import 'package:provider/provider.dart' hide Consumer;
    import 'package:flutter_riverpod/flutter_riverpod.dart' show Consumer;
    ```

Naming & usage rules
- Préférer `provider.` prefix pour toutes les APIs provenant de `package:provider`.
- Ne pas utiliser `ChangeNotifierProvider` non qualifié si `flutter_riverpod` est aussi importé.
- Utiliser `ConsumerWidget` / `WidgetRef` pour Riverpod; `Consumer` / `Provider.of<T>(context)` pour provider.

Migration guidance (provider -> riverpod)
1. Identify boundaries: Find files using `ChangeNotifier` and those using `riverpod`.
2. Replace `ChangeNotifier` classes with `Notifier` / `AsyncNotifier` or `StateNotifier` as appropriate.
3. Create `Provider` wrappers in `providers/` and update consumers to `ref.watch(...)`.
4. Migrate incrementally per feature or screen, not whole app at once.

Quick example: converting a `ChangeNotifier` to Riverpod

- Original `provider`:
```dart
class CartProvider extends ChangeNotifier { ... }

// usage
ChangeNotifierProvider(create: (_) => CartProvider())
// consumer
Consumer<CartProvider>(builder: (context, cart, _) => Text('${cart.count}'))
```

- Riverpod equivalent:
```dart
class CartNotifier extends Notifier<CartState> { ... }
final cartProvider = NotifierProvider<CartNotifier, CartState>(() => CartNotifier());

// usage in a widget
final cart = ref.watch(cartProvider);
Text('${cart.count}');
```

CI / Lint recommendations
- Add a CI step to catch ambiguous imports and dependency conflicts early. Example script (run in CI):

```powershell
# fail if both packages imported in same file
Select-String -Path "apps/**/lib/**/*.dart" -Pattern "package:provider|flutter_riverpod" -SimpleMatch | Group-Object Path | Where-Object { $_.Count -gt 1 } | ForEach-Object { Write-Error "Ambiguous imports in $($_.Name)"; exit 1 }
```

- Add analyzer rules (in `analysis_options.yaml`) to ensure `depend_on_referenced_packages` is enforced and discourage direct SDK pins for packages managed by Flutter SDK.

Dependency management
- Avoid pinning `intl` in apps; follow `flutter_localizations` SDK version. Put `intl` in `packages/dotlyn_core` only if required and use a compatible constraint (ex: `^0.20.0`).
- Use `melos bootstrap` locally/CI to detect conflicts early.

Repository hygiene
- Keep `melos.yaml` package globs precise to avoid accidentally including duplicate package roots.
- Avoid copies of apps under `packages/` (like `packages/apps/`) unless intended as separate packages.

Checklist (pre-PR)
- [ ] Single SM pattern per app chosen (provider or riverpod)
- [ ] No file imports both packages unqualified
- [ ] `intl` constraints compatible with `flutter_localizations`
- [ ] `melos bootstrap` passes locally
- [ ] `flutter gen-l10n` runs and generated files are imported relatively

If tu veux, je peux :
- automatiser le scan qui liste tous les fichiers qui importent les deux libs (provider + riverpod) et créer une PR proposal pour `sc_loop_analyzer` qui unifie la stratégie (keep provider or migrate to Riverpod).
- ajouter le script CI dans `melos.yaml` (scripts) et documenter l'exécution.

---

Maintainer: @sedounet
Date: 2026-01-01
