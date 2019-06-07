import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

class Cleaning {
  int id;
  String title, info;
  List<Product> products;
  List<Task> tasks;

  Cleaning.create(
      {this.title = "",
      this.info = "",
      this.id = 0,
      this.products = const [],
      this.tasks = const []});

  Cleaning.fromMap(Map<String, dynamic> map)
      : this.create(
            title: map[CleaningTable.TITLE],
            info: map[CleaningTable.INFO],
            id: map[CleaningTable.ID]);
}

class CleaningTable {
  static const table = "cleanings";
  static const ID = "id";
  static const TITLE = "title";
  static const INFO = "info";
}

class CleaningTaskTable {
  static const table = "cleaning_tasks";
  static const REF_TASK = "ref_task";
  static const REF_CLEANING = "ref_cleaning";
}

class CleaningProductTable {
  static const table = "cleaning_products";
  static const REF_PRODUCT = "ref_product";
  static const REF_CLEANING = "ref_cleaning";
}
