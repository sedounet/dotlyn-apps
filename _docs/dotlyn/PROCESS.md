# Process de Développement — Dotlyn Apps

> Guide méthodologique pour la conception et le développement des mini-apps

---

## 🎨 Workflow Conception

### Phase 1 : Expression Libre (PROMPT_USER.md)
L'utilisateur décrit sa vision en langage naturel :
- Ce qu'il veut
- Inspirations / maquettes
- Points d'attention

**Durée** : 10-30 min  
**Format** : Prose libre, pas de structure imposée

---

### Phase 2 : Clarification Itérative (Discussion)

**Minimum 2 passes requises**, souvent 3-4 pour les apps complexes.

#### Passe 1 : Compréhension & Proposition
- Copilot lit PROMPT_USER.md
- Identifie ambiguïtés et points techniques
- Propose roadmap MVP/v0.2/v0.3+
- Pose questions de clarification

#### Passe 2 : Élagage & Priorisation
- Réponses aux questions
- Arbitrages fonctionnels
- Simplification du scope MVP
- Validation terminologie

#### Passe 3+ : Finalisation Détails
- Structures de données
- Flow UI/UX
- Choix techniques (BDD, state management, etc.)
- Edge cases

**Objectif** : Avoir une vision claire et partagée avant d'écrire une ligne de code

---

### Phase 3 : Structuration (PROMPT_AI.md)
Copilot génère un document structuré avec :
- Objectif précis
- Tâches numérotées
- Contexte technique
- Critères de succès
- Architecture détaillée

**Format** : Exécutable directement par l'IA

---

### Phase 4 : Implémentation
- Dev incrémental (feature par feature)
- Tests au fur et à mesure
- Updates APP.md (TODO, bugs, notes)

---

### Phase 5 : Nettoyage
- Vider/supprimer PROMPT_USER.md
- Vider/supprimer PROMPT_AI.md
- Prêt pour la prochaine demande

---

## 📐 Méthodologie UI/UX

### Principe : Mobile-First, One-Hand Friendly

**Zones d'écran** :
```
┌─────────────────┐
│   Safe Zone     │ ← Infos importantes (soldes, titre)
│                 │
│   Interaction   │ ← Zone centrale (listes, contenus)
│     Zone        │
│                 │
│                 │
│  Thumb Zone     │ ← Actions principales (boutons +/-)
│   + Ads         │
└─────────────────┘
```

### Checklist Design
- [ ] Actions principales accessibles au pouce
- [ ] Infos critiques visibles sans scroll
- [ ] Maximum 3 clics pour toute action
- [ ] Pas de friction inutile (confirmations excessives, etc.)
- [ ] Respect styleguide Dotlyn (couleurs, typo, icônes)

---

## 🗂️ Structure de Pages Type

### Pattern Standard
```
Page Principale
├── Écran 1 (Dashboard/Home)
├── Action Modale/Bottom Sheet (Ajout rapide)
└── Pages Secondaires
    ├── Liste/Détails
    ├── Filtres
    └── Settings
```

### Navigation
- **Bottom Navigation** : 2-4 sections max
- **Floating Action Button** : Action principale
- **Bottom Sheet** : Formulaires rapides
- **Pages complètes** : Détails, listes longues

---

## 🛠️ Workflow Technique

### Avant de coder
1. Définir modèles de données (Drift schemas)
2. Définir états (Riverpod providers)
3. Wireframes textuels (ce document)
4. Validation architecture

### Pendant le dev
1. Feature par feature (pas tout en même temps)
2. Test manuel après chaque feature
3. Analytics events dès le début
4. Doc inline (commentaires complexité)

### Après feature
1. Update APP.md (✅ done, nouvelles TODO)
2. Commit avec convention `[app] type: description`
3. Test régression rapide

---

## 📊 Décision Arborescence Pages

### Process
1. Lister toutes les fonctionnalités
2. Regrouper par usage fréquence
3. Définir navigation primaire vs secondaire
4. Wireframe textuel
5. Validation one-hand usability

### Template Décision
```markdown
## Pages Principales
- **Home** : [Description]
  - Actions : [Liste]
  - Navigations : [Vers où]

## Pages Secondaires
- **Nom** : [Rôle]
  - Accès : [Depuis où]
```

---

## 🎯 Critères de Qualité MVP

### Fonctionnel
- [ ] Use case principal fonctionne de bout en bout
- [ ] Données persistées correctement
- [ ] Pas de crash sur happy path

### UX
- [ ] Action principale en < 3 clics
- [ ] Feedback visuel sur actions
- [ ] Ergonomie mobile validée

### Technique
- [ ] Lint clean (`flutter analyze`)
- [ ] Analytics configuré
- [ ] BDD schema versionné

### Non-requis MVP
- ❌ Tests unitaires exhaustifs (mais bienvenus)
- ❌ UI pixel-perfect
- ❌ Edge cases complexes
- ❌ Performances extrêmes

---

## 🔄 Itérations Post-MVP

Chaque version (v0.2, v0.3...) suit le même cycle :
1. Expression besoin (PROMPT_USER.md)
2. Discussion/élagage
3. PROMPT_AI.md
4. Dev
5. Nettoyage

**Durée recommandée par version** : 1-3 jours max  
**Objectif** : Livrer souvent, itérer vite

---

**Version** : 1.0  
**Dernière update** : 2025-12-13  
**Maintainer** : @sedounet
