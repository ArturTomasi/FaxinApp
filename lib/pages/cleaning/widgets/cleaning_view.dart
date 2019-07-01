import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleaningView extends StatefulWidget {
  final Cleaning cleaning;

  CleaningView(this.cleaning);

  @override
  _CleaningViewState createState() => _CleaningViewState();
}

class _CleaningViewState extends State<CleaningView> {
  List<CleaningProduct> products = [];
  List<CleaningTask> tasks = [];

  @override
  void initState() {
    super.initState();

    widget.cleaning.tasks.forEach(
      (t) => tasks.add(
            CleaningTask(
              cleaning: widget.cleaning,
              realized: 0,
              task: t,
            ),
          ),
    );

    widget.cleaning.products.forEach(
      (p) => products.add(
            CleaningProduct(
              cleaning: widget.cleaning,
              realized: 0,
              amount: p.currentCapacity.toInt(),
              product: p,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: new IconThemeData(color: AppColors.SECONDARY),
          title: Text(
            "Faxina",
            style: TextStyle(
              color: AppColors.SECONDARY,
              fontSize: 22,
            ),
          )),
      body: Container(
        color: AppColors.PRIMARY_LIGHT,
        child: ListView(
            physics: BouncingScrollPhysics(),
            children: []
              ..addAll(drawHead())
              ..addAll(drawInfo())
              ..addAll(drawBody())
              ..addAll(drawButton())),
      ),
    );
  }

  void _save() async {
    if (widget.cleaning.dueDate == null) {
      products.forEach((p) {
        p.amount = (p.product.currentCapacity - p.amount).toInt();
        if (p.amount > 0) {
          p.realized = 1;
        }
      });

      Cleaning next = await CleaningRepository.get()
          .finish(widget.cleaning, tasks, products);

      Navigator.of(context).pop(next);
    } else {
      Navigator.of(context).pop();
    }
  }

  List<Widget> drawButton() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: _save,
          color: AppColors.SECONDARY,
          textColor: Colors.white,
          child: Text(widget.cleaning.dueDate == null ? "Concluir" : "Fechar",
              style: TextStyle(fontSize: 16)),
        ),
      ),
    ];
  }

  List<Widget> drawInfo() {
    List<Widget> infos = [];

    infos.add(drawRowInfo('Tempo Estimado:',
        '${widget.cleaning.estimatedTime.hour}:${widget.cleaning.estimatedTime.minute}'));
    infos.add(drawRowInfo('Agendado:',
        DateFormat('dd/MM/yyyy hh:mm').format(widget.cleaning.nextDate)));

    Frequency frequency = widget.cleaning.frequency;

    infos.add(drawRowInfo('Frequência:', frequency.label));

    if (widget.cleaning.dueDate == null) {
      infos.add(drawRowInfo('Próxima faxina:',
          DateFormat('dd/MM/yyyy hh:mm').format(widget.cleaning.futureDate())));
    } else {
      infos.add(drawRowInfo('Realizada em: ',
          DateFormat('dd/MM/yyyy hh:mm').format(widget.cleaning.dueDate)));
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
      child: widget.cleaning.dueDate == null
          ? SwitchListTile(
              secondary: new Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
              subtitle: new Text(
                item.task.guidelines.toLowerCase(),
                style: TextStyle(
                    color: AppColors.SECONDARY, fontStyle: FontStyle.italic),
              ),
              title: new Text(
                item.task.name.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              value: item.realized == 1,
              onChanged: (bool value) {
                item.realized = value ? 1 : 0;
              },
            )
          : ListTile(
              leading: new Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
              subtitle: new Text(
                item.task.guidelines.toLowerCase(),
                style: TextStyle(
                    color: AppColors.SECONDARY, fontStyle: FontStyle.italic),
              ),
              title: new Text(
                item.task.name.toUpperCase(),
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
      subtitle: widget.cleaning.dueDate == null
          ? Slider(
              onChanged: (value) {
                setState(() {
                  item.amount = value.toInt();
                });
              },
              min: 0,
              activeColor: AppColors.SECONDARY,
              max: item.product.capacity,
              label: '${item.amount.toDouble()}',
              value: item.amount.toDouble(),
            )
          : Container(),
      title: new Text(
        item.product.name.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
