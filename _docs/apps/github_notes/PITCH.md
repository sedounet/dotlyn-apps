# GitHub Notes — Pitch

## 🎯 Concept

**App mobile de prise de notes synchronisée avec GitHub**, conçue pour faciliter le workflow de développement avec des outils IA comme GitHub Copilot et VS Code.

Accès direct depuis smartphone aux fichiers markdown de travail (`PROMPT_USER.md`, `APP.md`, `TODO.md`) avec édition offline et sync bidirectionnelle.

---

## 🎨 Identité Visuelle

**Référence** : [`_docs/dotlyn/STYLEGUIDE.md`](../../dotlyn/STYLEGUIDE.md)

- **Couleurs primaires** : Orange terre cuite (#E36C2D) + Gris anthracite (#2C2C2C)
- **Typographie** : Satoshi (titres) + Plus Jakarta Sans (body/UI)
- **Icônes** : Material Icons (UI Flutter), Remix Icon (launcher)
- **Style** : Minimaliste, focus productivité

**Icon app** : Note + symbole GitHub stylisé, couleur orange Dotlyn

---

## 👥 Public Cible

**Développeurs mobiles solo/petites équipes** qui :
- Utilisent GitHub pour versioning et collaboration
- Travaillent avec des outils IA (Copilot, Claude, etc.)
- Prennent des notes en markdown dans leurs repos
- Ont besoin d'accès mobile rapide (dans les transports, réunions, etc.)

**Use case principal** :
> "Je suis dans le métro, j'ai une idée pour mon projet. J'ouvre l'app, je vais dans `money_tracker/PROMPT_USER.md`, j'écris mon idée, je sync. Arrivé au bureau, je lance VS Code, mes notes sont déjà là, prêtes pour Copilot."

---

## 🌟 Différenciation

**vs GitHub mobile app** :
- ✅ Édition offline-first (GitHub app nécessite connexion)
- ✅ Accès rapide aux fichiers favoris (pas de navigation repo complexe)
- ✅ Optimisé pour markdown workflow (pas pour code review)

**vs Apps notes classiques** (Notion, Obsidian mobile) :
- ✅ Intégration native GitHub (pas d'export/import)
- ✅ Versionning automatique (historique GitHub)
- ✅ Collaboration via PR/commits

**vs Éditeurs mobiles** (Joplin, iA Writer) :
- ✅ Sync GitHub direct (pas de Dropbox/iCloud)
- ✅ Structure repo respectée (chemins exacts)

---

## 📊 Métriques de Succès (v0.1)

- **Adoption** : 5+ utilisateurs actifs (team Dotlyn + amis devs)
- **Usage** : 10+ syncs/semaine par utilisateur
- **Performance** : <2s pour ouvrir un fichier (cache local)
- **Fiabilité** : 0 perte de données (sauvegarde locale toujours d'abord)

**Critère clé** : "L'app remplace 80% des fois où j'ouvre GitHub dans le navigateur mobile juste pour modifier un .md"

---

## 🚀 Roadmap Vision Longue

**v0.1** : MVP (config manuelle, sync manuelle, édition basique)  
**v0.2** : Auto-sync, détection conflits, preview markdown  
**v0.3** : OAuth GitHub, multi-comptes, historique versions  
**v1.0** : Édition collaborative (notifs temps réel), templates notes

**Potentiel** : Si succès, étendre à d'autres plateformes (GitLab, Bitbucket) ou features (gestion issues, PR drafts).

---

**Version** : 1.0  
**Date** : 2025-12-31
