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

    int id = await db.insert(CleaningTable.table, {
      CleaningTable.TITLE: cleaning.title,
      CleaningTable.INFO: cleaning.info
    });

    cleaning.id = id;

    var batch = db.batch();

    if (cleaning.products.isNotEmpty) {
      cleaning.products.map((p) => batch.insert(CleaningProductTable.table, {
            CleaningProductTable.REF_CLEANING: cleaning.id,
            CleaningProductTable.REF_PRODUCT: p.id
          }));
    }

    if (cleaning.tasks.isNotEmpty) {
      cleaning.tasks.map((t) => batch.insert(CleaningTaskTable.table, {
            CleaningTaskTable.REF_CLEANING: cleaning.id,
            CleaningTaskTable.REF_TASK: t.id
          }));
    }

    await batch.commit();

    return true;
  }

  delete( Cleaning c ){
    print( c );
  }

  Future<List<Cleaning>> findAll() async {
    var db = await _appDatabase.getDb();

    var result =
        await db.query(CleaningTable.table, orderBy: CleaningTable.TITLE);

    List<Cleaning> cleanings = List();

    for (Map<String, dynamic> item in result) {
      Cleaning c = Cleaning.fromMap(item);

      var fetchProducts = await db.query(ProductTable.name,
          where:
              "${ProductTable.id} in ( SELECT ${CleaningProductTable.REF_PRODUCT} FORM ${CleaningProductTable.table} WHERE  ${CleaningProductTable.REF_CLEANING} = ? )",
          whereArgs: [c.id]);

      for (Map<String, dynamic> p in fetchProducts) {
        c.products.add(Product.fromMap(p));
      }

      var fetchTasks = await db.query(TaskTable.name,
          where:
              "${TaskTable.id} in ( SELECT ${CleaningTaskTable.REF_TASK} FORM ${CleaningTaskTable.table} WHERE  ${CleaningTaskTable.REF_CLEANING} = ? )",
          whereArgs: [c.id]);

      for (Map<String, dynamic> t in fetchTasks) {
        c.tasks.add(Task.fromMap(t));
      }

      cleanings.add(c);
    }

    return cleanings;
  }
}
