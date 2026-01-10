ui : voir les ui de financisto (https://github.com/dsolonenko/financisto) et reprendre la disposition des cartes d'opération dans la liste.

uI : home screen : passer la liste des opérations au dessus des boutons et soldes
voir et vérifier correspondance des fab par rapport au style guide et a l'appli github-notes (différence de couleur et de taille)

ui : cartes d'opération : au clic on affiche un menu. modifier les boutons du menu pour afficher une icône plus grande et le descriptif en sous titre de l'icône avec une police plus petite. disposition des boutons en ligne ou grille (évolution éventuelle du nombre de boutons). 

ui : dialog d'ajout d'opération:
suprimer le drop-down de choix du type d'opération (revenu, dépense, virement) et placer un bouton switch de modification devant la ligne du montant. cela permettra de changer le type en un clic. 

logique : le fonctionnement du virement n'est pas optimal. tel que gère actuellement. dissocier temporairement le virement des opérations. on utilisera un héritage de la classe opération pour cette opération. cela facilitera la maintenance.

ui : dialog d'ajout d'opération:
placer la ligne note au dessus du montant. la date sous le montant. enlever temporairement le mode de paiement de l'ui ainsi que les options avancées. insérer le mode de paiement dans les options avancées 

ui : élément de liste d'opération : discuter d'un moyen d'avoir un visuel sur les statuts d'opération (case à cocher, changement de couleur?)

smoke pc navigateur vers tel
