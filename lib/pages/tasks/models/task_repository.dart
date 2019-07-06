import 'package:faxinapp/db/app_database.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

class TaskRepository {
  static final TaskRepository _taskRepository =
      TaskRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  TaskRepository._internal(this._appDatabase);

  static TaskRepository get() {
    return _taskRepository;
  }

  Future<bool> save(Task task) async {
    var db = await _appDatabase.getDb();

    if (task.id == null || task.id == 0) {
      task.id = await db.insert(
        TaskTable.table,
        {
          TaskTable.NAME: task.name,
          TaskTable.UUID: task.uuid,
          TaskTable.GUIDELINES: task.guidelines,
          TaskTable.STATE: task.state,
        },
      );
    } else {
      await db.update(
        TaskTable.table,
        {
          TaskTable.NAME: task.name,
          TaskTable.UUID: task.uuid,
          TaskTable.GUIDELINES: task.guidelines,
          TaskTable.STATE: task.state,
        },
        where: '${TaskTable.ID} = ? ',
        whereArgs: [task.id],
      );
    }

    return true;
  }

  Future delete(Task task) async {
    var db = await _appDatabase.getDb();

    return await db.update(TaskTable.table, {TaskTable.STATE: 0},
        where: TaskTable.ID + " = ? ", whereArgs: [task.id]);
  }

  Future<List<Task>> findAll() async {
    var db = await _appDatabase.getDb();

    var result = await db.query(TaskTable.table,
        where: "${TaskTable.STATE} = 1", orderBy: TaskTable.NAME);

    List<Task> tasks = List();

    for (Map<String, dynamic> item in result) {
      tasks.add(Task.fromMap(item));
    }

    return tasks;
  }

  Future import(List<Task> tasks) async {
    var db = await _appDatabase.getDb();

    tasks.forEach((t) async {
      var result = await db.query(TaskTable.table,
          where: "${TaskTable.UUID} = ?", whereArgs: [t.uuid]);

      if (result.isNotEmpty) {
        t.id = result.first['id'];
      } else {
        t.id = null;
      }

      await save(t);
    });
  }
}
