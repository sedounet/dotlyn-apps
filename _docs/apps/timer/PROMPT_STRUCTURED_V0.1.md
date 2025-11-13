# PROMPT STRUCTURÉ — Timer v0.1 MVP Core


> **Généré le** : 2025-11-12  
> **Basé sur** : PROMPTS.md (langage naturel)  
> **Statut** : READY FOR EXECUTION

---

## 🎯 OBJECTIF

Implémenter la **version 0.1 du Timer** (MVP Core) avec :
1. **Page Timer** : affichage temps restant, saisie durée (hh:mm:ss), boutons Play/Pause (toggle) + Reset
2. **Page Settings** : toggles Son et Vibration
3. **Logique timer** : countdown avec validation/correction automatique de la saisie
4. **Feedback** : son + vibration à la fin du timer

**Critère de succès** : Timer fonctionnel au premier plan pour des tâches courtes (5-30 min).

---

## 📝 INSTRUCTIONS DÉTAILLÉES

### Étape 1 : Setup projet Timer (apps/timer/)

1. Créer la structure du projet :
```
apps/timer/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── timer_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   │   ├── timer_display.dart
│   │   └── timer_controls.dart
│   ├── services/
│   │   ├── timer_service.dart (logique countdown réutilisable)
│   │   └── audio_service.dart (son + vibration)
│   ├── models/
│   │   └── timer_state.dart (enum: idle, running, paused)
│   └── providers/
│       └── timer_provider.dart (Provider state management)
├── pubspec.yaml
└── README.md
```

2. Modifier `pubspec.yaml` pour ajouter les dépendances :
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0
  audioplayers: ^5.2.0
  vibration: ^1.8.0
  shared_preferences: ^2.2.0
  dotlyn_ui:
    path: ../../packages/dotlyn_ui
  dotlyn_core:
    path: ../../packages/dotlyn_core

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

3. Copier les sons de `_docs/apps/timer/sounds/` vers `assets/sounds/` dans le dossier timer, et déclarer dans pubspec.yaml :
```yaml
flutter:
  assets:
    - assets/sounds/
```

---

### Étape 2 : Modèles et State Management

#### A. `lib/models/timer_state.dart`
```dart
enum TimerStatus {
  idle,    // Timer non démarré ou resetté
  running, // Timer en cours
  paused,  // Timer en pause
}
```

#### B. `lib/providers/timer_provider.dart`
Provider qui gère :
- État du timer (status, durée totale, temps restant en secondes)
- Actions : start(), pause(), resume(), reset()
- Validation et correction de la saisie (format hh:mm:ss)
- Écoute du countdown (met à jour toutes les secondes)

**Points clés** :
- Utiliser `Ticker` ou `Timer.periodic` pour le countdown
- Méthode `validateAndCorrectInput(String input)` qui corrige les valeurs invalides (ex: 1:65:00 → 2:05:00)
- Callback `onTimerComplete()` qui déclenche son + vibration via AudioService
- Stocker la durée par défaut : 5 minutes (00:05:00)

---

### Étape 3 : Services réutilisables

#### A. `lib/services/timer_service.dart`
Service réutilisable pour la logique de countdown (peut être extrait en package partagé plus tard).

**Fonctions** :
- `Duration parseDuration(String input)` : parse "hh:mm:ss" → Duration
- `String formatDuration(Duration duration)` : Duration → "hh:mm:ss"
- `Duration correctInvalidDuration(Duration duration, {Duration? maxDuration})` : corrige les valeurs hors limites (ex: 65 min → 1h 5min)
- `bool isValidDuration(String input)` : vérifie format basique

**Validation règles** :
- Max 12 heures (43200 secondes)
- Si minutes > 59 → ajouter aux heures, garder reste dans minutes
- Si secondes > 59 → ajouter aux minutes, garder reste dans secondes
- Si total > 12h → retourner false (afficher erreur)

