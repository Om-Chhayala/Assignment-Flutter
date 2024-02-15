import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trying_movie_pp/models/movie_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_ffi.dart

// Initialize the database factory
void initDatabase() {
  sqfliteFfiInit(); // Initialize the FFI layer
  databaseFactory = databaseFactoryFfi;
}

class MovieDatabaseHelper {
  static final MovieDatabaseHelper instance = MovieDatabaseHelper._init();

  static Database? _database;

  MovieDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movie_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE movies(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      overview TEXT,
      releaseDate TEXT,
      popularity REAL,
      posterPath TEXT,
      backdropPath TEXT,
      originalLanguage TEXT,
      originalTitle TEXT,
      adult INTEGER,
      video INTEGER,
      voteAverage REAL,
      voteCount INTEGER,
    )
  ''');
  }

  Future<int> insertMovie(MovieModel movie) async {
    try {
      final db = await instance.database;
      return await db.insert('movies', movie.toMap());
    } catch (e) {
      throw Exception('Error adding movie to favorites: $e');
    }
  }

  // Add other methods for CRUD operations as needed

  Future<List<MovieModel>> getMovies() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('movies');

    // Convert List<Map<String, dynamic>> to List<MovieModel>
    return List.generate(maps.length, (i) {
      return MovieModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        overview: maps[i]['overview'],
        releaseDate: maps[i]['releaseDate'],
        popularity: maps[i]['popularity'],
        posterPath: maps[i]['posterPath'],
        backdropPath: maps[i]['backdropPath'],
        originalLanguage: maps[i]['originalLanguage'],
        originalTitle: maps[i]['originalTitle'],
        adult: maps[i]['adult'] == 1 ? true : false,
        video: maps[i]['video'] == 1 ? true : false,
        voteAverage: maps[i]['voteAverage'],
        voteCount: maps[i]['voteCount'],
      );
    });
  }

  Future<int> deleteMovie(int id) async {
    final db = await instance.database;
    return await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
