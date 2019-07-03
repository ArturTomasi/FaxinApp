import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting("pt_BR");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CleaningBloc _cleaningBloc = new CleaningBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Faxinap",
        theme: ThemeData(
            canvasColor: Colors.transparent,
            bottomAppBarColor: Colors.transparent,
            highlightColor: AppColors.SECONDARY,
            accentColor: AppColors.SECONDARY,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColors.SECONDARY,
            ),
            sliderTheme: SliderTheme.of(context).copyWith(
              disabledActiveTickMarkColor: AppColors.PRIMARY_DARK,
              disabledInactiveTickMarkColor: AppColors.PRIMARY,
              disabledActiveTrackColor: AppColors.PRIMARY_DARK,
              disabledInactiveTrackColor: AppColors.PRIMARY,
              disabledThumbColor: AppColors.PRIMARY_DARK,
            ),
            primaryColor: AppColors.PRIMARY),
        home: BlocProvider(
          bloc: _cleaningBloc,
          child: HomePage(),
        ));
  }
}