#### B. `lib/services/audio_service.dart`
Service pour gérer le son et la vibration.

**Fonctions** :
- `Future<void> playSound(String soundName)` : joue un son depuis assets/sounds/
- `Future<void> vibrate()` : déclenche vibration (si activée dans settings)
- `Future<void> playTimerComplete()` : joue le son de fin + vibration (selon settings)

**Settings** :
- Récupérer depuis SharedPreferences : `sound_enabled` (bool, default true), `vibration_enabled` (bool, default true)
- Sons disponibles : `dingding.mp3` (par défaut), `pouit.mp3`

---

### Étape 4 : UI — Page Timer (timer_screen.dart)

#### Layout (de haut en bas) :
1. **AppBar** : titre "Timer" + icône ⚙️ settings (IconButton) à droite
2. **Corps (Center + Column)** :
   - Spacer pour centrer verticalement
   - **TimerDisplay widget** (TextField avec temps affiché)
   - SizedBox(height: 24)
   - **TimerControls widget** (boutons Reset + Play/Pause)
   - Spacer

#### TimerDisplay widget (`widgets/timer_display.dart`)
TextField personnalisé pour afficher et éditer la durée.

**Comportements** :
- **Idle** : TextField éditable, affiche "00:05:00" (valeur par défaut)
- **Running** : TextField en lecture seule (grisé), affiche temps restant qui décrémente
- **Paused** : TextField en lecture seule (grisé), affiche temps restant figé

**Input validation** :
- `TextInputFormatter` pour forcer format hh:mm:ss (masque avec `:`)
- `onEditingComplete` / `onSubmitted` : valider et corriger la saisie
- Si correction appliquée (ex: 1:65:00 → 2:05:00) :
  - Afficher SnackBar : "⚠️ Valeur corrigée : 02:05:00" (3 secondes)
  - Mettre à jour le TextField avec la valeur corrigée
- Si durée > 12h :
  - Afficher texte rouge sous le champ : "Durée maximale : 12h"
  - Bloquer le démarrage du timer (bouton Play désactivé)

**Styling** :
- Font : Satoshi Black, taille 56-64pt
- Couleur : DotlynColors.textPrimary (idle/paused), DotlynColors.primary (running)
- TextAlign: center

#### TimerControls widget (`widgets/timer_controls.dart`)
Row avec 2 boutons alignés horizontalement.

**Boutons** :
1. **Reset** (à gauche) :
   - IconButton avec icône "restart" (Remix Icon : ri-restart-line)
   - Couleur : gris (DotlynColors.grey600)
   - Désactivé (grisé) si status == running
   - Action : reset le timer à la durée initiale, status → idle
   
2. **Play/Pause toggle** (à droite) :
   - IconButton avec icône qui change :
     - Idle/Paused : Play icon (▶️) + couleur orange (DotlynColors.primary)
     - Running : Pause icon (⏸️) + couleur gris (DotlynColors.grey700)
   - Action : toggle entre start/pause/resume

**Spacing** : MainAxisAlignment.spaceEvenly ou spaceBetween (tester accessibilité une main)

**Taille boutons** : IconButton avec iconSize: 48 (gros, accessible)

---

### Étape 5 : UI — Page Settings (settings_screen.dart)

#### Layout :
1. **AppBar** : titre "Paramètres" + bouton retour auto (Navigator.pop)
2. **ListView** avec 2 items :

**Item 1 : Son de fin**
- ListTile avec :
  - Leading : Icon son (ri-volume-up-line)
  - Title : "Son de fin"
  - Trailing : Switch (toggle on/off)
- Valeur stockée dans SharedPreferences : `sound_enabled` (bool, default true)

**Item 2 : Vibration de fin**
- ListTile avec :
  - Leading : Icon vibration (ri-smartphone-line)
  - Title : "Vibration de fin"
  - Trailing : Switch (toggle on/off)
- Valeur stockée dans SharedPreferences : `vibration_enabled` (bool, default true)

