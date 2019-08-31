import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/common/util/security_manager.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_widget.dart';
import 'package:faxinapp/pages/cleaning/widgets/import_page.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/widgets/product_widget.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/widgets/task_widget.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/IAPViewUtil.dart';
import 'package:faxinapp/util/iap_manager.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> _state;
  HomeDrawer(this._state);

  @override
  _HomeDrawerState createState() => _HomeDrawerState(_state);
}

class _HomeDrawerState extends State<HomeDrawer> {
  final GlobalKey<ScaffoldState> _state;
  final IAPManager iap = new IAPManager();

  _HomeDrawerState(this._state);

  @override
  void initState() {
    super.initState();
    iap.initConnection();
  }

  @override
  void dispose() {
    super.dispose();
    iap.endConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.PRIMARY_DARK,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(bottom: 75),
              children: <Widget>[
                new DrawerHeader(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onDoubleTap: () async {
                            await Navigator.push(
                              context,
                              AnimateRoute<bool>(
                                builder: (context) => IAPViewUtil(),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: 75,
                          ),
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
                    size: 30,
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

                    var _provider =
                        BlocProvider(bloc: _bloc, child: ImportPage());

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
                    size: 30,
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
                    await SharedUtil.syncronized(globalKey: _state);
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
                    size: 30,
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
                    size: 30,
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
                    size: 30,
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
                ),
              ],
            ),
            FutureBuilder<bool>(
              future: SecurityManager.isPremium(),
              builder: (i, snap) {
                if (snap.hasData) {
                  return !snap.data
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              color: AppColors.PRIMARY,
                              height: 2,
                            ),
                            Container(
                              color: AppColors.PRIMARY_DARK,
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/icone_premium.png',
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.bottomCenter,
                                ),
                                subtitle: Text(
                                  "Adiquira a versão completa",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                title: Text(
                                  "Seja Premium",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onTap: _buy,
                              ),
                            ),
                          ],
                        )
                      : Container();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        color: AppColors.PRIMARY,
                        height: 2,
                      ),
                      Container(
                        color: AppColors.PRIMARY_DARK,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _buy() {
    iap.buy(context);
  }
}
