import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/home/widgets/home_page.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_coverflow/simple_coverflow.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final _pages = [
      card(
        "Quisque pretium, purus nec sollicitudin euismod, lorem ",
        "Donec eget sollicitudin turpis, eget vestibulum urna. Etiam congue vestibulum quam sit amet ornare. Ut gravida, lorem sit amet sagittis dapibus, metus orci congue tortor",
        "assets/images/banner.jpg",
      ),
      card(
        "Phasellus hendrerit nisl sit amet mauris suscipit, in convallis massa tempor.",
        "Donec aliquam viverra urna vel porttitor. Praesent ac sodales orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi in posuere leo, vitae ullamcorper orci. Suspendisse potenti. Duis ut consectetur leo.",
        "assets/images/banner1.jpg",
      ),
      card(
        "Vivamus lobortis libero odio, quis efficitur magna bibendum nec",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut cursus diam. Cras pulvinar volutpat nulla, vitae congue lorem consequat vel. Pellentesque fermentum sem et velit sagittis, a gravida dolor imperdiet. ",
        "assets/images/banner2.jpg",
      ),
      card(
        "Quisque condimentum eros sed arcu ullamcorper facilisis sit amet ac tortor",
        "Fusce vel mauris consectetur erat bibendum lobortis in vitae sem. Morbi non ex feugiat, vehicula felis id, dignissim ante.",
        "assets/images/banner1.jpg",
      ),
      card(
        "Nam viverra arcu ac libero auctor ultricies. Sed iaculis eu erat semper cursus.",
        "Nam eu est a lorem consectetur ultricies id sit amet dolor. Suspendisse vehicula vitae sapien at sagittis. Etiam eget mattis dui, imperdiet posuere orci. Maecenas a tristique libero, suscipit ultrices risus. Sed dictum scelerisque erat vel pharetra. Pellentesque sed mauris tellus. Duis luctus justo at aliquam egestas. Vivamus lobortis libero odio, quis efficitur magna bibendum nec. Donec ac leo dapibus quam mattis luctus et ac quam.",
        "assets/images/banner.jpg",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CoverFlow(
            dismissibleItems: false,
            itemCount: _pages.length,
            itemBuilder: (_, i) => _pages[i],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
            child: SizedBox(
              width: 100,
              child: RaisedButton(
                color: AppColors.PRIMARY,
                elevation: 5,
                child: Text(
                  "Prosseguir",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'bold',
                  ),
                ),
                onPressed: _procceed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget card(String title, String subtitle, String banner) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          colorFilter: new ColorFilter.mode(
            Colors.white.withOpacity(0.5),
            BlendMode.dstATop,
          ),
          image: AssetImage(banner),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Text(
              title,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'BreeSerif',
                color: AppColors.PRIMARY,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 22,
                
                fontFamily: 'BreeSerif',
                color: AppColors.PRIMARY,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _procceed() {
    SharedPreferences.getInstance().then((s) {
      s.setBool('splash', false);
    });

    Navigator.of(context).pushReplacement(
      AnimateRoute(
        builder: (_) => BlocProvider(
          bloc: CleaningBloc(),
          child: HomePage(),
        ),
      ),
    );
  }
}
