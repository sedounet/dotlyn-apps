# Habit Tracker

Habit Tracker mini-app pour Dotlyn Apps.

## Documentation

Voir `_docs/apps/habit_tracker/` pour la documentation complète :
- **APP.md** : Documentation technique, TODO, versions
- **PITCH.md** : Vision et identité de l'app
- **PROMPT_USER.md** : Spécifications et demandes utilisateur

## Structure

```
lib/
├── main.dart
├── screens/      # Écrans de l'app
├── services/     # Services métier
├── models/       # Modèles de données
└── widgets/      # Composants UI réutilisables
```

## Lancement

```bash
# Depuis la racine du monorepo
melos run habit_tracker

# Ou directement
cd apps/habit_tracker
flutter run
```
