# Timer - Instructions AI# Timer - Instructions AI



> **Note** : Fichier généré par Copilot à partir de PROMPT_USER.md.  > **Note** : Fichier généré par Copilot à partir de PROMPT_USER.md.  

> Supprimé ou réécrit à chaque nouvelle demande.> Supprimé ou réécrit à chaque nouvelle demande.



------



## 🎯 Objectif## Objectif



Résoudre deux problèmes UX critiques du Timer :<!-- Résumé de la demande utilisateur en une phrase -->

1. **Arrêter la sonnerie** : Aucun moyen d'arrêter le son à la fin du timer (obligé de quitter l'app)

2. **Saisie durée intuitive** : Input actuel trop complexe (sélectionner/effacer chaque segment hh:mm:ss)



------



## 📋 Tâches## Tâches



### Tâche 1 : Bouton "Arrêter la sonnerie" (P1 - Critique)<!-- Liste des actions concrètes à réaliser -->



**Problème** : Quand le timer atteint 0, le son joue en boucle sans contrôle utilisateur.- [ ] 

- [ ] 

**Solution** :- [ ] 

- [ ] Ajouter un **Dialog** (AlertDialog) qui s'affiche automatiquement quand `remaining == 0`

- [ ] Dialog contient :---

  - **Titre** : "⏰ Timer terminé !"

  - **Message** : "Votre session est terminée"## Contexte technique

  - **Bouton principal** : "Arrêter" (gros, orange, pleine largeur)

  - **Bouton secondaire** (optionnel) : "Relancer" (petit, gris)<!-- Fichiers concernés, dépendances, points d'attention -->

- [ ] Cliquer "Arrêter" → stop le son + ferme dialog + reset timer à idle

- [ ] Dialog **barrierDismissible: false** (pas de fermeture en tapant à côté)

- [ ] Son s'arrête automatiquement après **30 secondes** si pas de clic (fallback)

---

**Fichiers à modifier** :

- `apps/timer/lib/providers/timer_provider.dart` : Ajouter flag `_showCompletionDialog`## Critères de succès

- `apps/timer/lib/screens/timer_screen.dart` : Listener sur flag + showDialog()

- `apps/timer/lib/services/audio_service.dart` : Ajouter méthode `stopSound()`<!-- Comment savoir que c'est terminé ? -->



**Détails implémentation** :- 

```dart- 

// timer_provider.dart- 

bool _showCompletionDialog = false;

bool get showCompletionDialog => _showCompletionDialog;---



void _onTimerComplete() {**Généré le** : [Date]  

  _status = TimerStatus.idle;**À partir de** : PROMPT_USER.md

  _showCompletionDialog = true;

  _audioService.playTimerComplete();
  notifyListeners();
  
  // Auto-stop après 30s
  Future.delayed(Duration(seconds: 30), () {
    if (_showCompletionDialog) {
      dismissCompletionDialog();
    }
  });
}

void dismissCompletionDialog() {
  _showCompletionDialog = false;
  _audioService.stopSound();
  notifyListeners();
}

// audio_service.dart
void stopSound() {
  _audioPlayer.stop();
}
```

```dart
// timer_screen.dart (dans build)
// Écouter le flag avec Consumer
Consumer<TimerProvider>(
  builder: (context, provider, _) {
    if (provider.showCompletionDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog(context, provider);
      });
    }
    return TimerDisplay();
  }
)

void _showCompletionDialog(BuildContext context, TimerProvider provider) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text('⏰ Timer terminé !'),
      content: Text('Votre session est terminée'),
      actions: [
        TextButton(
          onPressed: () {
            provider.dismissCompletionDialog();
            Navigator.of(context).pop();
          },
          child: Text('Relancer', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            provider.dismissCompletionDialog();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(double.infinity, 48),
          ),
          child: Text('Arrêter', style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
  );
}
```

---

### Tâche 2 : Saisie durée intuitive (P1 - UX)

**Problème actuel** : Format `hh:mm:ss` rigide, faut sélectionner/effacer chaque segment.

**Solution proposée** : Saisie numérique **droite-à-gauche** avec remplissage automatique.

#### Option A : Saisie numérique pure (RECOMMANDÉ)

**Comportement** :
- TextField affiche `00:00:00` (placeholder grisé)
- L'utilisateur tape des chiffres **sans sélectionner** → remplissage de droite à gauche
- Exemples :
  - Tape `5` → `00:00:05` (5 secondes)
  - Tape `10` → `00:00:10` (10 secondes)
  - Tape `130` → `00:01:30` (1 min 30s)
  - Tape `10552` → `01:05:52` (1h 5min 52s)
  - Tape `235959` → `23:59:59` (23h 59min 59s - max)
- Touche **Backspace** → efface le dernier chiffre (retour droite-à-gauche)
- Format affiché en temps réel : `hh:mm:ss` avec séparateurs `:`

