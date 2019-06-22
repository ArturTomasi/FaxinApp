import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/home/bloc/home_bloc.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting("pt_BR");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.transparent,
            highlightColor: AppColors.SECONDARY,
            accentColor: AppColors.SECONDARY,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: AppColors.SECONDARY),
            primaryColor: AppColors.PRIMARY),
        home: BlocProvider(
          bloc: HomeBloc(),
          child: HomePage(),
        ));
  }
}
