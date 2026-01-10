# User Notes — Money Tracker

*Espace perso pour mes notes d'utilisation quotidienne*

---

## Notes UI/UX

**UI inspirations** :
- Voir Financisto (https://github.com/dsolonenko/financisto) pour disposition cartes opération

**Home screen** :
- Passer liste opérations au-dessus boutons et soldes
- Vérifier FAB correspondance avec styleguide + github-notes (diff couleur/taille)

**Cartes opération** :
- Au clic : menu avec icône grande + descriptif en sous-titre (police petite)
- Disposition boutons : ligne ou grille (selon nombre)

**Dialog ajout opération** :
- Supprimer dropdown type (revenu/dépense/virement)
- Placer bouton switch devant ligne montant pour changer type en 1 clic
- Ordre champs : note au-dessus montant, date sous montant
- Mode paiement : temporairement masqué, dans options avancées

**Statut opération** :
- Discuter visuel statut : case à cocher ou changement couleur ?

---

## Notes logique

**Virements** :
- Fonctionnement actuel pas optimal
- Idée : dissocier temporairement virement des opérations
- Utiliser héritage classe Opération pour faciliter maintenance

---

[Autres notes...]