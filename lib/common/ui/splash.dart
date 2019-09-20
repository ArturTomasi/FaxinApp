import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_coverflow/simple_coverflow.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController animation;

  @override
  void initState() {
    super.initState();

    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    Tween(begin: 0, end: 0.5).animate(animation);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _pages = [
      welcome(),
      buymeacoffe(),
      complete(),
      end(),
    ];

    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);
    var _currentIndex = 0;

    return Scaffold(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CoverFlow(
            dismissibleItems: false,
            itemCount: _pages.length,
            currentItemChangedCallback: (i) {
              _currentIndex = i;
              if (i == _pages.length - 1)
                animation.forward();
              else
                animation.reverse();
            },
            itemBuilder: (_, i) => _pages[i],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: SizedBox(
              width: 120,
              child: FadeTransition(
                opacity: animation,
                child: RaisedButton(
                  color: AppColors.SECONDARY,
                  elevation: 5,
                  child: Text(
                    "Prosseguir",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'bold',
                    ),
                  ),
                  onPressed: () {
                    if (_currentIndex == _pages.length - 1) {
                      SharedPreferences.getInstance()
                          .then((s) => s.setBool('splash', false));

                      Navigator.of(context).pushReplacement(
                        AnimateRoute(
                          builder: (_) => BlocProvider(
                            bloc: _bloc,
                            child: HomePage(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget welcome() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
            Colors.white.withOpacity(0.9),
            BlendMode.dstOut,
          ),
          fit: BoxFit.none,
          image: ExactAssetImage("assets/images/logo.png", scale: 2),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.white,
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 50,
            ),
            child: Text(
              "Bem-vindo ao aplicativo",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 30,
                fontFamily: 'BelovedTeacher',
              ),
            ),
          ),
          Text(
            "Meu Lar",
            style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 40,
                fontFamily: 'BelovedTeacher'),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            color: AppColors.PRIMARY_LIGHT,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              "O objetivo do aplicativo é ajudar você na organização do seu Lar!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 85,
            margin: EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/images/icone_4.png',
                  height: 35,
                ),
                Image.asset(
                  'assets/images/icone_3.png',
                  height: 35,
                ),
                Image.asset(
                  'assets/images/icone_2.png',
                  height: 35,
                ),
                Image.asset(
                  'assets/images/icone_1.png',
                  height: 35,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              "Esta é uma versão gratuita e livre de anúncios que permite:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_DARK,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '10 eventos de organização\n(agendamento manual);\n'
              '10 novos produtos;\n'
              '10 novas tarefas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.2,
                color: AppColors.SECONDARY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget end() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.white,
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 50,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 6,
            ),
          ),
          Text(
            "Meu Lar",
            style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 40,
                fontFamily: 'BelovedTeacher'),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            color: AppColors.PRIMARY_LIGHT,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              "Obrigado por instalar nosso aplicativo!\n\n"
              "Sugestões são sempre bem-vindas e podemos conversar através de nossas redes sociais:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 18,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      MdiIcons.instagram,
                      color: AppColors.PRIMARY_LIGHT,
                    ),
                    Text(
                      '   @appmeular',
                      style: TextStyle(
                        color: AppColors.PRIMARY_LIGHT,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    MdiIcons.facebookBox,
                    color: AppColors.PRIMARY_LIGHT,
                  ),
                  Text(
                    '   /aplicativomeular',
                    style: TextStyle(
                      color: AppColors.PRIMARY_LIGHT,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget complete() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.white,
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 50,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 6,
            ),
          ),
          Text(
            "Meu Lar",
            style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 40,
                fontFamily: 'BelovedTeacher'),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            color: AppColors.PRIMARY_LIGHT,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
            child: Text(
              "Versão Completa:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_DARK,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              'Cadastro ilimitado de eventos,\n tarefas e produtos;\n\n'
              'Compartilhamento de eventos\n com outras pessoas;\n\n'
              'Agendamento automático dos\n eventos conforme a periodicidade\n de cada um.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1,
                color: AppColors.SECONDARY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buymeacoffe() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.white,
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 50,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              scale: 6,
            ),
          ),
          Text(
            "Meu Lar",
            style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 40,
                fontFamily: 'BelovedTeacher'),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            color: AppColors.PRIMARY_LIGHT,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
              right: 40,
              top: 10,
            ),
            child: Text(
              "E aí, gostou do aplicativo?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.PRIMARY_LIGHT,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Text(
              "Instale a versão completa por apenas R\$ 1,49 e nos ajude a continuar ajudando na organização de outros lares!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
                fontSize: 18,
              ),
            ),
          ),
          Image.asset(
            'assets/images/google-play-badge.png',
            scale: 4,
          )
        ],
      ),
    );
  }
}