**Implémentation** :
- [ ] Remplacer le TextField actuel par un **GestureDetector + Container** stylisé
- [ ] Gérer la saisie manuellement avec **RawKeyboardListener** ou **TextField + TextInputFormatter custom**
- [ ] Stocker les chiffres tapés dans une String interne (ex: "10552")
- [ ] Formatter la String → Duration → `hh:mm:ss` affichée
- [ ] Limiter à 6 chiffres max (23:59:59 = 235959)

**Code suggéré** :
```dart
// widgets/numeric_timer_input.dart
class NumericTimerInput extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onChanged;
  
  const NumericTimerInput({
    required this.initialDuration,
    required this.onChanged,
  });
  
  @override
  State<NumericTimerInput> createState() => _NumericTimerInputState();
}

class _NumericTimerInputState extends State<NumericTimerInput> {
  String _digits = '';
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _digits = _durationToDigits(widget.initialDuration);
  }
  
  String _durationToDigits(Duration d) {
    int totalSeconds = d.inSeconds;
    return totalSeconds.toString().padLeft(6, '0');
  }
  
  Duration _digitsToDuration(String digits) {
    if (digits.isEmpty) return Duration.zero;
    
    // Pad à 6 chiffres (ex: "552" -> "000552")
    String padded = digits.padLeft(6, '0');
    
    // Parse HHMMSS
    int hours = int.parse(padded.substring(0, 2));
    int minutes = int.parse(padded.substring(2, 4));
    int seconds = int.parse(padded.substring(4, 6));
    
    // Limite 12h max
    if (hours > 12) hours = 12;
    if (minutes > 59) minutes = 59;
    if (seconds > 59) seconds = 59;
    
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
  
  String _formatDisplay(String digits) {
    String padded = digits.padLeft(6, '0');
    return '${padded.substring(0, 2)}:${padded.substring(2, 4)}:${padded.substring(4, 6)}';
  }
  
  void _handleKeyPress(String key) {
    setState(() {
      if (key == 'Backspace' && _digits.isNotEmpty) {
        _digits = _digits.substring(0, _digits.length - 1);
      } else if (RegExp(r'[0-9]').hasMatch(key) && _digits.length < 6) {
        _digits += key;
      }
      
      widget.onChanged(_digitsToDuration(_digits));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            _handleKeyPress(event.logicalKey.keyLabel);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            border: Border.all(color: _focusNode.hasFocus ? Colors.orange : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _formatDisplay(_digits),
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
              fontSize: 56,
              color: _focusNode.hasFocus ? Colors.orange : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
```

**Alternative plus simple** : Utiliser TextField avec **TextInputFormatter** custom qui reformatte en `hh:mm:ss` en temps réel.

---

#### Option B : Toggle entre deux modes (si demandé)

**UI** :
- Petit Switch/SegmentedButton à côté du timer display
- **Mode 1** : Saisie numérique (droite-à-gauche) - par défaut
- **Mode 2** : Format `hh:mm:ss` classique (comme actuellement)

**Implémentation** :
- [ ] Ajouter `bool _numericInputMode = true` dans `TimerProvider`
- [ ] SegmentedButton au-dessus du TextField :
  - "123" (numérique)
  - "00:00" (format classique)
- [ ] Switch du widget input selon le mode

**Recommandation** : **NE PAS implémenter Option B** pour v0.1. Trop complexe, ajoute de la friction.  
→ Garder **uniquement saisie numérique** (Option A) pour simplicité.

---

## 💡 Suggestions d'amélioration ergonomie (bonus)

### Suggestion 1 : Presets rapides
- Ajouter des chips/boutons rapides sous le timer :
  - `5 min` `10 min` `15 min` `30 min` `1h`
- Tap sur un preset → remplit le timer instantanément
- Gain UX énorme pour cas d'usage courants

```dart
Wrap(
  spacing: 8,
  children: [
    ActionChip(
      label: Text('5 min'),
      onPressed: () => provider.setDuration(Duration(minutes: 5)),
    ),
    ActionChip(label: Text('10 min'), onPressed: ...),
    ActionChip(label: Text('15 min'), onPressed: ...),
    ActionChip(label: Text('30 min'), onPressed: ...),
    ActionChip(label: Text('1h'), onPressed: ...),
  ],
)
```

### Suggestion 2 : Incrément/décrément par pas
- Ajouter petits boutons `+` et `-` autour du timer
- **Tap simple** : +/- 1 minute
- **Long press** : +/- 5 minutes
- **Double tap** : +/- 10 minutes

### Suggestion 3 : Slider visuel
- Ajouter un Slider horizontal sous le timer (optionnel)
- Range 0-120 minutes (ou 0-12h)
- Drag pour ajuster rapidement
- Moins précis mais rapide pour gros ajustements

### Suggestion 4 : Validation visuelle claire
- Quand l'utilisateur finit de taper → animation checkmark ✓
- Feedback haptique léger (vibration courte)
- Évite le doute "est-ce que c'est pris en compte ?"

---

## 🎨 Contraintes design

