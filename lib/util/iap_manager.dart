import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPManager {
  static String _id = 'faxinapp';

  void initConnection() async {
    await FlutterInappPurchase.initConnection;
  }

  void endConnection() async {
    await FlutterInappPurchase.endConnection;
  }

  Future<bool> isPremium() async {
    bool value =
        (await SharedPreferences.getInstance()).getBool('isPremium') ?? false;

    try {
      //Fez a compra e não consumiou o produto"
      List<PurchasedItem> purchased =
          await FlutterInappPurchase.getAvailablePurchases();
      print('getAvailablePurchases');
      print(purchased);

      if (purchased != null && purchased.isNotEmpty) {
        for (var p in purchased) {
          print(p);
          if (p.productId == _id) {
            value = true;
          }
        }
      }

      //historico de compras
      purchased = await FlutterInappPurchase.getPurchaseHistory();
      print('historico de compras');
      print(purchased);
      if (purchased != null && purchased.isNotEmpty) {
        for (var p in purchased) {
          print(p);
          if (p.productId == _id) {
            value = true;
          }
        }
      }
    } catch (e) {
      print(e);
    }

    await (await SharedPreferences.getInstance()).setBool('isPremium', value);

    return value;
  }

  Future<Null> buy(BuildContext context) async {
    try {
      var product = await FlutterInappPurchase.buyProduct(_id);

      if (product != null) {
        show(context, "Adquirido versão premium!");

        await (await SharedPreferences.getInstance())
            .setBool('isPremium', true);
      }
    } catch (e) {
      show(context, e.toString());
    }
  }

  void show(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.SECONDARY,
        content: Text(
          msg,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
