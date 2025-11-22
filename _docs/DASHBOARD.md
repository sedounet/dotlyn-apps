# 📊 Dashboard Dotlyn Apps

> Vue d'ensemble • Mise à jour : 2025-11-03

---

## 🎯 Apps Actives

### ⏱️ Timer (Simple)
**Status** : 🚧 v0.2 notifications/alarme en cours  
**Focus actuel** : AlarmManager Android + notifications de fin + sonnerie système  
**Tagline** : "Le timer le plus simple et fiable"  
📁 [Doc](./apps/timer/APP.md) • 🐛 [Issues](https://github.com/sedounet/dotlyn-apps/labels/timer)

### 🍅 Pomodoro
**Status** : 📋 Planifié  
**Focus futur** : Cycles automatiques + tracking productivité  
**Tagline** : "Pomodoro strict pour la productivité"  
📁 [Doc](./apps/pomodoro/APP.md) • 🐛 [Issues](https://github.com/sedounet/dotlyn-apps/labels/pomodoro)

### 🏃 Tabata
**Status** : 📋 Planifié  
**Focus futur** : HIIT intervals + fitness tracking  
**Tagline** : "Timer HIIT pour le fitness"  
📁 [Doc](./apps/tabata/APP.md) • 🐛 [Issues](https://github.com/sedounet/dotlyn-apps/labels/tabata)

### 🎨 Design Lab
**Status** : ✅ Opérationnel (outil interne)  
**Utilité** : Tester le design system Dotlyn  
📁 [Doc](./apps/design_lab/APP.md)

---

## 📊 Vue globale

| App        | Version | Status                  | Cible 1ère sortie |
| ---------- | ------- | ----------------------- | ----------------- |
| Timer      | 0.2.0   | 🚧 Notifications/Alarmes | Décembre 2025     |
| Pomodoro   | -       | 📋 Planifié              | Février 2025      |
| Tabata     | -       | 📋 Planifié              | Mars 2025         |
| Design Lab | -       | ✅ Interne               | -                 |

---

## 🔥 Top Priorités Cross-Apps

1. **[Timer]** Background service Android (Foreground Service)
2. **[Timer]** Background task iOS (Background Modes)
3. **[Timer]** Setup flutter_local_notifications
4. **[Packages]** Créer `dotlyn_timer_engine` pour réutilisation
5. **[Meta]** Valider architecture monorepo (packages partagés)

---

## 📦 Packages Partagés

| Package               | Utilité                              | Status         |
| --------------------- | ------------------------------------ | -------------- |
| `dotlyn_ui`           | Thème, couleurs, typography, widgets | ✅ Opérationnel |
| `dotlyn_core`         | Providers, utils, constants          | ✅ Opérationnel |
| `dotlyn_timer_engine` | Logique timer réutilisable           | 📋 À créer      |

---

## 🔗 Liens Utiles

- [Styleguide Dotlyn](./dotlyn/STYLEGUIDE.md)
- [Idées mini-apps](./dotlyn/miniapps_idees.md)
- [Brand Assets](./dotlyn/brand-assets/)

---

**Dernière mise à jour** : 2025-11-22  
**Apps suivies** : 4 (1 active, 2 planifiées, 1 interne)
