import 'dart:async';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';

class TaskBloc implements BlocBase {
  StreamController<List<Task>> _taskController =
      StreamController<List<Task>>.broadcast();
  Stream<List<Task>> get tasks => _taskController.stream;

  StreamController<bool> _taskExistController =
      StreamController<bool>.broadcast();
  Stream<bool> get exists => _taskExistController.stream;

  @override
  void dispose() {
    _taskController.close();
    _taskExistController.close();
  }

  TaskRepository _repository;

  TaskBloc(this._repository) {
    _load();
  }

  void _load() {
    _repository.findAll().then((tasks) {
      _taskController.sink.add(List.unmodifiable(tasks));
    });
  }

  void refresh() {
    if ( ! _taskController.isClosed ) _load();
  }

  void delete( Task task ){
    _repository.delete( task );
    refresh();
  }

  void save(Task task) async {
    _repository.save(task).then((isExist) {
      if ( ! _taskController.isClosed )
        _taskExistController.sink.add(isExist);
    });
  }
}
