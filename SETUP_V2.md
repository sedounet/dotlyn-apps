# Setup Dotlyn Apps Monorepo - Version 2

> **Date:** 2025-11-04  
> **Objectif:** Installation complète et propre des packages partagés + Design Lab  
> **Améliorations:** Correction des erreurs de la V1, standardisation des polices → Plus Jakarta Sans, Design Lab complet

---

## 🎯 Objectif

Ce setup permet de créer de zéro :
1. **Package `dotlyn_ui`** : Composants UI, thème, assets (fonts, sons)
2. **Package `dotlyn_core`** : Services, providers, utils
3. **App `design_lab`** : Vitrine complète de tous les widgets du Design System

---

## 📋 Pré-requis

- **Flutter** >= 3.0.0
- **Dart** >= 3.0.0
- **Melos** installé (`dart pub global activate melos`)
- **Git** configuré
- **VS Code** (recommandé) avec extensions Flutter/Dart

---

## ⚠️ Note importante

Ce fichier contient TOUT le code nécessaire. Copier-coller directement depuis ici.
Si des problèmes surviennent, supprimer les dossiers `packages/dotlyn_ui/lib` et `packages/dotlyn_core/lib` et recommencer.

---

## 📦 ÉTAPE 1 : Structure des dossiers

```bash
# Créer tous les dossiers nécessaires
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\theme"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\layout"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\buttons"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\inputs"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\selections"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\cards"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\feedback"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\widgets\progress"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_ui\lib\assets\fonts"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_core\lib\utils"
New-Item -ItemType Directory -Force -Path "packages\dotlyn_core\lib\providers"
New-Item -ItemType Directory -Force -Path "apps\design_lab\lib\screens"

# Copier les fonts
Copy-Item "_docs\dotlyn\polices\Satoshi_Complete\Satoshi_Complete\Fonts\TTF\Satoshi-Variable*.ttf" "packages\dotlyn_ui\lib\assets\fonts\" -Force
Copy-Item "_docs\dotlyn\polices\Plus_Jakarta_Sans\*.ttf" "packages\dotlyn_ui\lib\assets\fonts\" -Force
```

---

## 📦 ÉTAPE 2 : Package dotlyn_ui

### pubspec.yaml

**Remplacer complètement** `packages/dotlyn_ui/pubspec.yaml` :

```yaml
name: dotlyn_ui
description: Dotlyn Design System - UI Components, Theme, Assets
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  
  fonts:
    - family: PlusJakartaSans
      fonts:
        - asset: lib/assets/fonts/PlusJakartaSans-VariableFont_wght.ttf
        - asset: lib/assets/fonts/PlusJakartaSans-Italic-VariableFont_wght.ttf
          style: italic
    
    - family: Satoshi
      fonts:
        - asset: lib/assets/fonts/Satoshi-Variable.ttf
        - asset: lib/assets/fonts/Satoshi-VariableItalic.ttf
          style: italic
  
  assets:
    - lib/assets/sounds/
```

### colors.dart

Créer `packages/dotlyn_ui/lib/theme/colors.dart` :

```dart
import 'package:flutter/material.dart';

/// Couleurs Dotlyn selon le styleguide
class DotlynColors {
  DotlynColors._();

  // Primaire
  static const Color primary = Color(0xFFE36C2D); // Orange terre cuite
  
  // Secondaire
  static const Color secondary = Color(0xFF2C2C2C); // Gris anthracite
  
  // Tertiaire
  static const Color tertiary = Color(0xFFF8F8F8); // Blanc cassé
  
  // Accent
  static const Color accent = Color(0xFF3A6EA5); // Bleu acier
  
  // Variante douce
  static const Color soft = Color(0xFFEADAC0); // Beige sable
  
  // Couleurs système
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Niveaux de gris
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
}
```

### typography.dart

Créer `packages/dotlyn_ui/lib/theme/typography.dart` :

