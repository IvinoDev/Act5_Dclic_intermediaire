# Magazine Infos - Gestion des Rédacteurs

Application Flutter complète de gestion des rédacteurs avec base de données SQLite.

## 📱 Fonctionnalités

- ✅ Ajouter un rédacteur (nom, prénom, email)
- ✅ Afficher la liste de tous les rédacteurs
- ✅ Modifier les informations d'un rédacteur
- ✅ Supprimer un rédacteur avec confirmation
- ✅ Compteur du nombre de rédacteurs enregistrés
- ✅ Persistance des données avec SQLite
- ✅ Interface moderne et responsive

## 🏗️ Architecture

L'application suit une architecture MVC simple :

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── modele/
│   └── redacteur.dart          # Modèle de données Redacteur
├── database/
│   └── database_manager.dart   # Gestion de la base SQLite
└── interfaces/
    └── redacteur_interface.dart # Interface utilisateur principale
```

## 🚀 Installation

1. Cloner le projet
2. Installer les dépendances :
```bash
flutter pub get
```

3. Lancer l'application :
```bash
flutter run
```

## 📦 Dépendances

- `sqflite: ^2.3.0` - Base de données SQLite
- `path_provider: ^2.1.1` - Gestion des chemins de fichiers

## 💾 Base de données

- **Nom** : `redacteurs.db`
- **Table** : `redacteurs`
- **Colonnes** :
  - `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
  - `nom` (TEXT NOT NULL)
  - `prenom` (TEXT NOT NULL)
  - `email` (TEXT NOT NULL)

## 🎨 Interface

L'interface comprend :
- Un compteur de rédacteurs en haut de page
- Un formulaire d'ajout avec 3 champs (nom, prénom, email)
- Un bouton "Ajouter un rédacteur"
- Une liste scrollable des rédacteurs avec :
  - Avatar avec initiale du prénom
  - Nom complet et email
  - Bouton de modification (✏️)
  - Bouton de suppression (🗑️)
- Un bouton flottant pour ajouter rapidement

## ✨ Fonctionnement

### Ajouter un rédacteur
1. Remplir les champs nom, prénom et email
2. Cliquer sur "Ajouter un rédacteur" ou le bouton flottant
3. Les champs se vident automatiquement
4. La liste se met à jour

### Modifier un rédacteur
1. Cliquer sur l'icône ✏️ du rédacteur
2. Modifier les informations dans la boîte de dialogue
3. Cliquer sur "Enregistrer"
4. La liste se met à jour

### Supprimer un rédacteur
1. Cliquer sur l'icône 🗑️ du rédacteur
2. Confirmer la suppression
3. La liste se met à jour

## 📝 Notes

- Les données sont persistantes et restent après fermeture de l'application
- Validation des champs obligatoires avant ajout/modification
- Messages de confirmation pour chaque action (SnackBar)
- Interface responsive adaptée à différentes tailles d'écran
