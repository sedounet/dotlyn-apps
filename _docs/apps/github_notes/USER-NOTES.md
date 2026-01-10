# User Notes — GitHub Notes

*Espace perso pour mes notes d'utilisation quotidienne*

---

## 10/01/26 - Tests smoke v0.1

**Ce qui marche** :
- Token invalide détecté OK
- Sync tel <-> github OK
- Duplicate file OK (ouvre dialog avec prefill)
- 2 fichiers configurés, chacun sync indépendamment

**Bugs trouvés** :
- Sync en mode avion : pas de message d'erreur, fichier reste "modified"
- Theme switch : message "light activé" mais UI change pas

**Idées amélio** :
- Export settings (backup config en JSON)
- Refactorer Settings avec sections foldables (token, files, prefs)
- Petits ? d'aide sur les champs du dialog Add File

---

## 03/01/26 - Notes vrac

- Message succès config masqué par boutons → déplacer snackbar ou boutons
- Duplicate button implémenté ✅
- Vérifier concordance themes entre github_notes et money_tracker (dark mode)
- Support autres plateformes (GitLab, etc.) → long terme, pas prioritaire

---

## 08/01/26 - Icons

Adaptive icons + android_12 testés sur emu API 30 + device API 35 → OK

---

[Autres notes...]
