import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/widgets/task_editor.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskBloc _bloc = BlocProvider.of(context);
    _bloc.refresh();

    return StreamBuilder<List<Task>>(
      stream: _bloc.tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 100,
                  color: AppColors.SECONDARY,
                ),
              ),
            );
          }
          return TaskListWidget(snapshot.data);
        } else {
          return Container(
            color: AppColors.PRIMARY_LIGHT,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
              if (direction == DismissDirection.endToStart) {
                TaskBloc _bloc = BlocProvider.of<TaskBloc>(context);
                _bloc.delete(_tasks[i]);
                _bloc.refresh();

                Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.SECONDARY,
                    content: Text(
                      "Tarefa excluida com sucesso!",
                      style: TextStyle(fontSize: 16),
                    )));
              }
            },
            background: Container(
              color: Colors.red,
              child:
                  ListTile(trailing: Icon(Icons.delete, color: Colors.white)),
            ),
            child: ListTile(
              onTap: () async {
                await Navigator.of(context).push(
                  new AnimateRoute(
                    fullscreenDialog: true,
                    builder: (c) => TaskEditor(
                      task: _tasks[i],
                    ),
                  ),
                );
                BlocProvider.of<TaskBloc>(context).refresh();
              },
              leading: new Icon(
                Icons.fitness_center,
                color: AppColors.SECONDARY,
              ),
              subtitle: new Text(
                _tasks[i].guidelines,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: new Text(
                _tasks[i].name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
