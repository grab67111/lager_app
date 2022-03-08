import 'package:note_app_flutter_sqflite_provider/models/label.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'note_app.db';

  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb(dbName);

    return _database!;
  }

  _initDb(String dbName) async {
    var appDir = await getApplicationDocumentsDirectory();

    String path = join(appDir.path, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $noteTable (
              ${NoteField.id_a} INTEGER PRIMARY KEY,
              ${NoteField.a_title} TEXT, 
              ${NoteField.a_content} TEXT, 
              ${NoteField.labels_id} TEXT,
              ${NoteField.imagePaths} TEXT,
              ${NoteField.bgcolors_id} INTEGER, 
              ${NoteField.a_time_create} TEXT
            )
          ''');

        await db.execute('''
            CREATE TABLE $labelTable (
              ${LabelField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
              ${LabelField.title} TEXT
            )
          ''');
      },
    );
  }
}
