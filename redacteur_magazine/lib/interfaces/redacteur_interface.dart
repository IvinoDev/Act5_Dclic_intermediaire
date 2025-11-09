import 'package:flutter/material.dart';
import '../modele/redacteur.dart';
import '../database/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _databaseManager = DatabaseManager();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  // Charger tous les rédacteurs depuis la base de données
  Future<void> _chargerRedacteurs() async {
    final redacteurs = await _databaseManager.getAllRedacteurs();
    setState(() {
      _redacteurs = redacteurs;
    });
  }

  // Ajouter un rédacteur
  Future<void> _ajouterRedacteur() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _afficherMessage('Veuillez remplir tous les champs');
      return;
    }

    final redacteur = Redacteur.sansId(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );

    await _databaseManager.insertRedacteur(redacteur);
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    await _chargerRedacteurs();
    _afficherMessage('Rédacteur ajouté avec succès');
  }

  // Modifier un rédacteur
  Future<void> _modifierRedacteur(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le rédacteur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomController.text.isEmpty ||
                  prenomController.text.isEmpty ||
                  emailController.text.isEmpty) {
                return;
              }

              final redacteurModifie = Redacteur(
                id: redacteur.id,
                nom: nomController.text,
                prenom: prenomController.text,
                email: emailController.text,
              );

              await _databaseManager.updateRedacteur(redacteurModifie);
              await _chargerRedacteurs();

              if (context.mounted) {
                Navigator.pop(context);
                _afficherMessage('Rédacteur modifié avec succès');
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  // Supprimer un rédacteur
  Future<void> _supprimerRedacteur(int id) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce rédacteur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirme == true) {
      await _databaseManager.deleteRedacteur(id);
      await _chargerRedacteurs();
      _afficherMessage('Rédacteur supprimé avec succès');
    }
  }

  // Afficher un message
  void _afficherMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos - Gestion des Rédacteurs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compteur de rédacteurs
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people, color: Colors.blue, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      'Nombre de rédacteurs : ${_redacteurs.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Formulaire d'ajout
            const Text(
              'Ajouter un nouveau rédacteur',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ajouterRedacteur,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un rédacteur'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Liste des rédacteurs
            const Text(
              'Liste des rédacteurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _redacteurs.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun rédacteur enregistré',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _redacteurs.length,
                      itemBuilder: (context, index) {
                        final redacteur = _redacteurs[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                redacteur.prenom[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              '${redacteur.prenom} ${redacteur.nom}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(redacteur.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () =>
                                      _modifierRedacteur(redacteur),
                                  tooltip: 'Modifier',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _supprimerRedacteur(redacteur.id!),
                                  tooltip: 'Supprimer',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterRedacteur,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
