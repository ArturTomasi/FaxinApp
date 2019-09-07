import 'package:faxinapp/common/util/iap_manager.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/pages/tasks/models/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityManager {
  static Future<bool> canAddCleaning() async {
    if (await isPremium()) {
      return true;
    }
    return (await CleaningRepository.get().count()) < 10;
  }

  static Future<bool> canAddProduct() async {
    if (await isPremium()) {
      return true;
    }
    return (await ProductRepository.get().count()) < 10;
  }

  static Future<bool> canAddTask() async {
    if (await isPremium()) {
      return true;
    }
    return (await TaskRepository.get().count()) < 10;
  }

  static Future<bool> isPremium() async {
    var sp = await SharedPreferences.getInstance();

    //await sp.remove('isPremium');
    bool value = sp.getBool('isPremium');
    
    if ( value == null )
    {
      value = await IAPManager.isPremium(); 
    }
    
    return value;
  }
}
