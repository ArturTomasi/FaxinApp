import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LicensingExipred extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_DARK,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        color: AppColors.PRIMARY_DARK,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.closeCircle,
                size: 100,
                color: AppColors.SECONDARY,
              ),
              Text(
                "Sua versão gratuita expirou!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.SECONDARY,
                  fontSize: 22,
                ),
              ),
              Text(
                '\nPara continuar usando o aplicativo se torne Premium!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.SECONDARY,
                  fontSize: 18,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
