import 'package:faxinapp/db/app_database.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

import 'cleaning_product.dart';
import 'cleaning_task.dart';

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
        CleaningTable.NAME: cleaning.name,
        CleaningTable.GUIDELINES: cleaning.guidelines,
        CleaningTable.FREQUENCY: cleaning.frequency.index,
        CleaningTable.NEXT_DATE: cleaning.nextDate.toIso8601String(),
        CleaningTable.DUE_DATE: cleaning.dueDate != null
            ? cleaning.dueDate.toIso8601String()
            : null,
        CleaningTable.ESTIMATED_TIME: cleaning.estimatedTime.toString()
      });
    } else {
      await db.update(
          CleaningTable.table,
          {
            CleaningTable.NAME: cleaning.name,
            CleaningTable.GUIDELINES: cleaning.guidelines,
            CleaningTable.FREQUENCY: cleaning.frequency.index,
            CleaningTable.NEXT_DATE: cleaning.nextDate.toIso8601String(),
            CleaningTable.DUE_DATE: cleaning.dueDate != null
                ? cleaning.dueDate.toIso8601String()
                : null,
            CleaningTable.ESTIMATED_TIME: cleaning.estimatedTime.toString()
          },
          where: '${CleaningTable.ID} = ? ',
          whereArgs: [cleaning.id]);
    }

    if (cleaning.products != null && cleaning.products.isNotEmpty) {
      await db.delete(CleaningProductTable.table,
          where: '${CleaningProductTable.REF_CLEANING} = ?',
          whereArgs: [cleaning.id]);

      for (Product p in cleaning.products) {
        await db.insert(CleaningProductTable.table, {
          CleaningProductTable.REF_CLEANING: cleaning.id,
          CleaningProductTable.REF_PRODUCT: p.id,
          CleaningProductTable.AMOUNT: 0,
          CleaningProductTable.REALIZED: false
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
          CleaningTaskTable.REF_TASK: t.id,
          CleaningTaskTable.REALIZED: false
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

  Future<Cleaning> find(int id) async {
    var db = await _appDatabase.getDb();

    var result = await db.query(CleaningTable.table,
        where: '${CleaningTable.ID} = ?',
        whereArgs: [id],
        orderBy: CleaningTable.NAME);

    if (result.isNotEmpty) {
      Cleaning c = Cleaning.fromMap(result.first);

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

      return c;
    }

    return null;
  }

  Future<List<Cleaning>> findPendents() async {
    var db = await _appDatabase.getDb();

    var result = await db.query(CleaningTable.table,
        where: '${CleaningTable.DUE_DATE} is null',
        orderBy: CleaningTable.NEXT_DATE);

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

  Future<List<Cleaning>> findAll() async {
    var db = await _appDatabase.getDb();

    var result =
        await db.query(CleaningTable.table, orderBy: CleaningTable.NEXT_DATE);

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

  Future finish(Cleaning cleaning, List<CleaningTask> tasks,
      List<CleaningProduct> products) async {
    var db = await _appDatabase.getDb();

    //finaliza a limpeza
    await db.update(CleaningTable.table,
        {CleaningTable.DUE_DATE: DateTime.now().toIso8601String()},
        where: '${CleaningTable.ID} = ? ', whereArgs: [cleaning.id]);

    tasks.forEach((task) async => await db.update(
        CleaningTaskTable.table, {CleaningTaskTable.REALIZED: task.realized},
        where:
            "${CleaningTaskTable.REF_CLEANING} = ? and ${CleaningTaskTable.REF_TASK} = ?",
        whereArgs: [cleaning.id, task.task.id]));

    products.forEach((product) async {
      await db.update(
          CleaningProductTable.table,
          {
            CleaningProductTable.REALIZED: product.realized,
            CleaningProductTable.AMOUNT: product.amount
          },
          where:
              "${CleaningProductTable.REF_CLEANING} = ? and ${CleaningProductTable.REF_PRODUCT} = ?",
          whereArgs: [cleaning.id, product.product.id]);

      await db.update(
          ProductTable.table,
          {
            ProductTable.CURRENT_CAPACITY:
                product.product.currentCapacity - product.amount,
          },
          where: "${ProductTable.ID} = ?",
          whereArgs: [product.product.id]);
    });

    products.forEach((product) => {});

    //cria nova a limpeza
    Cleaning newCleaning = Cleaning();
    newCleaning.estimatedTime = cleaning.estimatedTime;
    newCleaning.frequency = cleaning.frequency;
    newCleaning.guidelines = cleaning.guidelines;
    newCleaning.name = cleaning.name;
    newCleaning.tasks = cleaning.tasks;
    newCleaning.products = cleaning.products;
    newCleaning.nextDate = cleaning.futureDate();

    await this.save(newCleaning);

    return newCleaning;
  }
}