**Styling** :
- Respecter le thème Dotlyn (couleurs, typo)
- Switch activeColor : DotlynColors.primary

---

### Étape 6 : main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'providers/timer_provider.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerProvider(),
      child: MaterialApp(
        title: 'Dotlyn Timer',
        theme: DotlynTheme.lightTheme,
        darkTheme: DotlynTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const TimerScreen(),
      ),
    );
  }
}
```

---

### Étape 7 : Tests manuels

1. Lancer l'app sur émulateur :
```powershell
cd apps/timer
flutter run
```

2. **Test cas nominal** :
   - Saisir "00:10:00" → Play → observer le décompte
   - Pause → vérifier que le temps se fige
   - Play → vérifier la reprise
   - Reset → vérifier retour à 00:10:00

3. **Test correction auto** :
   - Saisir "00:65:00" → quitter le champ → vérifier SnackBar + correction vers "01:05:00"
   - Saisir "01:75:90" → vérifier correction vers "02:16:30"

4. **Test limite 12h** :
   - Saisir "13:00:00" → vérifier texte rouge "Durée maximale : 12h"
   - Vérifier que le bouton Play est désactivé

5. **Test fin de timer** :
   - Saisir "00:00:05" → Play → attendre 5 secondes
   - Vérifier son + vibration (selon settings)

6. **Test Settings** :
   - Naviguer vers Settings
   - Toggle Son → relancer timer → vérifier son désactivé
   - Toggle Vibration → relancer timer → vérifier vibration désactivée

---

## 🎨 CONTRAINTES DESIGN

### Styleguide Dotlyn (à respecter STRICTEMENT)

**Couleurs** :
- Primary (orange) : `DotlynColors.primary` (#E36C2D) → bouton Play
- Grey : `DotlynColors.grey600` / `grey700` → Pause, Reset
- Text : `DotlynColors.textPrimary` / `textSecondary`
- Error : `DotlynColors.error` → texte erreur ">12h"
- Success : `DotlynColors.success` → validation (optionnel)

**Typographie** :
- Timer display : **Satoshi Black**, 56-64pt
- Titres (AppBar) : **Satoshi Bold**, 20pt
- Labels settings : **Manrope Medium**, 16pt

**Icônes** :
- **Remix Icon uniquement** (via package `remix_icon_icons` ou assets custom)
- Play : ri-play-fill
- Pause : ri-pause-fill
- Reset : ri-restart-line
- Settings : ri-settings-3-line
- Son : ri-volume-up-line
- Vibration : ri-smartphone-line

**Spacing** :
- Padding général : 16-24px
- Entre éléments : 16px (SizedBox)
- Boutons : iconSize 48 (accessibilité)

**Accessibilité** :
- Boutons en bas (zone pouce, une main)
- Contraste texte/fond respectant WCAG AA (déjà géré par DotlynColors)

---

## 🧩 DÉPENDANCES & PACKAGES

**Ajouter dans `apps/timer/pubspec.yaml`** :
```yaml
dependencies:
  provider: ^6.1.0          # State management
  audioplayers: ^5.2.0      # Son
  vibration: ^1.8.0         # Vibration
  shared_preferences: ^2.2.0 # Settings persistants
  dotlyn_ui:                # Theme + assets
    path: ../../packages/dotlyn_ui
  dotlyn_core:              # Utils
    path: ../../packages/dotlyn_core
