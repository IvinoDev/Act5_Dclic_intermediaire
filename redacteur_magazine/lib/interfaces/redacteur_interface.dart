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
    const primaryColor = Color(0xFFE91E63);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text(
          'Gestion des rédacteurs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ Nom
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Champ Prénom
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Champ Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _ajouterRedacteur,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Ajouter un Rédacteur',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Liste des rédacteurs
              Expanded(
                child: _redacteurs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun rédacteur enregistré',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _redacteurs.length,
                        itemBuilder: (context, index) {
                          final redacteur = _redacteurs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Text(
                                  redacteur.prenom[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${redacteur.prenom} ${redacteur.nom}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  redacteur.email,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    color: Colors.grey[700],
                                    onPressed: () =>
                                        _modifierRedacteur(redacteur),
                                    tooltip: 'Modifier',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.grey[700],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterRedacteur,
        backgroundColor: primaryColor,
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
