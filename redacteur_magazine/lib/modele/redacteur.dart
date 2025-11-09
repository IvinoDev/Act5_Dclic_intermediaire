class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  // Constructeur avec id
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans id
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Convertir un Redacteur en Map
  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  // Créer un Redacteur à partir d'un Map
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
}
