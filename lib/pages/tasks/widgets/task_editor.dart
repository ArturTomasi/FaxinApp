import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class TaskEditor extends StatelessWidget {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = BlocProvider.of(context);

    String taskName = "";

    taskBloc.exists.listen((isExist) {
      if (isExist) {
        _scaffoldState.currentState
            .showSnackBar(SnackBar(content: Text("Tarefa já foi criada!")));
      } else {
        Navigator.pop(context);
      }
    });

    return Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text("Nova Tarefa"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_formState.currentState.validate()) {
                _formState.currentState.save();
                var task = Task.create(taskName);
                taskBloc.save(task);
              }
            }),
        body: Container(
          color: AppColors.PRIMARY_LIGHT,
          child: ListView(
            children: <Widget>[
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration( 
                      counterStyle: TextStyle( color: AppColors.SECONDARY), 
                      hintText: "Nome da Tarefa", 
                      hintStyle: TextStyle( color: Colors.white ) ),
                    maxLength: 80,
                    style: TextStyle( color: Colors.white ),
                    validator: (value) {
                      return value.isEmpty
                          ? "Nome da tarefa não pode ser vazio"
                          : null;
                    },
                    onSaved: (value) {
                      taskName = value;
                    },
                  ),
                ),
                key: _formState,
              )
            ],
          ),
        ));
  }
}
