# Workflow Proposals — Index

> **Statut** : BROUILLONS — Fichiers d'étude à valider avant application  
> **Date création** : 2026-01-11  
> **Objectif** : Améliorer workflow APP.md + CHANGELOG pour scalabilité et store-readiness

---

## 📁 Fichiers créés

### 1. [APP_TEMPLATE_PROPOSAL.md](APP_TEMPLATE_PROPOSAL.md)

**Contenu** :
- Structure APP.md complète avec commentaires explicatifs
- Sections : In Progress / P1/P2/P3 / Parking Lot / Recently Done
- Format issues locales (#N) et GitHub issues (GH#N)
- Exemples concrets annotés

**Usage** :
- Lire et adapter pour créer/refactorer APP.md d'une app
- Copier structure et remplir avec contenu réel
- Modifier sections selon besoins spécifiques

---

### 2. [CHANGELOG_STRUCTURE_PROPOSAL.md](CHANGELOG_STRUCTURE_PROPOSAL.md)

**Contenu** :
- Format CHANGELOG exploitable pour stores
- Structure [Unreleased] vs versions numérotées
- Pattern headline user-facing + détails techniques
- Exemples GitHub Notes v0.1.0 et v0.2.0

**Usage** :
- Référence pour structurer CHANGELOG.md
- Copier format lors création nouvelle version
- Extraire headlines pour release notes stores

---

### 3. [ISSUES_LOCAL_VS_GITHUB.md](ISSUES_LOCAL_VS_GITHUB.md)

**Contenu** :
- Explication pattern issues locales (#N) vs GitHub (GH#N)
- Critères escalade vers GitHub issues
- Commandes gh CLI (installation, création, fermeture)
- Workflow hybride selon phase projet (MVP → beta → public)

**Usage** :
- Décider quand créer GitHub issue vs tracking local
- Référence commandes gh CLI si besoin
- Adapter workflow selon taille équipe/communauté

---

### 4. [RELEASE_NOTES_FORMAT.md](RELEASE_NOTES_FORMAT.md)

**Contenu** :
- Templates copier-coller pour Google Play / App Store
- Contraintes stores (500 chars Google, 4000 chars Apple)
- Workflow manuel : CHANGELOG → extraction headlines → format store
- Exemples GitHub Notes v0.1.0 complets

**Usage** :
- Lors release : copier template et adapter
- Extraire headlines depuis CHANGELOG [version]
- Coller dans console store (Google Play / App Store Connect)

---

### 5. [VERSIONING_RULES.md](VERSIONING_RULES.md)

**Contenu** :
- Semantic Versioning expliqué (MAJOR.MINOR.PATCH)
- Critères décision : quand incrémenter quelle partie
- Cas particuliers : pre-release (v0.x), hotfix, breaking changes
- Decision tree + exemples concrets GitHub Notes

**Usage** :
- Référence lors décision version nouvelle release
- Comprendre impact changements (breaking vs compatible)
- Tagging Git recommandations

---

## 🎯 Workflow proposé (synthèse)

### Phase 1 : Développement quotidien

```
1. Prendre issue #N depuis APP.md P1
2. Créer branche feat/app-short-desc
3. Coder + commits
4. Idées spontanées → Parking Lot (APP.md)
5. Tests passent → cocher #N, move to Recently Done
6. Ajouter à CHANGELOG [Unreleased] :
   - **User headline**
     - Technical details (commit SHA)
7. Commit: [app] type: description (closes #N)
8. Merge main, delete branch
```

### Phase 2 : Release (ex: v0.2.0)

```
1. Trier Parking Lot (APP.md) : promouvoir ou archiver
2. Nettoyer Recently Done : si > 15 items, copier vers CHANGELOG
3. Renommer CHANGELOG [Unreleased] → [0.2.0] - YYYY-MM-DD
4. Extraire headlines depuis CHANGELOG v0.2.0
5. Copier-coller vers release_notes_en.txt (format store)
6. flutter build appbundle --release
7. Upload Google Play Console + coller release notes
8. git tag github_notes-v0.2.0
9. Créer nouveau [Unreleased] dans CHANGELOG
```

### Phase 3 : Post-release

```
1. Monitor crashes/feedback
2. Hotfix urgent → PATCH (v0.2.1)
3. Next features → P1/P2 APP.md + [Unreleased] CHANGELOG
```

---

## 📊 Récap décisions clés

| Aspect           | Décision                                                |
| ---------------- | ------------------------------------------------------- |
| **Issues**       | Locales (#N) par défaut, GitHub (GH#N) si besoin collab |
| **Archive Done** | CHANGELOG après 15 items ou 2 semaines                  |
| **Versioning**   | Semantic (MAJOR.MINOR.PATCH) strict                     |
| **Store notes**  | Copier-coller manuel depuis CHANGELOG                   |
| **Parking Lot**  | Ajouts organiques, trier en fin session                 |
| **Commit SHA**   | 7 chars obligatoire dans Recently Done                  |

---

## � Récap décisions clés

| Aspect | Décision |
|--------|----------|
| **Issues** | ⛔ Locales (#N) UNIQUEMENT — GitHub (GH#N) VERROUILLÉ |
| **Archive Done** | CHANGELOG après 15 items ou 2 semaines |
| **Versioning** | Semantic (MAJOR.MINOR.PATCH) strict |
| **Store notes** | Copier-coller manuel depuis CHANGELOG |
| **Parking Lot** | Ajouts organiques, trier en fin session |
| **Commit SHA** | 7 chars obligatoire dans Recently Done |

**⛔ IMPORTANT** : Issues GitHub (GH#N) désactivées par défaut. Ne pas utiliser sans activation manuelle explicite.

---

## �🚀 Prochaines étapes

### Option A : Validation brouillons

1. Lire tous les fichiers
2. Noter questions/ajustements souhaités
3. Discuter modifications avant application

### Option B : Application partielle

1. Choisir 1-2 fichiers à tester (ex: APP_TEMPLATE + VERSIONING_RULES)
2. Appliquer sur github_notes seulement
3. Valider en usage réel 1-2 semaines
4. Étendre aux autres apps si OK

### Option C : Application complète

1. Valider tous brouillons
2. Refactorer github_notes/APP.md avec nouvelle structure
3. Mettre à jour CHANGELOG.md format
4. Documenter dans .github/copilot-instructions.md
5. Créer template réutilisable pour nouvelles apps

---

## ❓ Questions ouvertes

- **Parking Lot** : Garder ou simplifier (peut être overkill pour solo dev) ?
- **Issues locales** : Reset numérotation à chaque version ou continu ?
- **GitHub CLI** : Installation maintenant ou attendre besoin réel ?
- **Automation** : Script Python release notes utile ou copier-coller suffit ?
- **Tagging Git** : Systématique ou seulement releases majeures ?

---

**Maintainer** : @sedounet  
**Statut** : BROUILLONS EN ÉTUDE — Ne pas appliquer sans validation
