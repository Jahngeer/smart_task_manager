import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _db;

  DBHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("tasks.db");
    return _db!;
  }

  Future<Database> _initDB(String file) async {
    final path = join(await getDatabasesPath(), file);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query("tasks");
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert("tasks", task.toMap());
  }

  Future updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      "tasks",
      task.toMap(),
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      "tasks",
      where: "id=?",
      whereArgs: [id],
    );
  }
}