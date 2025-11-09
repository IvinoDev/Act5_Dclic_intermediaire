import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  static Database? _database;

  // Getter pour la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initialiser la base de données
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'redacteurs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE redacteurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Insérer un rédacteur
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  // Récupérer tous les rédacteurs
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');

    return List.generate(maps.length, (i) {
      return Redacteur.fromMap(maps[i]);
    });
  }

  // Mettre à jour un rédacteur
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // Supprimer un rédacteur
  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
