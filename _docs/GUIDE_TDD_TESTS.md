# Guide TDD & Tests pour Flutter

> **Audience** : Débutants en testing  
> **Contexte** : Monorepo Dotlyn Apps  
> **Dernière mise à jour** : 2025-11-29

---

## 🎯 Pourquoi Tester ?

### Le Problème Sans Tests
```dart
// Tu codes une feature
void calculateTotal(List<int> items) {
  return items.reduce((a, b) => a + b);
}

// 2 semaines plus tard, tu modifies le code
void calculateTotal(List<int> items) {
  if (items.isEmpty) return 0; // Fix bug
  return items.reduce((a, b) => a + b);
}

// ❌ Mais maintenant, une autre partie de l'app crash
// parce qu'elle attendait null, pas 0
```

### Avec Tests
```dart
test('calculate total avec liste vide retourne 0', () {
  expect(calculateTotal([]), 0);
});

// Si tu casses quelque chose, le test échoue IMMÉDIATEMENT
// ✅ Tu corriges AVANT de push
```

**TL;DR** : Les tests = filet de sécurité pour éviter de casser ton code.

---

## 📚 Types de Tests (du + Simple au + Complexe)

### 1️⃣ Tests Unitaires (Unit Tests)
**Quoi** : Tester UNE fonction isolée.  
**Quand** : Logique métier, calculs, parsing, validation.  
**Vitesse** : ⚡ Très rapide (millisecondes).

```dart
// lib/services/timer_service.dart
class TimerService {
  Duration parseDuration(String input) {
    final seconds = int.parse(input);
    return Duration(seconds: seconds);
  }
}

// test/services/timer_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:timer/services/timer_service.dart';

void main() {
  group('TimerService', () {
    late TimerService service;

    setUp(() {
      service = TimerService(); // Créé avant chaque test
    });

    test('parse 60 secondes en 1 minute', () {
      final result = service.parseDuration('60');
      expect(result.inMinutes, 1);
    });

    test('parse string vide throw exception', () {
      expect(
        () => service.parseDuration(''),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
```

**Commande** : `flutter test test/services/timer_service_test.dart`

---

### 2️⃣ Tests de Widget (Widget Tests)
**Quoi** : Tester l'UI d'un widget sans lancer l'app complète.  
**Quand** : Vérifier qu'un bouton s'affiche, qu'un texte change, qu'un tap fonctionne.  
**Vitesse** : 🚀 Rapide (secondes).

```dart
// lib/widgets/timer_button.dart
class TimerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const TimerButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// test/widgets/timer_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timer/widgets/timer_button.dart';

void main() {
  testWidgets('TimerButton affiche le label correct', (tester) async {
    // Arrange : créer le widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerButton(
            label: 'Start',
            onPressed: () {},
          ),
        ),
      ),
    );

    // Assert : vérifier que le texte s'affiche
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('TimerButton appelle onPressed au tap', (tester) async {
    // Arrange
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimerButton(
            label: 'Start',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    // Act : simuler un tap
    await tester.tap(find.text('Start'));
    await tester.pump(); // Rebuild après le tap

    // Assert
    expect(pressed, true);
  });
}
```

**Commande** : `flutter test test/widgets/timer_button_test.dart`

---

### 3️⃣ Tests d'Intégration (Integration Tests)
**Quoi** : Tester l'app ENTIÈRE sur un vrai device/émulateur.  
**Quand** : Scénarios utilisateur complets (démarrer timer, aller dans settings, etc.).  
**Vitesse** : 🐢 Lent (minutes).

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:timer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Scénario complet : démarrer et arrêter timer', (tester) async {
    // Lancer l'app
    app.main();
    await tester.pumpAndSettle();

    // Vérifier écran initial
    expect(find.text('00:00:00'), findsOneWidget);

    // Taper sur le bouton pour ouvrir saisie durée
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Entrer 10 secondes
    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Démarrer le timer
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();

    // Attendre 2 secondes et vérifier que le timer compte
    await tester.pump(Duration(seconds: 2));
    expect(find.text('00:00:08'), findsOneWidget);

    // Arrêter le timer
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pumpAndSettle();
  });
}
```

**Commande** : `flutter test integration_test/app_test.dart`

---

## 🔴 TDD (Test-Driven Development)

### Principe : RED → GREEN → REFACTOR

#### Étape 1 : RED (Écrire un test qui échoue)
```dart
// test/services/timer_service_test.dart
test('formatDuration convertit 125s en "00:02:05"', () {
  final result = service.formatDuration(Duration(seconds: 125));
  expect(result, '00:02:05');
});

