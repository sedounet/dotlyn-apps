# PROMPTS — Tabata App

> **Usage** : Ce fichier contient des prompts structurés pour donner à GPT-4 ou autres LLMs afin d'effectuer des opérations en série sur l'app Tabata. Remplir les sections pertinentes avant de soumettre.

---

## 📋 Contexte Projet

**App** : Tabata  
**Version actuelle** : v0.1 (MVP)  
**Repo** : dotlyn-apps (monorepo Flutter)  
**Packages partagés** : `dotlyn_ui`, `dotlyn_core`, `dotlyn_timer_engine` (à créer)

**Liens doc** :
- APP.md : `_docs/apps/tabata/APP.md`
- PITCH.md : `_docs/apps/tabata/PITCH.md`
- Styleguide : `_docs/dotlyn/STYLEGUIDE.md`
- Copilot instructions : `.github/copilot-instructions.md`

---

## 🎯 Objectif de cette session

<!-- Décrire l'objectif global de la série d'opérations -->

**Exemple** :
```
Implémenter le système d'intervalles Tabata (20s effort / 10s repos × 8 rounds) 
avec feedback audio et visuel intense.
```

**Ton objectif** :
```
[À REMPLIR]
```

---

## 📝 Instructions Détaillées

<!-- Liste numérotée des tâches à effectuer dans l'ordre -->

**Exemple** :
```
1. Créer `lib/models/tabata_round.dart` (effort, rest, round number)
2. Créer `lib/services/tabata_engine.dart` avec logique 8 rounds
3. Implémenter feedback audio (beep effort, beep repos, countdown)
4. Créer UI avec indicateur visuel intense (couleur change, animation)
5. Tester les transitions rapides (20s/10s)
6. Mettre à jour APP.md section TODO
7. Commit + push sur branche feat/tabata-intervals
```

**Tes instructions** :
```
[À REMPLIR]
1. 
2. 
3. 
```

---

## 🎨 Contraintes Design

<!-- Références au styleguide, composants UI à utiliser, couleurs, typo -->

**Exemple** :
```
- Utiliser DotlynColors.error (rouge intense) pour les phases d'effort
- Utiliser DotlynColors.success (vert) pour les phases de repos
- Animation : pulse effect ou scale animation pendant l'effort
- Police : Satoshi Black pour le timer, très gros (80pt+)
- Sons : beep aigu (effort), beep grave (repos), countdown 3-2-1
- Écran plein, immersif (cacher AppBar pendant workout)
```

**Tes contraintes** :
```
[À REMPLIR]
```

---

## 🧩 Dépendances & Packages

<!-- Packages pub.dev à ajouter, versions, configuration -->

**Exemple** :
```
- audioplayers: ^5.0.0 (pour les beeps)
- vibration: ^1.8.0 (feedback haptique optionnel)
```

**Tes dépendances** :
```
[À REMPLIR]
```

---

## ✅ Critères de Validation

<!-- Comment vérifier que le travail est terminé et correct -->

**Exemple** :
```
- [ ] flutter analyze = 0 issues
- [ ] Tests unitaires pour tabata_engine.dart passent
- [ ] Les 8 rounds s'enchaînent correctement (20s effort / 10s repos)
- [ ] Feedback audio joue au bon moment (transitions)
- [ ] UI change de couleur/animation selon la phase
- [ ] Countdown 3-2-1 avant le début du premier round
- [ ] Doc APP.md mise à jour
- [ ] Commit poussé sur feat/tabata-intervals
```

**Tes critères** :
```
[À REMPLIR]
- [ ] 
- [ ] 
```

---

## 🚨 Points d'Attention

<!-- Problèmes connus, pièges à éviter, edge cases -->

**Exemple** :
```
- Transitions très rapides (10s repos) : tester la précision du timer
- Gérer le cas où l'utilisateur met en pause pendant un round (reprendre ou reset ?)
- Audio : précharger les sons pour éviter les lags
- Attention à la performance : animations fluides même sur vieux devices
- Tester sur iOS : permissions audio/haptic feedback
```

**Tes points d'attention** :
```
[À REMPLIR]
```

---

## 📦 Fichiers à Modifier / Créer

<!-- Liste explicite des fichiers concernés -->

**Exemple** :
```
Créer :
- apps/tabata/lib/models/tabata_round.dart
- apps/tabata/lib/services/tabata_engine.dart
- apps/tabata/lib/widgets/intense_timer_display.dart
- packages/dotlyn_ui/lib/assets/sounds/beep_high.mp3
- packages/dotlyn_ui/lib/assets/sounds/beep_low.mp3

Modifier :
- apps/tabata/pubspec.yaml (dependencies)
- apps/tabata/lib/screens/workout_screen.dart (UI immersive)
- _docs/apps/tabata/APP.md (TODO section)
```

**Tes fichiers** :
```
[À REMPLIR]
Créer :
- 

Modifier :
- 
```

---

## 🔗 Références Externes

<!-- Liens vers docs, articles, issues GitHub, etc. -->

**Exemple** :
```
- Tabata Protocol explained : https://en.wikipedia.org/wiki/High-intensity_interval_training#Tabata_regimen
- audioplayers docs : https://pub.dev/packages/audioplayers
- Issue GitHub liée : #XX
```

**Tes références** :
```
[À REMPLIR]
```

---

## 💬 Notes & Contexte Additionnel

<!-- Tout autre contexte utile, historique, décisions prises -->

**Exemple** :
```
Décision UX : on affiche un countdown 3-2-1 avant le premier round pour 
que l'utilisateur se prépare. Alternative "démarrage immédiat" jugée 
trop brutale pour un workout intense.

Décision technique : on utilise audioplayers plutôt que just_audio 
car plus léger et suffisant pour des beeps courts.
```

**Tes notes** :
```
[À REMPLIR]
```

---

## 🤖 Prompt Final Structuré

<!-- Section générée automatiquement ou template à copier/coller pour GPT-4 -->

```
Tu es un expert Flutter travaillant sur le monorepo dotlyn-apps.

CONTEXTE :
- App : Tabata (apps/tabata/)
- Packages partagés : dotlyn_ui, dotlyn_core
- Styleguide : _docs/dotlyn/STYLEGUIDE.md
- Convention commits : [tabata] type: description

OBJECTIF :
[Copier depuis section "Objectif de cette session"]

INSTRUCTIONS :
[Copier depuis section "Instructions Détaillées"]

CONTRAINTES DESIGN :
[Copier depuis section "Contraintes Design"]

DÉPENDANCES :
[Copier depuis section "Dépendances & Packages"]

CRITÈRES DE VALIDATION :
[Copier depuis section "Critères de Validation"]

POINTS D'ATTENTION :
[Copier depuis section "Points d'Attention"]

FICHIERS :
[Copier depuis section "Fichiers à Modifier / Créer"]

Respecte STRICTEMENT les conventions du fichier .github/copilot-instructions.md.
Ne crée PAS de fichier TODO.md séparé.
Utilise UNIQUEMENT les polices Satoshi/Manrope et les icônes Remix Icon.
Mets à jour _docs/apps/tabata/APP.md section TODO si nécessaire.
```

---

**Dernière mise à jour** : [DATE]  
**Statut** : [DRAFT / READY / IN-PROGRESS / COMPLETED]