**Respecter** :
- Couleurs Dotlyn (Orange E36C2D, Gris 2C2C2C)
- Typo : Satoshi Black 56pt pour timer display
- Icônes : Remix Icon uniquement
- Dialog : Material Design standard, coins arrondis 12px
- Bouton "Arrêter" : Minimum 48px hauteur (accessibilité)

**Accessibilité** :
- Contraste texte/fond : WCAG AA minimum
- Boutons cliquables : zone minimum 44x44 (iOS guidelines)
- Dialog lisible avec TalkBack/VoiceOver

---

## ✅ Critères de succès

### Fonctionnel
- [ ] Son s'arrête quand Dialog "Arrêter" cliqué
- [ ] Son s'arrête automatiquement après 30s max
- [ ] Dialog non-dismissible (pas de fermeture accidentelle)
- [ ] Saisie numérique fonctionne droite-à-gauche
- [ ] Backspace efface le dernier chiffre
- [ ] Affichage `hh:mm:ss` mis à jour en temps réel
- [ ] Limite 12h respectée
- [ ] Pas de crash si saisie vide

### UX
- [ ] Utilisateur peut arrêter le son en 1 tap
- [ ] Saisie durée = max 6 taps clavier (ex: "001030")
- [ ] Pas besoin de sélectionner/effacer
- [ ] Feedback visuel clair (focus, validation)

### Code Quality
- [ ] `flutter analyze` = 0 issues
- [ ] Code commenté (logique saisie numérique)
- [ ] Pas de duplication avec ancien TextField

---

## 🚨 Points d'attention

### 1. Dialog timing (critique)
- **Problème potentiel** : Dialog peut s'afficher plusieurs fois si `notifyListeners()` appelé en boucle
- **Solution** : Flag `_dialogShown` qui bloque l'affichage multiple
- **Test** : Laisser timer atteindre 0 → vérifier 1 seul dialog

### 2. Saisie numérique sur mobile
- **RawKeyboardListener** ne fonctionne **PAS** sur clavier virtuel mobile
- **Solution** : Utiliser TextField avec TextInputFormatter custom
- **Formatter** : Intercepte chaque caractère tapé, reformatte en `hh:mm:ss`

### 3. Limite 12h
- Si utilisateur tape `999999` → doit clamper à `12:00:00`
- Afficher message "Durée max : 12h" si dépassement

### 4. Focus management
- Quand timer démarre (status = running) → **retirer le focus** du TextField
- Empêche la saisie pendant le countdown

### 5. Persistence
- Sauvegarder la dernière durée saisie dans SharedPreferences
- Restaurer au prochain lancement

---

## 📦 Fichiers à créer/modifier

### Créer
```
apps/timer/lib/widgets/
  numeric_timer_input.dart   # Widget saisie numérique custom
  duration_presets.dart      # Chips presets (bonus, optionnel)
```

### Modifier
```
apps/timer/lib/providers/timer_provider.dart
  → Ajouter flag _showCompletionDialog
  → Méthode dismissCompletionDialog()
  → Auto-stop son après 30s

apps/timer/lib/services/audio_service.dart
  → Méthode stopSound()

apps/timer/lib/screens/timer_screen.dart
  → Listener sur showCompletionDialog
  → showDialog() avec AlertDialog
  → Remplacer TimerDisplay par NumericTimerInput

apps/timer/lib/widgets/timer_display.dart
  → Supprimer (ou garder en backup)
```

---

## 📚 Références

- [Flutter AlertDialog](https://api.flutter.dev/flutter/material/AlertDialog-class.html)
- [TextInputFormatter custom](https://api.flutter.dev/flutter/services/TextInputFormatter-class.html)
- [RawKeyboardListener](https://api.flutter.dev/flutter/widgets/RawKeyboardListener-class.html)
- [Material Design Dialogs](https://m3.material.io/components/dialogs/overview)

---

## 🔄 Workflow d'exécution

1. **Phase 1 : Dialog stop son (30 min)**
   - Modifier audio_service.dart (stopSound)
   - Modifier timer_provider.dart (flag + dismiss)
   - Modifier timer_screen.dart (dialog UI)
   - Tester : timer → 0 → son joue → clic Arrêter → son stop

2. **Phase 2 : Saisie numérique (1-2h)**
   - Créer numeric_timer_input.dart
   - Implémenter logique droite-à-gauche
   - Tester cas limites (Backspace, 6 chiffres, 12h max)
   - Remplacer TimerDisplay dans timer_screen.dart

3. **Phase 3 : Tests + Doc (30 min)**
   - Tests manuels (émulateur + device réel si possible)
   - flutter analyze
   - Update APP.md (bugs cochés)
   - Commit : `[timer] feat: dialog stop son + saisie numérique intuitive`

---

**Priorité** : **Phase 1 (Dialog)** = critique, utilisateur bloqué actuellement.  
**Phase 2** = amélioration UX importante mais pas bloquante.

**Estimation totale** : 2-3 heures de dev + tests.

---

**Généré le** : 2025-11-16  
**À partir de** : PROMPT_USER.md  
**Version Timer** : v0.1 MVP
