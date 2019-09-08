import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPManager {
  //static const _current = 'faxinapp';
  static const _current = 'meu_lar_premium';
  static Set<String> _SKU = Set<String>.identity()..add(_current);

  static Future<bool> isPremium() async {
    try {
      bool avaliable =
          (await InAppPurchaseConnection.instance.isAvailable()) ?? false;

      if (!avaliable) {
        throw new IAPException('Sem acesso a loja');
      }

      QueryPurchaseDetailsResponse response =
          await InAppPurchaseConnection.instance.queryPastPurchases();

      if (response.error != null) {
        throw new IAPException(
            "Ocorreu um erro ao buscar o produto", response.error);
      }

      bool result = false;
      
      for (PurchaseDetails details in response.pastPurchases) {
        if (details.productID == _current) {
          result = true;
        }
      }

      await (await SharedPreferences.getInstance())
          .setBool('isPremium', result);

      return result;
    } catch (e) {
      if (e is IAPException) {
        throw e;
      }
      throw new IAPException('Ocorreu um erro inesperado!', e);
    }
  }

  static Future<bool> buy(Function callback) async {
    try {
      bool avaliable =
          (await InAppPurchaseConnection.instance.isAvailable()) ?? false;

      if (!avaliable) {
        throw new IAPException('Sem acesso a loja');
      }

      if (await isPremium()) {
        throw IAPException("Você já é premium");
      }

      ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_SKU);

      if (response.error != null) {
        throw new IAPException(
            "Ocorreu um erro ao buscar o produto", response.error);
      }

      if (response.notFoundIDs.isNotEmpty) {
        throw new IAPException("Não possível encontrar o produto $_SKU");
      }

      if (response.productDetails.length != 1) {
        throw new IAPException(
            "Mais de um produto foi encotrado", response.productDetails);
      }

      ProductDetails details = response.productDetails.first;

      if (details == null) {
        throw new IAPException("Detalhes do produto está incompleto", details);
      }

      PurchaseParam param = PurchaseParam(productDetails: details);

      bool success = await InAppPurchaseConnection.instance
          .buyNonConsumable(purchaseParam: param);

      if (!success) {
        throw new IAPException('Falha ao adquirir versão premium!');
      }

      InAppPurchaseConnection.instance.purchaseUpdatedStream
          .listen((snap) async {
        for (PurchaseDetails item in snap) {
          if (item.error != null) {
            throw new IAPException(
                "Ocorreu um erro ao buscar o produto", response.error);
          }

          if (item.productID == _current) {
            await (await SharedPreferences.getInstance())
                .setBool('isPremium', item.status == PurchaseStatus.purchased);

            callback(item.status == PurchaseStatus.purchased);
          }
        }
      });

      return false;
    } catch (e) {
      if (e is IAPException) {
        throw e;
      }

      throw new IAPException('Ocorreu um erro inesperado!', e);
    }
  }
}

class IAPException implements Exception {
  String _message;
  IAPException([this._message, dynamic e]) {
    print(this._message);
    if (e != null) {
      print(e);
    }
  }

  @override
  String toString() {
    return _message;
  }
}