```dart
import 'package:flutter/material.dart';

/// Typographie Dotlyn selon le styleguide
/// Titres: Satoshi
/// UI/Texte: Plus Jakarta Sans
class DotlynTypography {
  DotlynTypography._();

  static const String _satoshi = 'Satoshi';
  static const String _jakarta = 'PlusJakartaSans';

  // Display
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _satoshi,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _satoshi,
    fontSize: 45,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _satoshi,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  // Headlines
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _satoshi,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _satoshi,
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _satoshi,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
```

### theme.dart

Créer `packages/dotlyn_ui/lib/theme/theme.dart` :

```dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class DotlynTheme {
  DotlynTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      colorScheme: ColorScheme.light(
        primary: DotlynColors.primary,
        secondary: DotlynColors.secondary,
        tertiary: DotlynColors.tertiary,
        error: DotlynColors.error,
        surface: DotlynColors.tertiary,
      ),
      
      textTheme: TextTheme(
        displayLarge: DotlynTypography.displayLarge,
        displayMedium: DotlynTypography.displayMedium,
        displaySmall: DotlynTypography.displaySmall,
        headlineLarge: DotlynTypography.headlineLarge,
        headlineMedium: DotlynTypography.headlineMedium,
        headlineSmall: DotlynTypography.headlineSmall,
        titleLarge: DotlynTypography.titleLarge,
        titleMedium: DotlynTypography.titleMedium,
        titleSmall: DotlynTypography.titleSmall,
        bodyLarge: DotlynTypography.bodyLarge,
        bodyMedium: DotlynTypography.bodyMedium,
        bodySmall: DotlynTypography.bodySmall,
        labelLarge: DotlynTypography.labelLarge,
        labelMedium: DotlynTypography.labelMedium,
        labelSmall: DotlynTypography.labelSmall,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: DotlynColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DotlynColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      
      scaffoldBackgroundColor: DotlynColors.tertiary,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: DotlynColors.primary,
        secondary: DotlynColors.grey200,
        tertiary: DotlynColors.grey800,
        error: DotlynColors.error,
        surface: DotlynColors.grey900,
      ),
      
      scaffoldBackgroundColor: DotlynColors.grey900,
    );
  }
}
```

### dotlyn_ui.dart (barrel file)

Créer `packages/dotlyn_ui/lib/dotlyn_ui.dart` :

```dart
library dotlyn_ui;

export 'theme/colors.dart';
export 'theme/typography.dart';
export 'theme/theme.dart';
```

---

## 📦 ÉTAPE 3 : Package dotlyn_core

### pubspec.yaml

**Remplacer complètement** `packages/dotlyn_core/pubspec.yaml` :

```yaml
name: dotlyn_core
description: Dotlyn Core - Business logic, providers, utils
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### constants.dart

Créer `packages/dotlyn_core/lib/utils/constants.dart` :

```dart
class DotlynConstants {
  DotlynConstants._();

  static const String brandName = 'DotLyn';
  static const String tagline = 'Simple, efficace, humain';
  static const String websiteUrl = 'https://dotlyn.app';
  static const String supportEmail = 'support@dotlyn.app';
}
```

### theme_provider.dart

Créer `packages/dotlyn_core/lib/providers/theme_provider.dart` :

```dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
```

### dotlyn_core.dart (barrel file)

Créer `packages/dotlyn_core/lib/dotlyn_core.dart` :

```dart
library dotlyn_core;

export 'utils/constants.dart';
export 'providers/theme_provider.dart';
```

---

## 📦 ÉTAPE 4 : Install packages

```bash
cd packages/dotlyn_ui
flutter pub get

cd ../dotlyn_core
flutter pub get

cd ../..
```

---

## 📱 ÉTAPE 5 : App Design Lab (COMPLÈTE ET STANDALONE)

### Créer l'app

```bash
cd apps
flutter create design_lab
cd design_lab
```

### pubspec.yaml

**Remplacer** `apps/design_lab/pubspec.yaml` :

```yaml
name: design_lab
description: Dotlyn Design System Showcase - APP STANDALONE POUR TESTER TOUS LES WIDGETS
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  dotlyn_ui:
    path: ../../packages/dotlyn_ui
  dotlyn_core:
    path: ../../packages/dotlyn_core
  
  provider: ^6.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
