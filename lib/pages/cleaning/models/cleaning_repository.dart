import 'package:faxinapp/db/app_database.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

class CleaningRepository {
  static final CleaningRepository _cleaningRepository =
      CleaningRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  CleaningRepository._internal(this._appDatabase);

  static CleaningRepository get() {
    return _cleaningRepository;
  }

  Future<bool> save(Cleaning cleaning) async {
    var db = await _appDatabase.getDb();

    if (cleaning.id == null || cleaning.id == 0) {
      cleaning.id = await db.insert(CleaningTable.table, {
        CleaningTable.TITLE: cleaning.title,
        CleaningTable.INFO: cleaning.info
      });
    } else {
      await db.update(
          CleaningTable.table,
          {
            CleaningTable.TITLE: cleaning.title,
            CleaningTable.INFO: cleaning.info
          },
          where: '${CleaningTable.ID} = ? ',
          whereArgs: [cleaning.id]);
    }

    if (cleaning.products.isNotEmpty) {
      await db.delete(CleaningProductTable.table,
          where: '${CleaningProductTable.REF_CLEANING} = ?',
          whereArgs: [cleaning.id]);

      for (Product p in cleaning.products) {
        await db.insert(CleaningProductTable.table, {
          CleaningProductTable.REF_CLEANING: cleaning.id,
          CleaningProductTable.REF_PRODUCT: p.id
        });
      }
    }

    if (cleaning.tasks.isNotEmpty) {
      await db.delete(CleaningTaskTable.table,
          where: '${CleaningTaskTable.REF_CLEANING} = ?',
          whereArgs: [cleaning.id]);

      for (Task t in cleaning.tasks) {
        await db.insert(CleaningTaskTable.table, {
          CleaningTaskTable.REF_CLEANING: cleaning.id,
          CleaningTaskTable.REF_TASK: t.id
        });
      }
    }

    return true;
  }

  void delete(Cleaning c) async {
    var db = await _appDatabase.getDb();

    db.delete(CleaningTable.table,
        where: '${CleaningTable.ID} = ?', whereArgs: [c.id]);
    db.delete(CleaningTaskTable.table,
        where: '${CleaningTaskTable.REF_CLEANING} = ?', whereArgs: [c.id]);
    db.delete(CleaningProductTable.table,
        where: '${CleaningProductTable.REF_CLEANING} = ?', whereArgs: [c.id]);
  }

  Future<List<Cleaning>> findAll() async {
    var db = await _appDatabase.getDb();

    var result =
        await db.query(CleaningTable.table, orderBy: CleaningTable.TITLE);

    List<Cleaning> cleanings = List();

    for (Map<String, dynamic> item in result) {
      Cleaning c = Cleaning.fromMap(item);

      var fetchProducts = await db.query(ProductTable.table,
          where: "${ProductTable.ID} in ( " +
              "SELECT ${CleaningProductTable.REF_PRODUCT} FROM ${CleaningProductTable.table} WHERE  ${CleaningProductTable.REF_CLEANING} = ? )",
          whereArgs: [c.id]);

      c.products = [];
      for (Map<String, dynamic> p in fetchProducts) {
        c.products.add(Product.fromMap(p));
      }

      var fetchTasks = await db.query(TaskTable.table,
          where:
              "${TaskTable.ID} in ( SELECT ${CleaningTaskTable.REF_TASK} FROM ${CleaningTaskTable.table} WHERE  ${CleaningTaskTable.REF_CLEANING} = ? )",
          whereArgs: [c.id]);

      c.tasks = [];
      for (Map<String, dynamic> t in fetchTasks) {
        c.tasks.add(Task.fromMap(t));
      }

      cleanings.add(c);
    }

    return cleanings;
  }
}
