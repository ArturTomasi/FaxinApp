import 'package:faxinapp/db/app_database.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskRepository
{
  static final TaskRepository _taskRepository = TaskRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  //private internal constructor to make it singleton
  TaskRepository._internal(this._appDatabase);

  static TaskRepository get() {
    return _taskRepository;
  }

  Future<bool> save(Task task) async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery(
        "SELECT * FROM ${TaskTable.table} WHERE ${TaskTable.name} LIKE '${task.name}'");
    if (result.length == 0) {
      return await update(task).then((value) {
        return false;
      });
    } else {
      return true;
    }
  }

  Future update(Task task) async {
    var db = await _appDatabase.getDb();
    await db.transaction((Transaction txn) async {
      await txn.rawInsert('INSERT OR REPLACE INTO '
          '${TaskTable.table}(${TaskTable.name})'
          ' VALUES("${task.name}")');
    });
  }

  Future delete(Task task) async {
    var db = await _appDatabase.getDb();
    
    return await db.delete( TaskTable.table, where: TaskTable.id + " = ? ", whereArgs: [task.id] );
  }

  Future<List<Task>> findAll() async {
    var db = await _appDatabase.getDb();
    var result = await db.rawQuery('SELECT * FROM ${TaskTable.table}');
    List<Task> tasks = List();
    for (Map<String, dynamic> item in result) {
      tasks.add(Task.fromMap(item));
    }
    return tasks;
  }
}