```

**Commandes** :
```powershell
cd apps/timer
flutter pub get
flutter analyze
```

---

## ✅ CRITÈRES DE VALIDATION

### Code Quality
- [ ] `flutter analyze` = 0 issues
- [ ] Code lint-free (respecte `analysis_options.yaml`)
- [ ] Aucun warning dans la console

### Fonctionnel
- [ ] Timer démarre et décrémente correctement
- [ ] Play/Pause toggle fonctionne
- [ ] Reset fonctionne uniquement en pause
- [ ] Correction auto s'applique (ex: 1:65:00 → 2:05:00)
- [ ] SnackBar s'affiche lors de correction
- [ ] Limite 12h bloque le démarrage + affiche erreur
- [ ] Son de fin joue (si activé dans settings)
- [ ] Vibration de fin fonctionne (si activée dans settings)
- [ ] Settings persistent entre sessions (SharedPreferences)

### UI/UX
- [ ] Layout respecte le styleguide Dotlyn
- [ ] Couleurs correctes (orange Play, gris Pause/Reset)
- [ ] Typo correcte (Satoshi Black pour timer)
- [ ] Icônes Remix Icon utilisées
- [ ] Accessibilité une main (boutons en bas)
- [ ] Pas de overflow/RenderFlex errors
- [ ] Navigation Settings ↔ Timer fluide

### Documentation
- [ ] README.md créé dans `apps/timer/`
- [ ] `_docs/apps/timer/APP.md` mis à jour (v0.1 coché)
- [ ] Code commenté (services, validations)

---

## 🚨 POINTS D'ATTENTION

### 1. Validation TextField (critique)
- Utiliser un `TextInputFormatter` custom pour forcer le format hh:mm:ss
- Ne PAS permettre de taper des lettres (clavier numérique uniquement)
- Gérer le cas où l'utilisateur supprime le contenu (revenir à "00:00:00" par défaut)

### 2. Correction automatique (UX critique)
- La SnackBar doit apparaître **pendant** la saisie si une valeur dépasse le max (ex: "65" dans minutes)
- Message : "⚠️ La valeur sera corrigée"
- Quand l'utilisateur quitte le champ → appliquer la correction + SnackBar final : "✓ Temps corrigé : 02:05:00"
- **Attention** : deux SnackBars possibles (avertissement pendant, confirmation après)

### 3. Timer countdown (performance)
- Utiliser `Timer.periodic(Duration(seconds: 1), ...)` et non `Ticker` (plus simple pour v0.1)
- Annuler le timer dans `dispose()` du Provider
- Tester avec des durées longues (30+ min) pour vérifier la précision

### 4. Son + Vibration
- Précharger le son dans `initState()` pour éviter les lags à la fin du timer
- Vérifier les permissions Android pour vibration (normalement auto avec package `vibration`)
- Tester sur device réel si possible (émulateur peut ne pas vibrer)

### 5. SharedPreferences
- Charger les settings au démarrage de l'app (`main.dart` ou `TimerProvider` init)
- Sauvegarder immédiatement lors du toggle dans Settings (pas besoin de bouton "Sauvegarder")

### 6. Réutilisabilité (anticiper v0.2+)
- `TimerService` doit être **stateless** et réutilisable (fonctions pures)
- `AudioService` peut être extrait en package partagé (`dotlyn_core`) plus tard
- Penser à externaliser la logique de validation (peut servir pour Pomodoro/Tabata)

### 7. Tests sur émulateur
- L'émulateur Android peut ne pas jouer les sons correctement (vérifier volume système)
- La vibration ne fonctionne pas sur émulateur iOS (normal)
- Tester en priorité le countdown et la validation (core feature)

---

## 📦 FICHIERS À CRÉER / MODIFIER

### Créer (apps/timer/)
```
lib/
  main.dart
  models/
    timer_state.dart
  providers/
    timer_provider.dart
  services/
    timer_service.dart
    audio_service.dart
  screens/
    timer_screen.dart
    settings_screen.dart
  widgets/
    timer_display.dart
    timer_controls.dart
assets/
  sounds/
    dingding.mp3 (copier depuis _docs/apps/timer/sounds/)
    pouit.mp3 (copier depuis _docs/apps/timer/sounds/)
pubspec.yaml
README.md
```

### Modifier
```
_docs/apps/timer/APP.md
  → Cocher les items de la section "v0.1 — MVP Core"
  → Ajouter notes si bugs découverts
