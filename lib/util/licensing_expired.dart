import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/iap_manager.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LicensingExipred extends StatefulWidget {
  final String text;
  LicensingExipred(
      {this.text:
          "\nPara cadastrar mais itens você\nprecisa assinar a versão\n Premium!\n\nAproveite o valor promocional\nque é por tempo limitado.\n"});
  @override
  _LicensingExipredState createState() => _LicensingExipredState();
}

class _LicensingExipredState extends State<LicensingExipred> {
  final IAPManager iap = new IAPManager();

  @override
  void initState() {
    super.initState();
    iap.initConnection();
  }

  @override
  void dispose() {
    super.dispose();
    iap.endConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 100,
        ),
        decoration: BoxDecoration(
          color: AppColors.SECONDARY,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.alert,
                size: 100,
                color: AppColors.PRIMARY_LIGHT,
              ),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.PRIMARY_LIGHT,
                  fontSize: 20,
                ),
              ),
              RaisedButton(
                color: Colors.grey.shade400,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                onPressed: _buy,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Seja Premium ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/icone_premium.png',
                      height: 30,
                      width: 30,
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buy() async {
    await iap.buy( context );

    Navigator.of(context).pop();
  }
}
