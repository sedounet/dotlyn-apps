# Setup Dotlyn Apps Monorepo - Version 2

> **Date:** 2025-11-04  
> **Objectif:** Installation complète et propre des packages partagés + Design Lab  
> **Améliorations:** Correction des erreurs de la V1, remplacement Manrope → Jakarta, Design Lab complet

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

## ⚠️ Corrections de la V1

### Erreurs identifiées et corrigées :
1. ✅ `dotlyn_core/pubspec.yaml` manquait la dépendance `flutter`
2. ✅ Chemins des fonts mal configurés (static vs variable)
3. ✅ Design Lab incomplet (un seul bouton au lieu de tous les widgets)
4. ✅ **Manrope remplacé par Plus Jakarta Sans** (poids de fichier réduit)

---

## 📁 Structure du Monorepo

```
dotlyn-apps/
├── _docs/                      # Documentation
│   ├── apps/                   # Doc par app
│   └── dotlyn/                 # Brand, styleguide, polices
├── apps/                       # Mini-apps Flutter
│   └── design_lab/            # ← APP À CRÉER
├── packages/                   # Code partagé
│   ├── dotlyn_ui/             # ← PACKAGE À CRÉER
│   └── dotlyn_core/           # ← PACKAGE À CRÉER
├── melos.yaml                  # Config Melos
├── pubspec.yaml                # Root pubspec
└── SETUP_V2.md                # ← CE FICHIER
```

---

## 🚀 Déploiement prévu : Demain

Le setup complet sera effectué demain avec :
- Création des packages dotlyn_ui et dotlyn_core
- Configuration des fonts Jakarta et Satoshi
- Création de l'app Design Lab
- Tests et validation

---

**Version** : 2.0  
**Date** : 2025-11-04  
**Status** : Setup prévu pour demain
