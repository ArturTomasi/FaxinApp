import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/common/ui/fancy_tab_bar.dart';
import 'package:faxinapp/pages/charts/dashboard.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_editor.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_timeline.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/widgets/product_editor.dart';
import 'package:faxinapp/pages/products/widgets/product_empty.dart';
import 'package:faxinapp/pages/tasks/bloc/task_bloc.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/pages/tasks/widgets/task_editor.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<FancyTabBarState> _keyNavigator =
      GlobalKey<FancyTabBarState>();
  final List<Widget> pages = [];
  int pageIx = 1;
  final PageController pageController = PageController(
    initialPage: 1,
  );
  bool _propagateAnimations = true;

  _HomePageState() {
    pages.add(Dashboard());
    pages.add(CleaningTimeline());
    pages.add(ProductEmpty());
  }

  void onChanged(int idx) {
    _propagateAnimations = false;
    pageController.animateToPage(
      idx,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    FancyTabBar navigator = FancyTabBar(
      key: _keyNavigator,
      onChanged: onChanged,
    );

    CleaningBloc bloc = BlocProvider.of<CleaningBloc>(context);

    return Scaffold(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      appBar: bar(),
      drawer: HomeDrawer(),
      body: StreamBuilder<bool>(
        initialData: false,
        stream: bloc.loading,
        builder: (context, snap) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 50),
                child: PageView(
                  onPageChanged: (i) {
                    setState(() => pageIx = i);
                    if (_propagateAnimations == true) {
                      _keyNavigator.currentState.move(i);
                    }
                    _propagateAnimations = true;
                  },
                  controller: pageController,
                  children: pages,
                  physics: BouncingScrollPhysics(),
                ),
              ),
              navigator,
              snap.hasData && !snap.data
                  ? Container()
                  : Container(
                      color: AppColors.PRIMARY_LIGHT.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }

  AppBar bar() {
    return AppBar(
      title: Text(
        'FaxinApp',
        style: TextStyle(
            color: AppColors.SECONDARY, letterSpacing: 3.5, fontSize: 30),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: AppColors.SECONDARY,
      ),
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (int result) async {
            switch (result) {
              case 0:
                CleaningBloc _bloc = BlocProvider.of(context);

                var _provider = BlocProvider(
                    bloc: _bloc,
                    child: CleaningEditor(
                      cleaning: Cleaning(),
                    ));

                Cleaning c = await Navigator.push(
                  context,
                  AnimateRoute(builder: (context) => _provider),
                );

                if (c != null) {
                  _bloc.findPendents();
                }
                break;

              case 1:
                var bloc = BlocProvider(
                  bloc: TaskBloc(),
                  child: TaskEditor(task: Task()),
                );

                Navigator.push(
                  context,
                  AnimateRoute(builder: (context) => bloc),
                );
                break;

              case 2:
                var bloc = BlocProvider(
                  bloc: ProductBloc(),
                  child: ProductEditor(
                    product: Product(),
                  ),
                );

                Navigator.push(
                  context,
                  AnimateRoute(builder: (context) => bloc),
                );
                break;

              case 3:
                await SharedUtil.syncronized(context);
                break;
            }
          },
          icon: Icon(Icons.add),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.clear_all,
                      color: AppColors.PRIMARY_DARK,
                    ),
                    title: Text(
                      'Faxinas',
                      style: TextStyle(
                        color: AppColors.PRIMARY_DARK,
                      ),
                    ),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.fitness_center,
                      color: AppColors.PRIMARY_DARK,
                    ),
                    title: Text(
                      'Tarefas',
                      style: TextStyle(
                        color: AppColors.PRIMARY_DARK,
                      ),
                    ),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.shopping_cart,
                      color: AppColors.PRIMARY_DARK,
                    ),
                    title: Text(
                      'Produtos',
                      style: TextStyle(
                        color: AppColors.PRIMARY_DARK,
                      ),
                    ),
                  ),
                ),
                /*
                const PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.sync,
                      color: AppColors.PRIMARY_DARK,
                    ),
                    title: Text(
                      'Sincronizar',
                      style: TextStyle(
                        color: AppColors.PRIMARY_DARK,
                      ),
                    ),
                  ),
                ),
                */
              ],
        ),
      ],
    );
  }
}
