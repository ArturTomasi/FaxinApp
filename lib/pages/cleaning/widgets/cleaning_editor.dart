import 'package:faxinapp/common/ui/date_picker.dart';
import 'package:faxinapp/common/ui/selection_dialog.dart';
import 'package:faxinapp/common/ui/selection_picker.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:flutter/material.dart';

class CleaningEditor extends StatefulWidget {
  final Cleaning cleaning;

  CleaningEditor({@required this.cleaning});

  @override
  State<StatefulWidget> createState() => _CleaningEditorState(this.cleaning);
}

class _CleaningEditorState extends State<CleaningEditor> {
  PushNotification notification;

  final _nameTextController = TextEditingController();
  final _guidelinesTextController = TextEditingController();

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final Cleaning cleaning;

  DateTime _nextDate;
  TimeOfDay _estimatedTime;
  Frequency _frequency;
  List<Product> _products;
  List<Task> _tasks;

  _CleaningEditorState(this.cleaning);

  void initState() {
    super.initState();

    notification = PushNotification(context);

    _nameTextController.text = cleaning.name;
    _guidelinesTextController.text = cleaning.guidelines;

    _nextDate = cleaning.nextDate;
    _estimatedTime = cleaning.estimatedTime;
    _products = cleaning.products;
    _tasks = cleaning.tasks;
    _frequency = cleaning.frequency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
        title: Text(cleaning.id != null ? "Editar Faxina" : "Nova Faxina",
            style: TextStyle(color: AppColors.SECONDARY, fontSize: 22)),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              save(cleaning);
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
                      labelText: "Nome",
                      labelStyle: TextStyle(color: AppColors.SECONDARY),
                      counterStyle: TextStyle(color: AppColors.SECONDARY),
                      errorBorder: InputBorder.none),
                  maxLength: 80,
                  autofocus: true,
                  controller: _nameTextController,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    return value.isEmpty ? "Requerido *" : null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Instruções",
                      labelStyle: TextStyle(color: AppColors.SECONDARY),
                      counterStyle: TextStyle(color: AppColors.SECONDARY),
                      errorBorder: InputBorder.none),
                  minLines: 2,
                  maxLines: 8,
                  controller: _guidelinesTextController,
                  maxLength: 4000,
                  style: TextStyle(color: Colors.white),
                  onSaved: (value) {
                    cleaning.guidelines = value;
                  },
                ),
                DatePicker(
                  initialValue: _nextDate,
                  title: "Agendamento",
                  onChanged: (value) {
                    _nextDate = value;
                  },
                ),
                DatePicker(
                  initialValue: DateTime(1, 1, 1, 1, 0),
                  title: "Tempo estimado",
                  showDate: false,
                  onChanged: (value) {
                    _estimatedTime = TimeOfDay.fromDateTime(value);
                  },
                ),
                SelectionPicker<Frequency>(
                  onChanged: (f) {
                    _frequency = f != null ? f.first : null;
                  },
                  elements: Frequency.values(),
                  selecteds: _frequency != null ? ([]..add(_frequency)) : null,
                  singleSelected: true,
                  renderer: FrequencySelector(),
                  title: "Frequência",
                ),
                FutureBuilder<List<Product>>(
                    future: ProductRepository.get().findAll(),
                    builder: (x, y) => SelectionPicker<Product>(
                          onChanged: (value) {
                            _products = value;
                          },
                          title: "Produtos",
                          selecteds: _products,
                          renderer: ProductSelector(),
                          elements: y.data,
                        )),
                FutureBuilder<List<Task>>(
                    future: TaskRepository.get().findAll(),
                    builder: (x, y) => SelectionPicker<Task>(
                          onChanged: (value) {
                            _tasks = value;
                          },
                          title: "Tarefas",
                          selecteds: _tasks,
                          renderer: TaskSelector(),
                          elements: y.data,
                        )),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () async {
                        save(cleaning);
                      },
                      color: AppColors.SECONDARY,
                      textColor: Colors.white,
                      child: Text("Salvar", style: TextStyle(fontSize: 16)),
                    )),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(Cleaning cleaning) async {
    bool valid = _tasks.isNotEmpty &&
        _frequency != null &&
        _nextDate != null &&
        _estimatedTime != null &&
        _formState.currentState.validate();

    if (valid) {
      _formState.currentState.save();

      cleaning.name = _nameTextController.text;
      cleaning.guidelines = _guidelinesTextController.text;
      cleaning.estimatedTime = _estimatedTime;
      cleaning.nextDate = _nextDate;
      cleaning.tasks = _tasks;
      cleaning.frequency = _frequency;
      cleaning.products = _products;

      await CleaningRepository.get().save(cleaning);

      notification.schedule(cleaning);

      Navigator.of(context).pop(cleaning);
    } else {
      showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          title: Center(child: Text("Aviso")),
          backgroundColor: AppColors.SECONDARY.withOpacity(0.8),
          contentPadding: EdgeInsets.all(20),
          children: <Widget>[Center(child: Text("Preencha todos os campos"))],
        ),
      );
    }
  }
}

class FrequencySelector implements ItemRenderer<Frequency> {
  @override
  Widget renderer(Frequency p, bool sel) {
    return Container(
        alignment: Alignment(-0.8, 0),
        height: 50,
        color: !sel ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
        child: Text(p.label,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}

class ProductSelector implements ItemRenderer<Product> {
  @override
  Widget renderer(Product p, bool sel) {
    return Container(
        alignment: Alignment(-0.8, 0),
        height: 50,
        color: !sel ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
        child: Text(p.name,
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
        child: Text(p.name,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}
