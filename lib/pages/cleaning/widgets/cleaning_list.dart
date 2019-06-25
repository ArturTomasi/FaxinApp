import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_view.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleaningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);
    _bloc.refresh();

    return StreamBuilder<List<Cleaning>>(
      stream: _bloc.cleanings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(
                  child: Icon(Icons.clear_all,
                      size: 100, color: AppColors.SECONDARY)),
            );
          }
          return CleaningListWidget(snapshot.data);
        } else {
          return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class CleaningListWidget extends StatelessWidget {
  final List<Cleaning> _cleaning;

  CleaningListWidget(this._cleaning);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.PRIMARY_LIGHT,
        child: ListView.builder(
            itemCount: _cleaning.length,
            itemBuilder: (BuildContext context, int i) {
              return Dismissible(
                  key: ObjectKey(_cleaning[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      CleaningBloc _bloc =
                          BlocProvider.of<CleaningBloc>(context);
                      _bloc.delete(_cleaning[i]);
                      _bloc.refresh();

                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors.SECONDARY,
                          content: Text(
                            "Faxina excluida com sucesso!",
                            style: TextStyle(fontSize: 16),
                          )));
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: ListTile(
                        trailing: Icon(Icons.delete, color: Colors.white)),
                  ),
                  child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CleaningView(_cleaning[i])));
                      },
                      child: item(
                        _cleaning[i],
                      )));
            }));
  }

  Widget item(Cleaning cleaning) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.SECONDARY),
            width: 75,
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${cleaning.nextDate.day}',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColors.PRIMARY_DARK,
                  width: 30,
                ),
                Text(
                  DateFormat.MMM().format(cleaning.nextDate),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                cleaning.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                cleaning.guidelines != null ? cleaning.guidelines : 'n/d',
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _item(Cleaning cleaning) {
    return ListTile(
        leading: Icon(
          Icons.event_available,
          color: Colors.white,
        ),
        subtitle: Column(children: <Widget>[
          Row(children: <Widget>[
            new Text(
              cleaning.name.toLowerCase(),
              style: TextStyle(
                  color: AppColors.SECONDARY, fontStyle: FontStyle.italic),
            )
          ]),
          SizedBox(height: 15),
          Row(children: <Widget>[
            Icon(Icons.shopping_cart, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text('${cleaning.products.length}',
                style: TextStyle(color: Colors.white)),
            SizedBox(width: 50),
            Icon(Icons.fitness_center, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text('${cleaning.tasks.length}',
                style: TextStyle(color: Colors.white))
          ]),
          SizedBox(height: 15)
        ]),
        title: new Text(cleaning.name.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}
