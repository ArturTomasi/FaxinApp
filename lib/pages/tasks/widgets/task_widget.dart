import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/widgets/task_editor.dart';
import 'package:faxinapp/pages/tasks/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TaskBloc _bloc = BlocProvider.of<TaskBloc>(context);
    _bloc.showCreate(true);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Tarefas"),
        ),
        floatingActionButton: StreamBuilder<bool>(
            stream: _bloc.showFAB,
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data) {
                return FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      _bloc.showCreate(false);
                      await _scaffoldKey.currentState.showBottomSheet((b) => TaskEditor()).closed;
                      _bloc.showCreate(true);
                    });
              }
              return Container();
            }),
        body: BlocProvider(bloc: _bloc, child: TaskList()));
  }
}
