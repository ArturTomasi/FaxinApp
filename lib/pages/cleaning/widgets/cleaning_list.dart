import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_view.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/push_notification.dart';
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
    PushNotification notification = PushNotification(context);

    return Container(
        color: AppColors.PRIMARY_LIGHT,
        child: ListView.builder(
            itemCount: _cleaning.length,
            itemBuilder: (BuildContext context, int i) {
              return Dismissible(
                  key: ObjectKey(_cleaning[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      CleaningBloc _bloc =
                          BlocProvider.of<CleaningBloc>(context);
                      await notification.cancel(_cleaning[i]);
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
                        context,
                        _cleaning[i],
                      )));
            }));
  }

  Widget item(BuildContext context, Cleaning cleaning) {
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
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  cleaning.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  cleaning.guidelines != null ? cleaning.guidelines : 'n/d',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
