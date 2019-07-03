import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class TaskEditor extends StatefulWidget {
  final Task task;
  TaskEditor( {@required this.task} );
  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Task task = widget.task ;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: new IconThemeData(color: AppColors.SECONDARY),
          title: Text("Tarefa",
              style: TextStyle(color: AppColors.SECONDARY, fontSize: 22)),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (_formState.currentState.validate()) {
                  _formState.currentState.save();
                  task.state = 1;
                  await TaskRepository.get().save(task);
                  Navigator.pop(context);
                }
              },
              child:
                  Text("SALVAR", style: TextStyle(color: AppColors.SECONDARY)),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            color: AppColors.PRIMARY_LIGHT,
            child: ListView(
              children: <Widget>[
                Form(
                  autovalidate: false,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Nome",
                              labelStyle: TextStyle(color: AppColors.SECONDARY),
                              counterStyle:
                                  TextStyle(color: AppColors.SECONDARY),
                              errorBorder: InputBorder.none),
                          maxLength: 80,
                          initialValue: task.name,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            return value.isEmpty ? "Requerido *" : null;
                          },
                          onSaved: (value) {
                            task.name = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Instruções",
                              labelStyle: TextStyle(color: AppColors.SECONDARY),
                              counterStyle:
                                  TextStyle(color: AppColors.SECONDARY),
                              errorBorder: InputBorder.none),
                          minLines: 4,
                          maxLines: 8,
                          initialValue: task.guidelines,
                          maxLength: 4000,
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) {
                            task.guidelines = value;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () async {
                                if (_formState.currentState.validate()) {
                                  _formState.currentState.save();
                                  task.state = 1;
                                  await TaskRepository.get().save(task);
                                  Navigator.pop(context);
                                }
                              },
                              color: AppColors.SECONDARY,
                              textColor: Colors.white,
                              child: Text("Salvar",
                                  style: TextStyle(fontSize: 16)),
                            ))
                      ])),
                  key: _formState,
                ),
              ],
            )));
  }
}
