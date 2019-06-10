import 'package:faxinapp/common/ui/selection_dialog.dart';
import 'package:faxinapp/common/ui/selection_picker.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class CleaningEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CleaningEditorState();
}

class _CleaningEditorState extends State<CleaningEditor> {
  Cleaning cleaning;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  _CleaningEditorState() {
    this.cleaning = Cleaning.create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
        title: Text("Nova Faxina",
            style: TextStyle(color: AppColors.SECONDARY, fontSize: 22)),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              bool valid = cleaning.tasks != null &&
                  cleaning.tasks.isNotEmpty &&
                  cleaning.products != null &&
                  cleaning.products.isNotEmpty &&
                  _formState.currentState.validate();

              if (valid) {
                _formState.currentState.save();

                await CleaningRepository.get().save(cleaning);

                Navigator.of(context).pop(cleaning);
              }
            },
            child: Text("SALVAR", style: TextStyle(color: AppColors.SECONDARY)),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          color: AppColors.PRIMARY_LIGHT,
          child: SafeArea(
            right: true,
            left: true,
            child: Form(
              key: _formState,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Título",
                        labelStyle: TextStyle(color: AppColors.SECONDARY),
                        counterStyle: TextStyle(color: AppColors.SECONDARY),
                        errorBorder: InputBorder.none),
                    maxLength: 80,
                    initialValue: cleaning.title,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      return value.isEmpty ? "Requerido *" : null;
                    },
                    onSaved: (value) {
                      cleaning.title = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Descrição",
                        labelStyle: TextStyle(color: AppColors.SECONDARY),
                        counterStyle: TextStyle(color: AppColors.SECONDARY),
                        errorBorder: InputBorder.none),
                    minLines: 4,
                    maxLines: 8,
                    initialValue: cleaning.info,
                    maxLength: 4000,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      return value.isEmpty ? "Requerido *" : null;
                    },
                    onSaved: (value) {
                      cleaning.info = value;
                    },
                  ),
                  FutureBuilder<List<Product>>(
                      future: ProductRepository.get().findAll(),
                      builder: (x, y) => SelectionPicker<Product>(
                            onChanged: (value) {
                              cleaning.products = value;
                            },
                            title: "Produtos",
                            selecteds: cleaning.products,
                            renderer: ProductSelector(),
                            elements: y.data,
                          )),
                  FutureBuilder<List<Task>>(
                      future: TaskRepository.get().findAll(),
                      builder: (x, y) => SelectionPicker<Task>(
                            onChanged: (value) {
                              cleaning.tasks = value;
                            },
                            title: "Tarefas",
                            selecteds: cleaning.tasks,
                            renderer: TaskSelector(),
                            elements: y.data,
                          ))
                ],
              ),
            ),
          )),
    );
  }
}

class ProductSelector implements ItemRenderer<Product> {
  @override
  Widget renderer(Product p, bool sel) {
    return Container(
        alignment: Alignment(-0.8, 0),
        height: 50,
        color: !sel ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
        child: Text(
            p.name.substring(0, 1).toUpperCase() +
                p.name.substring(1, p.name.length).toLowerCase(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}

class TaskSelector implements ItemRenderer<Task> {
  @override
  Widget renderer(Task p, bool sel) {
    return Container(
        alignment: Alignment(-0.8, 0),
        height: 50,
        color: !sel ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
        child: Text(
            p.name.substring(0, 1).toUpperCase() +
                p.name.substring(1, p.name.length).toLowerCase(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}
