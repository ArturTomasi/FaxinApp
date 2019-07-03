import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/widgets/task_editor.dart';
import 'package:faxinapp/pages/tasks/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TaskBloc _bloc = BlocProvider.of<TaskBloc>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Tarefas"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                new AnimateRoute(
                  fullscreenDialog: true,
                  builder: (c) => TaskEditor(
                        task: Task(),
                      ),
                ),
              );
              _bloc.refresh();
            }),
        body: BlocProvider(bloc: _bloc, child: TaskList()));
  }
}
