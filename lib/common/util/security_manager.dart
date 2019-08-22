import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:faxinapp/util/iap_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityManager {
  static Future<bool> canAddCleaning() async {
    if (await isPremium()) {
      return true;
    }
    return (await CleaningRepository.get().count()) <= 10;
  }

  static Future<bool> canAddProduct() async {
    if (await isPremium()) {
      return true;
    }
    return (await ProductRepository.get().count()) <= 10;
  }

  static Future<bool> canAddTask() async {
    if (await isPremium()) {
      return true;
    }
    return (await TaskRepository.get().count()) <= 10;
  }

  static Future<bool> isPremium({reload: false}) async {
    var sp = await SharedPreferences.getInstance();

    var isPremium = sp.getBool('isPremium');

    if (isPremium == null || reload ) {
      try {
        IAPManager iap = IAPManager();
        iap.initConnection();

        sp.setBool('isPremium', isPremium = await iap.isPremium());

        iap.endConnection();
      } catch (e) {
        sp.setBool('isPremium', isPremium = false);
      }
    }

    return isPremium;
  }
}
