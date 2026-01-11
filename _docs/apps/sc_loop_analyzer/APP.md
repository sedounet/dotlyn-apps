# SC Loop Analyzer — Documentation

**Status** : 🟡 Conception  
**Version actuelle** : v0.1 (conception)  
**Dernière update** : 2026-01-11

---

## 📋 Vision

App pour analyser les loops économiques dans Starcraft (worker count, supply, timing). Légère, efficace, extensible.

**Objectif** : Aider les joueurs à identifier leurs faiblesses de gestion macro.

---

## 🎯 Versions

### v0.1 MVP — Profils & Enregistrement

**Fonctionnalités cibles** :
- Création profils joueurs
- Enregistrement sessions (timestamps, events)
- Stockage SQLite local
- UI basique workflow

---

## 📝 TODO

<!-- 
RÈGLES :
- Issues locales = #N (numéro séquentiel, pas GitHub)
- Commit SHA = 7 premiers chars obligatoire dans Recently Done
- Date format = YYYY-MM-DD
- Recently Done = garder max 15 items ou 2 semaines
-->

### 🚧 In Progress (max 3-5 items actifs)

_Aucun item en cours (app en conception)._

---

### 🔴 P1 — ASAP (MVP v0.1)

- [ ] #1: Générer l'UI de base (workflow, profils, session)
- [ ] #2: Stockage SQLite profils & sessions

---

### 🟡 P2 — Prochaine version (v0.2)

- [ ] #10: Export CSV des données
- [ ] #11: Statistiques avancées (moyennes, graphiques)
- [ ] #12: Thème sombre/clair (DotlynTheme)

---

### 🔵 P3 — Plus tard (v0.3+)

- [ ] #20: Notifications sonores (fin de session)
- [ ] #21: Export PDF avec graphiques
- [ ] #22: Cloud sync (optionnel)

---

### ✅ Recently Done (last 15 items or 2 weeks)

<!-- Format: [x] #N: Description — Done YYYY-MM-DD (commit SHA7CHAR) -->

_Aucun item terminé (app en conception)._

---

## 🔗 Liens

- PITCH.md : [`PITCH.md`](PITCH.md)
- CHANGELOG.md : [`../../../apps/sc_loop_analyzer/CHANGELOG.md`](../../../apps/sc_loop_analyzer/CHANGELOG.md)

---

## 📝 Notes Techniques

### Architecture cible
- Stockage : SQLite avec Drift
- State : Riverpod providers
- UI : Material + DotlynTheme

### Conventions
- App légère, efficace, extensible
- Respecte conventions Dotlyn Apps

---

**Version** : 2.0  
**Dernière mise à jour** : 2026-01-11  
**Maintainer** : @sedounet
