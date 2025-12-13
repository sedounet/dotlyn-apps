# Money Tracker — Demande Utilisateur

> **Instructions** : Décrivez ici en langage naturel ce que vous voulez pour l'app Money Tracker.
> Après lecture, Copilot générera un PROMPT_AI.md structuré et implémentera.

---

## 🎯 Ce que je veux

<!-- Décrivez votre vision, les fonctionnalités principales, l'UX souhaitée -->
Le suivi de dépenses et revenus doit etre le plus rapide et simple possible.
j'utilise fincancisto tout les jours, mais elle est un peu lourde, vieillissante et surtour avec beaucoup de fonctions qui me paraissent superflues pour un usage quotidien. ce genre d'app doit etre utiliable sans friction.

j'imagine bien un ecran principal avec un affichage du solde du compte "courant" a l'instant T (d'apres les entrées) et un bouton+,- et un ou deux autres pour les acces aux listes de comptes, et eventuellement 2 favoris ou 3. 
monsieur et madame tout le monde n'a pas 50 comptesn en banque, mais plutot 2 ou 3 max.

l'ecran de comppte doit afficher la liste des opérations avec un systeme de filtre par date (jour, semaine, mois, année) et par catégorie (alimentaire, transport, logement, loisirs, etc).




---

## 📱 Maquette / Inspiration

<!-- Optionnel : lien vers des captures d'écran, apps similaires, wireframes -->
Inspiration du logiciel open source en Java (il me semble) Financisto 
Lien github : https://github.com/dsolonenko/financisto
lien google play https://play.google.com/store/apps/details?id=tw.tib.financisto&hl=fr

pas de maquette. descroption textuelle de la page d'aceuil : les boutons d'ajout de en bas de l'ecran , utilisable a une seule main. le solde en haut (options pour le cacher pour confidentialité). 
liste eventuelle des dernieres operations en dessous.

tout en bas, la baniere de pubblicité.

il faudra voir a faire la roadmap des fonctions a integrer par la suite, mais l'idee est de faire une app simple, rapide, epuree, et efficace pour le suivi quotidien des comptes bancaires.

dans la mvp on doit pouvoir ajouter des comptes des categoreis et des operations.  ces operations doivent pouvoir etre modifiées et supprimées. on doit pouvoir y ajouter des beneficiaires et bien entendu des montants et des dates (par defaut la date/=heure du moment de saisie)

google analytic intégré dés le début pour suivre l'usage de l'app et ameliorer l'ux.

les categories personalisables sur une version ultérieure.
un moyen d'importer les operations a partir d'un fichier csv (export bancaire) serait un plus.

un export des doneess en csv ou backup cloud serait un plus egalement. sur video recompense afin d'aider au financement de l'app.

un ecran setting bien entendu, avec :
localisation a integrer des le debut par defaut francaise (euro, langue francaise, semaine qui commence le lundi)
option de theme sombre / clair
option de gestion de la confidentialite (masquer les montants, le solde, etc

fonction de prelevement automatique (mensuel, hebdo, etc) pour les factures recurrentes serait un plus egalement. mais attention, on doit leur mettre une recurence a partir d'une date. si j'ai mon salaire le 10 les operation automatiques apres le 10 s'ajoutent automatiquement..
par exemple j'ai le telephone le 5 du mois le loyer le 7 la box le 15 l'assurance le 20. 
je recois mon salaire le 10. a partir du 10, les operations automatiques du mois s'ajoutent automatiquement cela me cacul le soldre restatn une fois tout paye. 

le fonctionenement serait : je saisai mes prelevement recurents et les enregistre. tout les debut de mois (jours de salaire ) l'app ajoute les operations automatiques au compte.

on aura 2 soldes affhichés : le solde actuel ("reel" sans les elements qui n'on pas ete debité) et le solde "prévisionnel" (avec les prelevements automatiques a venir et les depenses enregistrees mais non passees en banque deduits)

pour des version ulterieures a voir pour des graphiques d'analyse des depenses par categorie, par mois, etc

la mvp serait un financisto au gout du jour simplifié


---

## ⚠️ Points d'attention

<!-- Contraintes techniques, points critiques, ce qu'il ne faut PAS faire -->
choix de tech important : fluidite et rapidite d'utilisation, legerete de l'ensemble. base de donnee locale rapide et legere faculemet sauvrgaedable et scalable

possibilité de mot de passe, encryption des donees a prevoir rapidement egalement.  



---

**Une fois rempli, mentionnez à Copilot de lire ce fichier et de générer PROMPT_AI.md**
