# ⚠️ DÉCISION REQUISE — Police Typographique UI

## Problème Identifié

**Incohérence** entre documentation et implémentation :
- **STYLEGUIDE.md** : "Manrope (UI/texte)"
- **dotlyn_ui implementation** : PlusJakartaSans

## Contexte

### Documentation Actuelle
`_docs/dotlyn/STYLEGUIDE.md` :
```
**Texte / UI :** `Manrope`
> Très bonne lisibilité à petite taille, optimisé pour écrans.
> **Retenu :** Manrope Regular pour l'interface
```

### Implémentation Actuelle
`packages/dotlyn_ui/lib/theme/typography.dart` :
```dart
/// UI/Texte: Plus Jakarta Sans
static const String _jakarta = 'PlusJakartaSans';
```

`packages/dotlyn_ui/pubspec.yaml` :
- Satoshi ✅ (installé)
- PlusJakartaSans ✅ (installé)
- Manrope ❌ (NON installé)

## Options de Résolution

### Option A — Adopter officiellement PlusJakartaSans ⭐ RECOMMANDÉ
**Action** : Mettre à jour STYLEGUIDE.md pour officialiser PlusJakartaSans.

**Avantages** :
- ✅ Aucun changement code requis
- ✅ Police déjà installée et testée
- ✅ PlusJakartaSans est aussi optimisé pour UI mobile
- ✅ Bonne lisibilité petite taille
- ✅ Google Fonts (libre usage commercial)
- ✅ Cohérence immédiate (apps existantes fonctionnent)

**Inconvénients** :
- ⚠️ Divergence avec idée initiale (Manrope)

**Effort** : Minimal (1 fichier markdown)

---

### Option B — Revenir à Manrope
**Action** : Remplacer PlusJakartaSans par Manrope dans dotlyn_ui.

**Avantages** :
- ✅ Respecte styleguide original
- ✅ Manrope est aussi excellent pour UI

**Inconvénients** :
- ❌ Nécessite télécharger/installer Manrope
- ❌ Modifier pubspec.yaml (fonts assets)
- ❌ Regénérer toutes les apps
- ❌ Tester visuellement tous les widgets

**Effort** : Moyen (ajout fonts + tests visuels)

---

### Option C — Supporter les deux (Manrope prioritaire)
**Action** : Ajouter Manrope + fallback PlusJakartaSans.

**Avantages** :
- ✅ Maximum flexibilité
- ✅ Fallback si Manrope non disponible

**Inconvénients** :
- ❌ Complexité accrue
- ❌ Maintenance de deux polices
- ❌ Taille bundle augmentée

**Effort** : Élevé (double assets + configuration)

---

## Recommandation

**→ Option A : Adopter PlusJakartaSans officiellement**

**Justification** :
1. PlusJakartaSans est déjà en production (apps fonctionnent)
2. Qualité équivalente à Manrope pour UI mobile
3. Effort minimal (update doc uniquement)
4. Pas de régression visuelle

**Alternative** : Si attachement fort à Manrope, choisir Option B avant release v0.1 (pas d'apps publiées = changement facile).

---

## Actions Proposées (Option A)

### Mise à jour STYLEGUIDE.md :
```markdown
**Texte / UI :** `Plus Jakarta Sans`
> Très bonne lisibilité à petite taille, optimisé pour écrans.
> **Retenu :** Plus Jakarta Sans Regular pour l'interface
> **Alternative considérée :** Manrope (similaire, également excellent)

**Liens de téléchargement des polices :**
- [Satoshi (Fontshare)](https://www.fontshare.com/fonts/satoshi) - **Licence gratuite usage commercial**
- [Plus Jakarta Sans (Google Fonts)](https://fonts.google.com/specimen/Plus+Jakarta+Sans) - **Open Font License**
```

### Instructions Copilot :
```markdown
- **Typo** : Satoshi (titres/logo) + Plus Jakarta Sans (UI/texte)
```

---

## Timeline Décision

**Si Option A (recommandé)** :
- ⏱️ 5min : Update STYLEGUIDE.md
- ⏱️ 2min : Update copilot-instructions.md
- ⏱️ 1min : Commit "[docs] standardize: adopt Plus Jakarta Sans officially"

**Si Option B** :
- ⏱️ 10min : Download/install Manrope fonts
- ⏱️ 5min : Update pubspec.yaml + typography.dart
- ⏱️ 15min : Visual testing all apps
- ⏱️ 5min : Update docs

**TOTAL Option A** : 8 minutes  
**TOTAL Option B** : 35 minutes

---

## Décision Finale

**→ À valider par @sedounet**

Choix : [ ] Option A  |  [ ] Option B  |  [ ] Option C  |  [ ] Autre

**Date décision** : ___________

---

**Version** : 1.0  
**Date** : 2026-01-01  
**Impacte** : github_notes, toutes futures apps