```

### main.dart

**Remplacer** `apps/design_lab/lib/main.dart` :

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
import 'screens/home_screen.dart';

void main() {
  debugPrint('🚀 Design Lab - App standalone pour tester le Design System');
  runApp(const DesignLabApp());
}

class DesignLabApp extends StatelessWidget {
  const DesignLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Design Lab - Dotlyn',
            theme: DotlynTheme.lightTheme,
            darkTheme: DotlynTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
```

### home_screen.dart (Navigation principale)

Créer `apps/design_lab/lib/screens/home_screen.dart` :

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
import 'theme_screen.dart';
import 'buttons_screen.dart';
import 'inputs_screen.dart';
import 'cards_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dotlyn Design Lab'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Design System Showcase',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Explore tous les composants Dotlyn',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          
          _MenuCard(
            title: 'Theme & Typography',
            description: 'Couleurs, fonts, styles de texte',
            icon: Icons.palette,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemeScreen()),
            ),
          ),
          
          _MenuCard(
            title: 'Buttons',
            description: 'Tous les types de boutons',
            icon: Icons.smart_button,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ButtonsScreen()),
            ),
          ),
          
          _MenuCard(
            title: 'Inputs',
            description: 'Champs de texte, formulaires',
            icon: Icons.input,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputsScreen()),
            ),
          ),
          
          _MenuCard(
            title: 'Cards',
            description: 'Cartes et containers',
            icon: Icons.credit_card,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CardsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: DotlynColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: DotlynColors.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
```

### theme_screen.dart

Créer `apps/design_lab/lib/screens/theme_screen.dart` :

```dart
import 'package:flutter/material.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme & Typography')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Couleurs', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ColorChip('Primary', DotlynColors.primary),
              _ColorChip('Secondary', DotlynColors.secondary),
              _ColorChip('Accent', DotlynColors.accent),
              _ColorChip('Success', DotlynColors.success),
              _ColorChip('Warning', DotlynColors.warning),
              _ColorChip('Error', DotlynColors.error),
            ],
          ),
          const SizedBox(height: 32),
          
          Text('Typographie', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text('Display Large (Satoshi)', style: Theme.of(context).textTheme.displayLarge),
          Text('Headline Medium (Satoshi)', style: Theme.of(context).textTheme.headlineMedium),
          Text('Title Large (Jakarta)', style: Theme.of(context).textTheme.titleLarge),
          Text('Body Large (Jakarta)', style: Theme.of(context).textTheme.bodyLarge),
          Text('Label Medium (Jakarta)', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorChip(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
```

### buttons_screen.dart

Créer `apps/design_lab/lib/screens/buttons_screen.dart` :

```dart
import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Button Types', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
          const SizedBox(height: 12),
          TextButton(onPressed: () {}, child: const Text('Text Button')),
          const SizedBox(height: 32),
          
          Text('Button Sizes', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Small'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Medium (default)')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Large'),
          ),
        ],
      ),
    );
  }
}
```

### inputs_screen.dart

Créer `apps/design_lab/lib/screens/inputs_screen.dart` :

```dart
import 'package:flutter/material.dart';

class InputsScreen extends StatelessWidget {
  const InputsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inputs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Text Fields', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Basic Input')),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(labelText: 'Multiline'),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
```

### cards_screen.dart

Créer `apps/design_lab/lib/screens/cards_screen.dart` :

```dart
import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Card Types', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Basic Card', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Contenu de la carte', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Elevated Card', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Avec elevation plus haute', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ ÉTAPE 6 : Lancer l'app

```bash
cd apps/design_lab
flutter pub get
flutter run
```

---

## 🎉 C'est terminé !

Si tout fonctionne, commit :

```bash
git add .
git commit -m "[setup] Complete dotlyn_ui, dotlyn_core and design_lab setup"
```

---

**Version** : 2.0  
**Date** : 2025-11-04  
**Status** : Prêt pour déploiement
