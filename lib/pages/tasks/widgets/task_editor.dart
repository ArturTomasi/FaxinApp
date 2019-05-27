import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class TaskEditor extends StatelessWidget {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TaskBloc _bloc = BlocProvider.of(context);
    final Task task = Task.create("");

    return Container(
        decoration: ShapeDecoration(
            color: AppColors.PRIMARY_LIGHT,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              side: new BorderSide(
                  color: AppColors.SECONDARY,
                  style: BorderStyle.solid,
                  width: 1),
            )),
        height: 150,
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
                          counterStyle: TextStyle(color: AppColors.SECONDARY),
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
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () async {
                            if (_formState.currentState.validate()) {
                              _formState.currentState.save();
                              await _bloc.save(task);
                              Navigator.pop(context);
                              _bloc.refresh();
                            }
                          },
                          color: AppColors.SECONDARY,
                          textColor: Colors.white,
                          child: Text("Salvar", style: TextStyle(fontSize: 16)),
                        ))
                  ])),
              key: _formState,
            ),
          ],
        ));
  }
}
