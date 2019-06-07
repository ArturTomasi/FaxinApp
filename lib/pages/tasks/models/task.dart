import 'package:meta/meta.dart';

class Task {
  int id;
  String name;

  Task.create(this.name);

  Task.update({@required this.id, name = ""}) {
    if (name != "") {
      this.name = name;
    }
  }

  bool operator(o) => o is Task && o.id == id;

  Task.fromMap(Map<String, dynamic> map)
      : this.update(id: map[TaskTable.id], name: map[TaskTable.name]);

  @override
  String toString() => name;
}

class TaskTable {
  static final table = "tasks";
  static final id = "id";
  static final name = "name";
}
