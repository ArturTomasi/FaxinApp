import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_widget.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/widgets/product_widget.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/widgets/task_widget.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: AppColors.PRIMARY_LIGHT,
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              new DrawerHeader(
                  child: Center(
                      child: Text("FaxinApp",
                          style: TextStyle(
                              color: AppColors.PRIMARY_DARK,
                              letterSpacing: 3.5,
                              fontSize: 30))),
                  decoration: BoxDecoration(
                      color: AppColors.SECONDARY,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)))),
              ListTile(
                leading: new Icon(
                  Icons.clear_all,
                  color: Colors.white,
                ),
                subtitle: Text(
                  "Gerenciar faxinas",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                title: Text(
                  "Faxinas",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () async {

                  CleaningBloc _bloc = BlocProvider.of(context);

                  var _provider = BlocProvider(
                      bloc: _bloc, child: CleaningWidget());

                  await Navigator.push(
                    context,
                    MaterialPageRoute<bool>(builder: (context) => _provider),
                  );

                  //Navigator.pop(context);
                },
              ),
              Divider(color: AppColors.SECONDARY),
              ListTile(
                leading: new Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                ),
                subtitle: Text(
                  "Gerenciar tarefas",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                title: Text(
                  "Tarefas",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () async {
                  var bloc = BlocProvider(
                    bloc: TaskBloc(),
                    child: TaskWidget(),
                  );

                  await Navigator.push(
                    context,
                    MaterialPageRoute<bool>(builder: (context) => bloc),
                  );

                  //Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                subtitle: Text(
                  "Gerenciar produtos",
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                title: Text(
                  "Produtos",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () async {
                  var bloc = BlocProvider(
                    bloc: ProductBloc(),
                    child: ProductWidget(),
                  );

                  await Navigator.push(
                    context,
                    MaterialPageRoute<bool>(builder: (context) => bloc),
                  );

                  //Navigator.pop(context);
                },
              )
            ])));
  }
}
