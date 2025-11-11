# PROMPTS — Timer App

> **Usage** : Ce fichier contient des prompts structurés pour donner à GPT-4 ou autres LLMs afin d'effectuer des opérations en série sur l'app Timer. Remplir les sections pertinentes avant de soumettre.

---

## 📋 Contexte Projet

**App** : Timer  
**Version actuelle** : v0.1 (MVP)  
**Repo** : dotlyn-apps (monorepo Flutter)  
**Packages partagés** : `dotlyn_ui`, `dotlyn_core`, `dotlyn_timer_engine` (à créer)

**Liens doc** :
- APP.md : `_docs/apps/timer/APP.md`
- PITCH.md : `_docs/apps/timer/PITCH.md`
- Styleguide : `_docs/dotlyn/STYLEGUIDE.md`
- Copilot instructions : `.github/copilot-instructions.md`

---

## 🎯 Objectif de cette session

<!-- Décrire l'objectif global de la série d'opérations -->

**Exemple** :
```
Implémenter le système de notifications enrichies avec actions (pause/stop) 
et tester sur Android 12+.
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
1. Créer `lib/services/notification_service.dart` avec actions (pause/stop)
2. Intégrer le package `flutter_local_notifications` dans pubspec.yaml
3. Ajouter les permissions Android dans AndroidManifest.xml
4. Tester sur émulateur Pixel 4 API 35
5. Mettre à jour APP.md section TODO (déplacer "Notifications enrichies" vers Done)
6. Commit + push sur branche feat/timer-rich-notifications
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
- Utiliser DotlynColors.primary pour les boutons d'action
- Police : Satoshi Bold pour les titres de notification
- Icônes : Remix Icon uniquement (ri-notification-line)
- Respecter les guidelines Material3 pour les notifications
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
- flutter_local_notifications: ^17.0.0
- timezone: ^0.9.0 (pour scheduled notifications)
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
- [ ] Tests passent (si existants)
- [ ] Notifications s'affichent correctement sur Android 12+
- [ ] Actions pause/stop fonctionnent depuis la notification
- [ ] Doc APP.md mise à jour
- [ ] Commit poussé sur feat/timer-rich-notifications
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
- Android 12+ nécessite permission POST_NOTIFICATIONS à demander runtime
- Sur Android 13+, les channels de notification sont obligatoires
- Attention aux background services (Foreground Service required)
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
- apps/timer/lib/services/notification_service.dart
- apps/timer/lib/models/notification_action.dart

Modifier :
- apps/timer/pubspec.yaml (add dependencies)
- apps/timer/android/app/src/main/AndroidManifest.xml (permissions)
- _docs/apps/timer/APP.md (TODO section)
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
- Flutter Local Notifications docs : https://pub.dev/packages/flutter_local_notifications
- Android 12 notification changes : https://developer.android.com/about/versions/12/behavior-changes-12#notifications
- Issue GitHub liée : #42
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
Décision architecture : on utilise un Singleton pour NotificationService 
car on veut un seul point d'accès global. Alternative Provider évaluée 
mais rejetée (trop verbeux pour ce use case).
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
- App : Timer (apps/timer/)
- Packages partagés : dotlyn_ui, dotlyn_core
- Styleguide : _docs/dotlyn/STYLEGUIDE.md
- Convention commits : [timer] type: description

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
Mets à jour _docs/apps/timer/APP.md section TODO si nécessaire.
```

---

**Dernière mise à jour** : [DATE]  
**Statut** : [DRAFT / READY / IN-PROGRESS / COMPLETED]
