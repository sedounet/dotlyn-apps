# Workflow — Gestion des icônes & logo (Dotlyn Apps)

## 1. Source unique
- Place le logo/icône source (SVG ou PNG 1024x1024) dans :
  `_docs/apps/[nom_app]/assets/icon.png`
  (ou `logo.svg` si vectoriel)

## 2. Convention de nommage
- Toujours nommer :
  - Icône principale : `icon.png`
  - Logo UI/splash (optionnel) : `logo.png` ou `logo.svg`

## 3. Génération automatique
- Ajoute dans le `pubspec.yaml` de l’app :
  ```yaml
  dev_dependencies:
    flutter_launcher_icons: ^0.13.1
    flutter_native_splash: ^2.3.2

  flutter_launcher_icons:
    android: true
    ios: true
    image_path: "../../_docs/apps/[nom_app]/assets/icon.png"

  flutter_native_splash:
    image: "../../_docs/apps/[nom_app]/assets/logo.png"
    color: "#FFFFFF"
  ```
- Lance :
  ```bash
  flutter pub run flutter_launcher_icons
  flutter pub run flutter_native_splash:create
  ```

## 4. Intégration à la création d’app
- Lors de la création d’une nouvelle app, copie le template d’icône/logo depuis `_docs/apps/[nom_app]/assets/` vers le dossier assets de l’app.
- Renomme si besoin selon le schéma ci-dessus.

## 5. Rappel
- Couleurs : #E36C2D (orange) ou #2C2C2C (gris foncé), opacité 100%
- Un seul fichier source = moins d’erreurs, tout est automatisé
