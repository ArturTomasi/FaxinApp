import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/common/ui/fancy_tab_bar.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
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
  final PageController pageController = PageController(initialPage: 0);
  int pageIx = 0;

  _HomePageState() {
    pages.add(CleaningTimeline());
    pages.add(ProductEmpty());
  }

  void onChanged(int idx) {
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

    return Scaffold(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      appBar: bar(),
      drawer: HomeDrawer(),
      body: Container(
        padding: EdgeInsets.all(0),
        color: AppColors.PRIMARY_LIGHT,
        child: PageView(
          onPageChanged: (i) {
            setState(() => pageIx = i);
            _keyNavigator.currentState.move(i);
          },
          controller: pageController,
          children: pages,
          physics: BouncingScrollPhysics(),
        ),
      ),
      bottomNavigationBar: navigator,
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
          onSelected: (int result) {
            switch (result) {
              case 0:
                CleaningBloc _bloc = BlocProvider.of(context);

                var _provider = BlocProvider(
                    bloc: _bloc,
                    child: CleaningEditor(
                      cleaning: Cleaning(),
                    ));

                Navigator.push(
                  context,
                  AnimateRoute(builder: (context) => _provider),
                );
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
              ],
        ),
      ],
    );
  }
}
