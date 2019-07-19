import 'package:connectivity/connectivity.dart';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_actions.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_editor.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleaningView extends StatefulWidget {
  final Cleaning cleaning;

  CleaningView({@required this.cleaning});

  @override
  _CleaningViewState createState() => _CleaningViewState();
}

enum Mode { EDIT, VIEW, DONE }

class _CleaningViewState extends State<CleaningView> {
  final GlobalKey<ScaffoldState> key = new GlobalKey();
  List<CleaningProduct> products = [];
  List<CleaningTask> tasks = [];

  Mode mode = Mode.VIEW;
  PushNotification notification;

  @override
  void initState() {
    super.initState();

    notification = PushNotification(context);
    mode = widget.cleaning.dueDate != null ? Mode.DONE : mode;

    CleaningRepository.get().findTask(widget.cleaning).then((tsk) {
      widget.cleaning.tasks.forEach(
        (t) => tasks.add(
          CleaningTask(
            cleaning: widget.cleaning,
            realized: tsk[t.id],
            task: t,
          ),
        ),
      );
      setState(() {});
    });

    CleaningRepository.get().findProducts(widget.cleaning).then((prds) {
      widget.cleaning.products.forEach(
        (p) => products.add(
          CleaningProduct(
            cleaning: widget.cleaning,
            realized: prds[p.id][0],
            amount: prds[p.id][1] != null && prds[p.id][1] != 0
                ? (prds[p.id][1]).toInt()
                : p.currentCapacity.toInt(),
            product: p,
          ),
        ),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CleaningBloc bloc = BlocProvider.of<CleaningBloc>(context);

    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
        title: Text(
          "Faxina",
          style: TextStyle(
            color: AppColors.SECONDARY,
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: mode == Mode.VIEW
          ? CleaningActions(
              widget.cleaning,
              onEdit: () async {
                var provider = BlocProvider(
                  bloc: bloc,
                  child: CleaningEditor(
                    cleaning: widget.cleaning,
                  ),
                );

                await Navigator.of(context).push(new AnimateRoute(
                    fullscreenDialog: true, builder: (c) => provider));

                Navigator.pop(context);
              },
              onDone: () => setState(() => mode = Mode.DONE),
            )
          : Container(),
      body: StreamBuilder<bool>(
        initialData: false,
        stream: bloc.loading,
        builder: (context, snap) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                color: AppColors.PRIMARY_LIGHT,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: draw(),
                ),
              ),
              snap.hasData && !snap.data
                  ? Container()
                  : Container(
                      color: AppColors.PRIMARY_LIGHT.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> draw() {
    return []
      ..addAll(drawHead())
      ..addAll(drawInfo())
      ..addAll(drawBody())
      ..addAll(drawButton());
  }

  void _save() async {
    if (widget.cleaning.dueDate == null) {
      widget.cleaning.dueDate = DateTime.now();
      products.forEach((p) {
        p.amount = (p.product.currentCapacity - p.amount).toInt();
        if (p.amount > 0) {
          p.realized = 1;
        }
      });

      Cleaning next;

      if (widget.cleaning.type == CleaningType.IMPORTED) {
        if (await Connectivity().checkConnectivity() ==
            ConnectivityResult.none) {
          show("Verifica sua conexão");
        } else {
          await SharedUtil.done(widget.cleaning, tasks, products);

          next = await CleaningRepository.get()
              .done(widget.cleaning, tasks, products);

          await notification.cancel(widget.cleaning);

          Navigator.of(context).pop(next);
        }
      } else {
        next = await CleaningRepository.get()
            .done(widget.cleaning, tasks, products);

        await notification.cancel(widget.cleaning);

        Navigator.of(context).pop(next);
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  List<Widget> drawButton() {
    return [
      mode == Mode.DONE
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: _save,
                color: AppColors.SECONDARY,
                textColor: Colors.white,
                child: Text(
                    widget.cleaning.dueDate == null ? "Concluir" : "Fechar",
                    style: TextStyle(fontSize: 16)),
              ),
            )
          : Container(),
    ];
  }

  List<Widget> drawInfo() {
    List<Widget> infos = [];

    infos.add(drawRowInfo('Tempo Estimado:',
        '${MaterialLocalizations.of(context).formatTimeOfDay(widget.cleaning.estimatedTime, alwaysUse24HourFormat: true)}'));
    infos.add(drawRowInfo('Agendado:',
        DateFormat('dd/MM/yyyy HH:MM').format(widget.cleaning.nextDate)));

    Frequency frequency = widget.cleaning.frequency;

    infos.add(drawRowInfo(
        'Frequência:', frequency != null ? frequency.label : "n/d"));

    if (widget.cleaning.dueDate == null) {
      infos.add(drawRowInfo('Próxima faxina:',
          DateFormat('dd/MM/yyyy HH:MM').format(widget.cleaning.futureDate())));
    } else {
      infos.add(drawRowInfo('Realizada em: ',
          DateFormat('dd/MM/yyyy HH:MM').format(widget.cleaning.dueDate)));
    }

    return infos;
  }

  Widget drawRowInfo(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.SECONDARY,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  List<Widget> drawHead() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          widget.cleaning.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          child: Text(
            widget.cleaning.guidelines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            maxLines: 8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ))
    ];
  }

  List<Widget> drawBody() {
    return []
      ..add(drawCategory('T A R E F A S'))
      ..addAll(tasks.map<Widget>((t) => drawTaskItem(t)).toList())
      ..add(products.isNotEmpty ? drawCategory('P R O D U T O S') : Container())
      ..addAll(products.map<Widget>((p) => drawProductItem(p)).toList());
  }

  Widget drawCategory(String value) {
    return SizedBox(
      height: 75,
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.SECONDARY,
            fontStyle: FontStyle.normal,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget drawTaskItem(CleaningTask item) {
    return SizedBox(
      child: mode == Mode.DONE
          ? SwitchListTile(
              secondary: new Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
              subtitle: new Text(
                item.task.guidelines,
                style: TextStyle(
                    color: AppColors.SECONDARY, fontStyle: FontStyle.italic),
              ),
              title: new Text(
                item.task.name,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              value: item.realized == 1,
              onChanged: widget.cleaning.dueDate == null
                  ? (bool value) {
                      setState(() => item.realized = value ? 1 : 0);
                    }
                  : null,
            )
          : ListTile(
              leading: new Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
              subtitle: new Text(
                item.task.guidelines,
                style: TextStyle(
                    color: AppColors.SECONDARY, fontStyle: FontStyle.italic),
              ),
              title: new Text(
                item.task.name,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
      width: 150,
    );
  }

  Widget drawProductItem(CleaningProduct item) {
    return ListTile(
      leading: new Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      subtitle: mode == Mode.DONE
          ? Slider(
              divisions: item.product.capacity.toInt(),
              onChanged: widget.cleaning.dueDate == null
                  ? (value) {
                      setState(() {
                        item.amount = value.toInt();
                      });
                    }
                  : null,
              min: 0,
              activeColor: AppColors.SECONDARY,
              max: item.product.capacity,
              label:
                  '${((item.amount / item.product.capacity) * 100).toInt()}%',
              value: item.amount.toDouble(),
            )
          : Container(),
      title: new Text(
        item.product.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  void show(String msg) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(
          msg,
        ),
      ),
    );
  }
}
