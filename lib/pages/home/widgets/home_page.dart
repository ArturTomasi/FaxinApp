import 'package:faxinapp/pages/cleaning/widgets/cleaning_timeline.dart';
import 'package:faxinapp/pages/products/widgets/product_empty.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{  

  final List<Widget> pages = [];

  _HomePageState() {
    pages.add(CleaningTimeline());
    pages.add(ProductEmpty());
  }

  int pageIx = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(),
      drawer: HomeDrawer(),
      body: body(),
      bottomNavigationBar: navigator(),
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
      iconTheme: new IconThemeData(color: AppColors.SECONDARY),
    );
  }

  Widget body() {
    return Container(
      color: AppColors.PRIMARY_LIGHT,
        child: PageView(
      onPageChanged: (i) => setState(() => pageIx = i),
      controller: pageController,
      children: pages,
      physics: BouncingScrollPhysics(),
    ),);
  }

  Widget navigator() {
    return BottomNavigationBar(
        backgroundColor: AppColors.PRIMARY,
        fixedColor: AppColors.SECONDARY,
        unselectedItemColor: Colors.white,
        iconSize: 25,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.
      
      fixed,
        currentIndex: pageIx,
        onTap: (i) => pageController.animateToPage(i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.clear_all),
            title: Text("Faxinas"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Produtos"),
          ),
        ]);
  }
}
