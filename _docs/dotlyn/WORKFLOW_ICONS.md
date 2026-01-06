# Workflow — Gestion des icônes & logo (Dotlyn Apps)

## 1. Source unique
- **Logo master** : `_docs/dotlyn/brand-assets/DotLyn-logo.png` (source SVG dans le même dossier)
- **Icon app-specific** : `_docs/apps/[nom_app]/assets/Dotlyn-app-icon-[nom_app].png` (optionnel)
- **Format source** : SVG pour édition, PNG 1024×1024 pour génération

## 2. Convention de nommage
- **Logo** = identité Dotlyn (DotLyn-logo.png) → utilisé pour launcher icon ET splash screen
- **Icon** = icône spécifique app (Dotlyn-app-icon-[app].png) → uniquement si customisation nécessaire

## 3. Export PNG depuis SVG (si nécessaire)
```bash
# Avec Inkscape (installé sur C:\Program Files\Inkscape\bin\inkscape.com)
& "C:\Program Files\Inkscape\bin\inkscape.com" --export-type=png --export-filename="_docs/dotlyn/brand-assets/DotLyn-logo.png" --export-width=1024 --export-height=1024 "_docs/dotlyn/brand-assets/DotLyn-logo.svg"
```

## 4. Génération automatique avec Adaptive Icons (Android)

**⚠️ Important** : Sur Android, utiliser **adaptive icons** pour éviter l'effet "carré dans cercle" avec fond blanc visible.

### Configuration pubspec.yaml
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.4.7

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/DotLyn-logo.png"
  remove_alpha_ios: true
  # Configuration adaptive pour Android (évite les bords blancs dans les masques circulaires)
  adaptive_icon_foreground: "assets/DotLyn-logo.png"
  adaptive_icon_background: "#F8F8F8"  # Couleur de fond adaptative

flutter_native_splash:
  image: "assets/DotLyn-logo.png"
  color: "#F8F8F8"  # Fond du splash
  android: true
  ios: true
  web: true
```

### Commandes de génération
```bash
cd apps/[nom_app]
flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Tester sur device
```bash
flutter run --release -d <device-id>
```

## 5. Intégration à la création d'une nouvelle app

### Étape 1 : Copier le logo dans assets
```bash
# Depuis la racine du monorepo
Copy-Item "_docs/dotlyn/brand-assets/DotLyn-logo.png" "apps/[nom_app]/assets/"
```

### Étape 2 : Ajouter la config dans pubspec.yaml
Copier la configuration adaptive icons ci-dessus (section 4).

### Étape 3 : Générer
```bash
cd apps/[nom_app]
flutter pub get
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Étape 4 : Vérifier
- Android : Fichiers générés dans `android/app/src/main/res/mipmap-*/` et `drawable*/`
- iOS : Fichiers générés dans `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## 6. Troubleshooting

### Icône trop petite sur Android
**Cause** : PNG avec padding excessif ou absence de configuration adaptive.  
**Solution** : Utiliser `adaptive_icon_foreground` + `adaptive_icon_background` (voir section 4).

### Splash affiche icon au lieu du logo
**Cause** : Mauvais `image_path` dans `flutter_native_splash`.  
**Solution** : Vérifier que `image:` pointe bien vers `assets/DotLyn-logo.png`.

### Fond blanc visible en mode sombre
**Cause** : Couleur de fond trop claire.  
**Solution** : Ajuster `adaptive_icon_background` avec une couleur neutre (#F8F8F8 recommandé).

## 7. Rappel — Standards Dotlyn
- **Couleurs** : #E36C2D (orange), #2C2C2C (gris foncé), #F8F8F8 (gris clair pour fonds)
- **Format source** : SVG (édition) → PNG 1024×1024 (génération)
- **Pattern** : Un seul logo master → distribution automatique → adaptive icons sur Android
