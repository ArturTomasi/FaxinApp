class Task{
  int id;
  String name = "";
  String guidelines = "";
  int state = 1;

  Task();

  Task.fromMap(Map<String, dynamic> map) {
    id = map[TaskTable.ID];
    name = map[TaskTable.NAME];
    guidelines = map[TaskTable.GUIDELINES];
    state = map[TaskTable.STATE];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
  
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
