import 'package:task_manager/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class TaskDatabase {
  static Database? db;

  static Future<Database> getDB() async {
    if (db != null) return db!;

    db = await openDatabase(
      p.join(await getDatabasesPath(), 'task.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT,title Text, isDone INTEGER)',
        );
      },
      version: 2,
    );
    return db!;
  }

  static Future<List<Task>> getTask() async {
    final db = await getDB();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.formMap(maps[i]));
  }

  static Future<void> insertTask(Task task) async {
    final db = await getDB();
    db.insert('tasks', task.toMap());
  }

  static Future<void> deleteTask(int id) async {
    final db = await getDB();
    db.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  static Future<void> updateTask(Task task) async {
    final db = await getDB();
    db.update('tasks', task.toMap(), where: 'id=?', whereArgs: [task.id]);
  }
}
