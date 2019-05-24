import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = BlocProvider.of(context);

    return StreamBuilder<List<Task>>(
      stream: taskBloc.tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TaskListWidget(snapshot.data);
        } else {
          return Container( color: AppColors.PRIMARY_LIGHT, child: Center( child: CircularProgressIndicator() ) );
        }
      },
    );
  }
}

class TaskListWidget extends StatelessWidget {
  final List<Task> _tasks;

  TaskListWidget(this._tasks);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.PRIMARY_LIGHT,
        child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (BuildContext context, int i) {
              return Dismissible(
                  key: ObjectKey(_tasks[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    final TaskBloc _tasksBloc =
                        BlocProvider.of<TaskBloc>(context);
                    if (direction == DismissDirection.endToStart) {
                      _tasksBloc.delete(_tasks[i]);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors.SECONDARY,
                          content: Text("Tarefa excluida com sucesso!", style: TextStyle(fontSize: 16),)));
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: ListTile(
                      trailing: Icon(Icons.delete, color: Colors.white)
                    ),
                  ),
                  child: ListTile(
                      leading: new Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                      ),
                      title: new Text(_tasks[i].name.toUpperCase(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 20))));
            }));
  }
}
