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
    List<PurchasedItem> purchased =
        await FlutterInappPurchase.getAvailablePurchases();

    if (purchased != null && purchased.isNotEmpty) {
      for (var p in purchased) {
        if (p.productId == _id) return true;
      }
    }

    return false;
  }

  Future<Null> buy() async {
    try {
      var product = await FlutterInappPurchase.buyProduct(_id);

      if (product != null) {
        print(product.purchaseToken);
        (await SharedPreferences.getInstance()).setBool('isPremium', true);
      }
    } catch (e) {
      print(e);
    }
  }
}