// ❌ Test échoue : formatDuration n'existe pas encore
```

#### Étape 2 : GREEN (Écrire le code minimal pour passer le test)
```dart
// lib/services/timer_service.dart
String formatDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final mins = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$hours:$mins:$secs';
}

// ✅ Test passe
```

#### Étape 3 : REFACTOR (Améliorer le code sans casser le test)
```dart
String formatDuration(Duration duration) {
  // Refacto : extraire la logique de padding
  String pad(int value) => value.toString().padLeft(2, '0');
  
  return '${pad(duration.inHours)}:'
         '${pad(duration.inMinutes.remainder(60))}:'
         '${pad(duration.inSeconds.remainder(60))}';
}

// ✅ Test passe toujours
```

### Avantages TDD
✅ Tu codes SEULEMENT ce qui est nécessaire  
✅ Tu as des tests pour TOUT  
✅ Tu refactores sans peur de casser  
✅ Tu documentes ton code via les tests

---

## 🛠️ Setup Tests dans Dotlyn Apps

### Structure Fichiers
```
apps/timer/
├── lib/
│   ├── main.dart
│   ├── services/
│   │   └── timer_service.dart
│   └── widgets/
│       └── timer_button.dart
├── test/                         ← Tests unitaires et widget
│   ├── services/
│   │   └── timer_service_test.dart
│   └── widgets/
│       └── timer_button_test.dart
└── integration_test/             ← Tests d'intégration
    └── app_test.dart
```

### Dépendances (pubspec.yaml)
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.0           # Pour mocker des dépendances
  build_runner: ^2.4.0      # Pour générer les mocks
```

### Commandes
```bash
# Lancer tous les tests
flutter test

# Lancer un fichier spécifique
flutter test test/services/timer_service_test.dart

# Lancer avec coverage (voir % de code testé)
flutter test --coverage

# Lancer tests d'intégration
flutter test integration_test/app_test.dart
```

---

## 🎓 Exercices Pratiques (Timer App)

### Exercice 1 : Test Unitaire Simple
**Objectif** : Tester `TimerService.correctInvalidDuration`

```dart
// Contexte : Si l'utilisateur entre "99:99:99", corriger en "99:99:59"
// (les secondes ne peuvent pas dépasser 59)

// Étape 1 : Écrire le test
test('correctInvalidDuration corrige 99:99:99 en 99:99:59', () {
  final input = Duration(hours: 99, minutes: 99, seconds: 99);
  final result = service.correctInvalidDuration(input);
  
  expect(result.hours, 99);
  expect(result.minutes, 99);
  expect(result.seconds, 59);
});

// Étape 2 : Implémenter la fonction pour passer le test
Duration correctInvalidDuration(Duration input) {
  int hours = input.inHours;
  int minutes = input.inMinutes.remainder(60);
  int seconds = input.inSeconds.remainder(60);
  
  // Corriger si secondes > 59
  if (seconds > 59) seconds = 59;
  
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}
```

---

### Exercice 2 : Test Widget avec Interaction
**Objectif** : Tester le `TimerDisplay` qui affiche le temps restant

```dart
// lib/widgets/timer_display.dart
class TimerDisplay extends StatelessWidget {
  final Duration duration;
  
  const TimerDisplay({required this.duration});
  
  @override
  Widget build(BuildContext context) {
    final formatted = formatDuration(duration);
    return Text(formatted, style: TextStyle(fontSize: 48));
  }
  
  String formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:'
           '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
           '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

// test/widgets/timer_display_test.dart
testWidgets('TimerDisplay affiche 00:02:05 pour 125 secondes', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: TimerDisplay(duration: Duration(seconds: 125)),
      ),
    ),
  );
  
  expect(find.text('00:02:05'), findsOneWidget);
});
```

---

