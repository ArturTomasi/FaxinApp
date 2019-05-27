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

  StreamController<bool> _showFABController =
      StreamController<bool>.broadcast();

  Stream<bool> get showFAB => _showFABController.stream;

  @override
  void dispose() {
    _taskController.close();
    _showFABController.close();
    _taskExistController.close();
  }

  TaskRepository _repository;

  TaskBloc() {
    this._repository = TaskRepository.get();
  }

  void refresh() async {
    _taskController.sink.add(await _repository.findAll());
  }

  void delete(Task task) {
    _repository.delete(task);
  }

  Future save(Task task) async {
    await _repository.save(task);
  }

  void showCreate( bool b ){
    _showFABController.sink.add(b);
  }
}
