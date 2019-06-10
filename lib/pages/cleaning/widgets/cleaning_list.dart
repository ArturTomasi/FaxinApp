import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

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
                  child: ListTile(
                      leading: new Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                      ),
                      subtitle: Column(
                        children: <Widget>[
                        Row(children: <Widget>[
                          new Text(
                            _cleaning[i].info.toLowerCase(),
                            style: TextStyle(
                                color: AppColors.SECONDARY,
                                fontStyle: FontStyle.italic),
                          )
                        ]),
                        SizedBox(height : 15),
                        Row(
                          children: <Widget>[
                          Icon(Icons.shopping_cart, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text('${_cleaning[i].products.length}', style: TextStyle( color: Colors.white)),
                          SizedBox(width: 50),
                          Icon(Icons.fitness_center, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text('${_cleaning[i].tasks.length}', style: TextStyle( color: Colors.white))
                        ]),
                        SizedBox(height : 15)
                      ]),
                      title: new Text(_cleaning[i].title.toUpperCase(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 20))));
            }));
  }
}
