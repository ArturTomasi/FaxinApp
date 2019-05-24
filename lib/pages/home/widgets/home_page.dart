import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/home/bloc/home_bloc.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:faxinapp/pages/tasks/widgets/task_editor.dart';
import 'package:faxinapp/pages/tasks/widgets/task_list.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'home_drawer.dart';

class HomePage extends StatelessWidget {
  final TaskBloc _taskBloc = TaskBloc(TaskRepository.get());

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            initialData: 'FaxinApp',
            stream: homeBloc.title,
            builder: (context, snapshot) {
              return Text(snapshot.data, style: TextStyle(color: AppColors.SECONDARY, letterSpacing: 3.5, fontSize: 30),);
            }),
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          var blocTask = BlocProvider(
            bloc: TaskBloc(TaskRepository.get()),
            child: TaskEditor(),
          );
          await Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => blocTask),
          );

          _taskBloc.refresh();
        },
      ),
      drawer: BlocProvider( 
        bloc : _taskBloc,
        child: HomeDrawer()
      ),
      body: BlocProvider(
        bloc: _taskBloc,
        child: TaskList(),
      ),
    );
  }
}