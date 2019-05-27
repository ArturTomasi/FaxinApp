import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/home/bloc/home_bloc.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            initialData: 'FaxinApp',
            stream: homeBloc.title,
            builder: (context, snapshot) {
              return Text(
                snapshot.data,
                style: TextStyle(
                    color: AppColors.SECONDARY,
                    letterSpacing: 3.5,
                    fontSize: 30),
              );
            }),
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          print('art');
        },
      ),
      drawer: HomeDrawer(),
      body: Container(
          color: AppColors.PRIMARY_LIGHT,
          child: Center(
            child: Image.asset("assets/images/logo.png", width: 100, height: 100 ),
          )),
    );
  }
}
