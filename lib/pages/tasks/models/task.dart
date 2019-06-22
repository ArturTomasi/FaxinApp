class Task {
  int id;
  String name;
  String guidelines;
  int state;

  Task();

  Task.fromMap(Map<String, dynamic> map) {
    id = map[TaskTable.ID];
    name = map[TaskTable.NAME];
    guidelines = map[TaskTable.GUIDELINES];
    state = map[TaskTable.STATE];
  }

  bool operator(o) => o is Task && o.id == id;

  @override
  String toString() => name;
}

class TaskTable {
  static const table = "tasks";
  static const ID = "id";
  static const NAME = "name";
  static const GUIDELINES = "guidelines";
  static const STATE = "state";
}
