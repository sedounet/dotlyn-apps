# PROMPTS — Pomodoro App

> **Usage** : Ce fichier contient des prompts structurés pour donner à GPT-4 ou autres LLMs afin d'effectuer des opérations en série sur l'app Pomodoro. Remplir les sections pertinentes avant de soumettre.

---

## 📋 Contexte Projet

**App** : Pomodoro  
**Version actuelle** : v0.1 (MVP)  
**Repo** : dotlyn-apps (monorepo Flutter)  
**Packages partagés** : `dotlyn_ui`, `dotlyn_core`, `dotlyn_timer_engine` (à créer)

**Liens doc** :
- APP.md : `_docs/apps/pomodoro/APP.md`
- PITCH.md : `_docs/apps/pomodoro/PITCH.md`
- Styleguide : `_docs/dotlyn/STYLEGUIDE.md`
- Copilot instructions : `.github/copilot-instructions.md`

---

## 🎯 Objectif de cette session

<!-- Décrire l'objectif global de la série d'opérations -->

**Exemple** :
```
Implémenter le système de cycles Pomodoro (25min travail / 5min pause / 
15min pause longue après 4 cycles) avec persistence locale.
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
1. Créer `lib/models/pomodoro_cycle.dart` (work, break, long_break)
2. Créer `lib/services/pomodoro_engine.dart` avec logique de cycles
3. Implémenter persistence avec shared_preferences
4. Créer UI pour afficher le cycle en cours (1/4, 2/4, etc.)
5. Tester la transition automatique entre cycles
6. Mettre à jour APP.md section TODO
7. Commit + push sur branche feat/pomodoro-cycles
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
- Utiliser DotlynColors.accent pour les phases de pause
- Utiliser DotlynColors.primary pour les phases de travail
- Police : Satoshi Black pour le timer principal
- Icônes : Remix Icon (ri-timer-line, ri-cup-line pour pause)
- Afficher un indicateur visuel des 4 cycles (dots ou progress bar)
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
- shared_preferences: ^2.2.0 (persistence)
- provider: ^6.0.0 (state management)
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
- [ ] Tests unitaires pour pomodoro_engine.dart passent
- [ ] Les cycles s'enchaînent correctement (work → break → work → ... → long_break)
- [ ] Persistence fonctionne (relancer l'app = reprend où on était)
- [ ] UI affiche clairement le cycle en cours
- [ ] Doc APP.md mise à jour
- [ ] Commit poussé sur feat/pomodoro-cycles
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
- Gérer le cas où l'app est fermée pendant un cycle (reprendre ou reset ?)
- Attention à la logique de compteur : après 4 work cycles, on fait une long break
- Tester la transition automatique : le timer doit démarrer automatiquement 
  le cycle suivant ou demander confirmation ?
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
- apps/pomodoro/lib/models/pomodoro_cycle.dart
- apps/pomodoro/lib/services/pomodoro_engine.dart
- apps/pomodoro/lib/widgets/cycle_indicator.dart

Modifier :
- apps/pomodoro/pubspec.yaml (dependencies)
- apps/pomodoro/lib/screens/timer_screen.dart (UI cycle)
- _docs/apps/pomodoro/APP.md (TODO section)
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
- Technique Pomodoro officielle : https://francescocirillo.com/pages/pomodoro-technique
- shared_preferences docs : https://pub.dev/packages/shared_preferences
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
Décision UX : on demande confirmation avant de démarrer le cycle suivant 
pour éviter de surprendre l'utilisateur. Alternative auto-start évaluée 
mais jugée trop intrusive.
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
- App : Pomodoro (apps/pomodoro/)
- Packages partagés : dotlyn_ui, dotlyn_core
- Styleguide : _docs/dotlyn/STYLEGUIDE.md
- Convention commits : [pomodoro] type: description

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
Mets à jour _docs/apps/pomodoro/APP.md section TODO si nécessaire.
```

---

**Dernière mise à jour** : [DATE]  
**Statut** : [DRAFT / READY / IN-PROGRESS / COMPLETED]