### Exercice 3 : Test avec Mock (Niveau Intermédiaire)
**Objectif** : Tester `TimerProvider` sans vraiment attendre

```dart
// On veut tester que le timer décrémente sans attendre 1 seconde réelle

// 1. Créer un mock de Timer
class MockTimer extends Mock implements Timer {}

// 2. Injecter le mock dans TimerProvider
test('timer décrémente chaque seconde', () async {
  final provider = TimerProvider();
  
  // Démarrer avec 10 secondes
  provider.start(Duration(seconds: 10));
  
  // Simuler 3 ticks (3 secondes)
  await Future.delayed(Duration.zero); // Laisser Flutter traiter
  expect(provider.remaining.inSeconds, 10);
  
  // Avancer le temps de 3 secondes (avec fake timer)
  // Note : nécessite d'utiliser fakeAsync pour contrôler le temps
});
```

---

## 📊 Mesurer la Couverture de Code (Coverage)

### Générer le Rapport
```bash
# Lancer tests avec coverage
flutter test --coverage

# Générer un rapport HTML lisible
genhtml coverage/lcov.info -o coverage/html

# Ouvrir dans le navigateur
start coverage/html/index.html  # Windows
open coverage/html/index.html   # macOS/Linux
```

### Interpréter
- **80%+** : Très bon
- **60-80%** : Acceptable
- **< 60%** : Insuffisant

**⚠️ Attention** : 100% coverage ≠ 0 bugs. C'est une métrique, pas une garantie.

---

## ✅ Checklist Tests pour Timer v0.2

### Tests Unitaires Essentiels
- [ ] `TimerService.parseDuration` avec inputs valides/invalides
- [ ] `TimerService.formatDuration` avec différentes durées
- [ ] `TimerService.correctInvalidDuration` avec edge cases
- [ ] `AlarmService.scheduleTimer` (mock AndroidAlarmManager)
- [ ] `NotificationService.showTimerComplete` (mock plugin)

### Tests Widget Essentiels
- [ ] `TimerDisplay` affiche le bon format
- [ ] `TimerButton` appelle le bon callback
- [ ] `DurationInputSheet` valide les inputs
- [ ] `SettingsScreen` sauvegarde les préférences

### Tests d'Intégration Essentiels
- [ ] Scénario : Démarrer timer 10s → attendre → vérifier notification
- [ ] Scénario : Démarrer → pause → reprendre → terminer
- [ ] Scénario : Aller dans settings → désactiver son → vérifier

---

## 🚀 Workflow TDD Recommandé

### Pour une Nouvelle Feature
1. **Écrire le test qui échoue** (RED)
   ```bash
   flutter test test/services/my_service_test.dart
   # ❌ Expected: 42, Actual: null
   ```

2. **Écrire le code minimal** (GREEN)
   ```bash
   flutter test test/services/my_service_test.dart
   # ✅ All tests passed!
   ```

3. **Refactorer si besoin** (REFACTOR)
   ```bash
   flutter test  # Relancer TOUS les tests
   # ✅ All tests passed!
   ```

4. **Commit avec les tests**
   ```bash
   git add .
   git commit -m "[timer] feat: add feature X with tests"
   ```

---

## 📚 Ressources

### Docs Officielles
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Tutoriels Vidéo
- [Flutter Testing for Beginners (Fireship)](https://www.youtube.com/watch?v=j-27FZiTBFw)
- [TDD in Flutter (Reso Coder)](https://resocoder.com/flutter-clean-architecture-tdd/)

### Packages Utiles
- `mockito` : Mocker des dépendances
- `fake_async` : Contrôler le temps dans les tests
- `golden_toolkit` : Tests visuels (screenshots)

---

## 🎯 Prochaines Étapes

1. **Semaine 1** : Écrire 3 tests unitaires pour `TimerService`
2. **Semaine 2** : Écrire 2 tests widget pour `TimerDisplay` et `TimerButton`
3. **Semaine 3** : Écrire 1 test d'intégration pour le scénario principal
4. **Semaine 4** : Viser 70% de coverage pour `lib/services/`

---

**Version** : 1.0  
**Auteur** : Dotlyn Apps  
**Feedback** : Ouvrir une issue GitHub si questions
