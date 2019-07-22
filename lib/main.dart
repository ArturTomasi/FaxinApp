import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/splash.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  initDateFormat();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool splash = prefs.getBool('splash') ?? true;

  runApp(
    MyApp(splash),
  );
}

class MyApp extends StatefulWidget {
  final bool splash;
  MyApp(this.splash);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Meu Lar",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', "BR"),
      ],
      locale: const Locale('pt', "BR"),
      theme: ThemeData(
        canvasColor: Colors.transparent,
        bottomAppBarColor: Colors.transparent,
        highlightColor: AppColors.SECONDARY,
        accentColor: AppColors.SECONDARY,
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.PRIMARY_LIGHT,
          textTheme: ButtonTextTheme.accent,
        ),
        fontFamily: 'BreeSerif',
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
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: AppColors.PRIMARY_LIGHT,
            ),
            textTheme: TextTheme(
              title: TextStyle(
                fontSize: 28,
                color: AppColors.PRIMARY_LIGHT,
                fontFamily: 'BelovedTeacher',
              ),
            ),
            actionsIconTheme: IconThemeData(
              color: AppColors.PRIMARY_LIGHT,
            )),
        primaryColor: AppColors.PRIMARY,
      ),
      home: widget.splash
          ? Splash()
          : BlocProvider(
              bloc: CleaningBloc(),
              child: HomePage(),
            ),
    );
  }
}
