# PROMPTS — Timer App

> **Usage** : Écris en langage naturel ce que tu veux réaliser. Copilot transformera ça en prompt structuré.

---

## � Ce que je veux faire

<!-- Décris librement ce que tu veux accomplir, comme si tu parlais à quelqu'un -->
nous allons commencer par les deux pages prinipales du timer. la page principale avec le timer et les boutons play/pause/reset, et la page des paramètres avec les options son et vibration.

la page timer doit afficher le temps restant, un champ pour saisir la durée (en format numérique ou hh:mm:ss), et les boutons play, pause, reset en dessous.

la saisie se fait par selection du champ numérique qui ouvre un clavier numérique. la saisie se fait au format hh:mm:ss avec une limite de 12h au maximum. 

la saisie doit etre validee. si l'utilisateur entre par exemple 1:65:00, il faut corriger en 2:05:00 automatiquement. si l'utilisateur entre plus de 12h, on bloque la saisie et on affiche un message d'erreur non bloquant.

a rediscuter le meilleur moyen d'implementer la saisie et la gestion des erreurs et validation

**Exemple** :
```
Je veux ajouter un système de notifications enrichies au timer. 
Quand le timer tourne, l'utilisateur doit pouvoir voir le temps restant 
dans la barre de notification et avoir deux boutons : Pause et Stop.

Le design doit respecter le styleguide Dotlyn (orange pour les actions principales).
Ça doit marcher sur Android 12+.

Après avoir codé ça, je veux que la doc soit à jour et que tout soit committé 
proprement sur une nouvelle branche.
```

**Ce que je veux** :
```
[ÉCRIS ICI EN LANGAGE NATUREL]


```

---

## 🖼️ Maquette ou capture (optionnel)

<!-- Si tu as une image ou un lien vers une maquette, mets-le ici -->

**Exemple** :
```
Voir capture : _docs/apps/timer/assets/mockup-notifications.png
Référence : notification Android Material You
```

**Mes références visuelles** :
```
[OPTIONNEL - image path ou description visuelle]


```

---

## 🚨 Points d'attention particuliers (optionnel)

<!-- Si tu as des trucs spécifiques à ne pas oublier, note-les ici -->

**Exemple** :
```
- Je veux que ça marche même quand l'app est en background
- Attention, j'ai eu un bug avant avec les permissions Android 13
- Privilégier la simplicité, on verra les features avancées plus tard
```

**Mes points d'attention** :
```
[OPTIONNEL]


```

---

## � Workflow

1. **Tu remplis** la section "Ce que je veux faire" en langage naturel
2. **Tu me dis** : "Rédige le prompt pour cette demande"
3. **Je génère** un prompt structuré complet (objectif, instructions, contraintes, validation, etc.)
4. **Tu valides** ou demandes des ajustements
5. **Tu me donnes** le prompt final à exécuter (ou tu le donnes à GPT-4)

---

**Dernière mise à jour** : 2025-11-12  
**Statut** : READY
