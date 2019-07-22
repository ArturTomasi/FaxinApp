import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_widget.dart';
import 'package:faxinapp/pages/cleaning/widgets/import_page.dart';
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
        color: AppColors.PRIMARY_DARK,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logo.png",
                      width: 75,
                    ),
                    Text(
                      "Meu Lar",
                      style: TextStyle(
                        color: AppColors.PRIMARY_LIGHT,
                        fontFamily: 'BelovedTeacher',
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY,
              ),
            ),
            ListTile(
              leading: new Icon(
                Icons.import_export,
                color: AppColors.SECONDARY,
                size: 45,
              ),
              subtitle: Text(
                "Importar faxinas",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: Text(
                "Importar",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                CleaningBloc _bloc = BlocProvider.of(context);

                var _provider = BlocProvider(bloc: _bloc, child: ImportPage());

                await Navigator.push(
                  context,
                  AnimateRoute<bool>(builder: (context) => _provider),
                );

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.sync,
                color: AppColors.SECONDARY,
                size: 45,
              ),
              subtitle: Text(
                "Sincronizar faxinas compartilhadas",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: Text(
                "Sincronizar",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                SharedUtil.syncronized(context);
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              color: AppColors.PRIMARY,
              height: 2,
            ),
            ListTile(
              leading: new Icon(
                Icons.clear_all,
                color: AppColors.SECONDARY,
                size: 45,
              ),
              subtitle: Text(
                "Gerenciar faxinas",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: Text(
                "Faxinas",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                CleaningBloc _bloc = BlocProvider.of(context);

                var _provider =
                    BlocProvider(bloc: _bloc, child: CleaningWidget());

                await Navigator.push(
                  context,
                  AnimateRoute<bool>(builder: (context) => _provider),
                );
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.fitness_center,
                color: AppColors.SECONDARY,
                size: 45,
              ),
              subtitle: Text(
                "Gerenciar tarefas",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: Text(
                "Tarefas",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                var bloc = BlocProvider(
                  bloc: TaskBloc(),
                  child: TaskWidget(),
                );

                await Navigator.push(
                  context,
                  AnimateRoute<bool>(builder: (context) => bloc),
                );
              },
            ),
            ListTile(
              leading: new Icon(
                Icons.shopping_cart,
                color: AppColors.SECONDARY,
                size: 45,
              ),
              subtitle: Text(
                "Gerenciar produtos",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: Text(
                "Produtos",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async {
                var bloc = BlocProvider(
                  bloc: ProductBloc(),
                  child: ProductWidget(),
                );

                await Navigator.push(
                  context,
                  AnimateRoute<bool>(builder: (context) => bloc),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