```

---

## 🔗 RÉFÉRENCES

### Documentation packages
- Provider : https://pub.dev/packages/provider
- audioplayers : https://pub.dev/packages/audioplayers
- vibration : https://pub.dev/packages/vibration
- shared_preferences : https://pub.dev/packages/shared_preferences

### Design
- Styleguide Dotlyn : `_docs/dotlyn/STYLEGUIDE.md`
- Remix Icons : https://remixicon.com/

### Projet
- APP.md : `_docs/apps/timer/APP.md`
- PITCH.md : `_docs/apps/timer/PITCH.md`
- Copilot instructions : `.github/copilot-instructions.md`

---

## 🤖 PROMPT FINAL POUR GPT-4

```
Tu es un expert Flutter travaillant sur le monorepo dotlyn-apps.

CONTEXTE :
- App : Timer (apps/timer/)
- Version : v0.1 MVP Core
- Packages partagés : dotlyn_ui (theme, fonts), dotlyn_core (utils)
- State management : Provider
- Styleguide : _docs/dotlyn/STYLEGUIDE.md
- Convention commits : [timer] type: description

OBJECTIF :
Implémenter la version 0.1 du Timer (MVP Core) avec :
1. Page Timer : TextField durée (hh:mm:ss) + boutons Play/Pause (toggle) + Reset
2. Page Settings : toggles Son et Vibration
3. Logique countdown avec validation/correction automatique
4. Son + vibration à la fin

INSTRUCTIONS :
[Voir section "INSTRUCTIONS DÉTAILLÉES" ci-dessus]

CONTRAINTES DESIGN :
- Couleurs : DotlynColors.primary (orange #E36C2D) pour Play, gris pour Pause/Reset
- Typo : Satoshi Black 56-64pt pour timer display, Manrope pour labels
- Icônes : Remix Icon uniquement
- Layout : TextField + boutons en bas (accessibilité une main)
- TextField affiche le décompte (pas de redondance)

DÉPENDANCES :
- provider: ^6.1.0
- audioplayers: ^5.2.0
- vibration: ^1.8.0
- shared_preferences: ^2.2.0
- dotlyn_ui (local)
- dotlyn_core (local)

CRITÈRES DE VALIDATION :
- flutter analyze = 0 issues
- Timer fonctionne avec Play/Pause/Reset
- Correction auto (ex: 1:65:00 → 2:05:00) + SnackBar
- Limite 12h avec erreur affichée
- Son + vibration de fin (selon settings)
- Settings persistent entre sessions

POINTS D'ATTENTION :
- SnackBar apparaît pendant saisie si valeur dépasse max ("La valeur sera corrigée")
- SnackBar final après correction ("Temps corrigé : 02:05:00")
- Reset désactivé si timer running
- Précharger le son pour éviter lags
- Timer.periodic pour countdown (simple, suffisant pour v0.1)
- Penser réutilisabilité : TimerService stateless, AudioService extractible

FICHIERS À CRÉER :
[Voir section "FICHIERS À CRÉER / MODIFIER" ci-dessus]

WORKFLOW :
1. Créer structure projet (dossiers + fichiers)
2. Implémenter models + services
3. Implémenter Provider (state management)
4. Implémenter UI (screens + widgets)
5. Tester manuellement (cas nominal + edge cases)
6. Analyser (flutter analyze)
7. Mettre à jour _docs/apps/timer/APP.md
8. Commit : "[timer] feat: implement v0.1 MVP Core (UI + countdown + settings)"

Respecte STRICTEMENT les conventions du fichier .github/copilot-instructions.md.
Ne crée PAS de fichier TODO.md séparé.
Utilise UNIQUEMENT les polices Satoshi/Manrope et les icônes Remix Icon.
Mets à jour _docs/apps/timer/APP.md section v0.1.
```

---

**Statut** : ✅ READY FOR EXECUTION  
**Généré le** : 2025-11-12  
**Validé par** : [À remplir après validation]
