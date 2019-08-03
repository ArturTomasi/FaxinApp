import 'dart:async';

import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/splash.dart';
import 'package:faxinapp/common/util/security_manager.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/date_format.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  initDateFormat();

  bool splash =
      //(await SharedPreferences.getInstance()).getBool('splash') ?? true;
      ! await SecurityManager.isPremium();

  runApp(MyApp(splash));
}

class MyApp extends StatefulWidget {
  final bool splash;
  MyApp(this.splash);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CleaningBloc _bloc = CleaningBloc();

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      _retrieveDynamicLink(deepLink.pathSegments.first);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        _retrieveDynamicLink(deepLink.pathSegments.first);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future _retrieveDynamicLink(uuid) async {
    if (uuid != null) {
      _bloc.setLoading("Conectando ao servidor");
      var c = await SharedUtil.obtain(uuid);

      if (c != null) {
        var _current = await CleaningRepository.get().find(c.id);

        if (_current != null && _current.type.index == CleaningType.SHARED.index) {
          _bloc.setLoading("Você não pode importar sua própria faxina!");
        } else {
          _bloc.setLoading("Importando faxina");
          await CleaningRepository.get().import(c);

          _bloc.setLoading("Agendando sua faxina");
          PushNotification(context)..schedule(c);

          _bloc.setLoading("Atualizando...;");
          _bloc.findPendents();
        }
      }

      _bloc.setLoading(null);
    }
  }

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
          ),
        ),
        primaryColor: AppColors.PRIMARY,
      ),
      home: widget.splash
          ? BlocProvider(
              bloc: _bloc,
              child: Splash(),
            )
          : BlocProvider(
              bloc: _bloc,
              child: HomePage(),
            ),
    );
  }
}
