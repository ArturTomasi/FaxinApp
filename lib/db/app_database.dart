import 'dart:async';
import 'dart:io';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/// This is the singleton database class which handlers all database transactions
/// All the task raw queries is handle here and return a Future<T> with result
class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  Database _database;

  static AppDatabase get() {
    return _appDatabase;
  }

  bool didInit = false;

  /// Use this method to access the database which will provide you future of [Database],
  /// because initialization of the database (it has to go through the method channel)
  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "faxinapp.db");
    _database = await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await _createTaskTable(db);
      await _createProductTable(db);
      await _createCleaningTable(db);
      await _createCleaningTaskTable(db);
      await _createCleaningProductTable(db);

    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE IF EXISTS ${TaskTable.table}");
      await db.execute("DROP TABLE IF EXISTS ${ProductTable.table}");
      await db.execute("DROP TABLE IF EXISTS ${CleaningTable.table}");
      await db.execute("DROP TABLE IF EXISTS ${CleaningTaskTable.table}");
      await db.execute("DROP TABLE IF EXISTS ${CleaningProductTable.table}");

      await _createTaskTable(db);
      await _createProductTable(db);
      await _createCleaningTable(db);
      await _createCleaningTaskTable(db);
      await _createCleaningProductTable(db);
    });
    didInit = true;
  }

  Future _createTaskTable(Database db) {
    return db.execute("CREATE TABLE ${TaskTable.table} ("
        "${TaskTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskTable.name} TEXT);");
  }

  Future _createProductTable(Database db) {
    return db.execute("CREATE TABLE ${ProductTable.table} ("
        "${ProductTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${ProductTable.name} TEXT,"
        "${ProductTable.brand} TEXT);");
  }

  Future _createCleaningTable( Database db){
    return db.execute("CREATE TABLE ${CleaningTable.table} ("
        "${CleaningTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${CleaningTable.TITLE} TEXT,"
        "${CleaningTable.INFO} TEXT);");
  }

  Future _createCleaningTaskTable( Database db){
    return db.execute("CREATE TABLE ${CleaningTaskTable.table} ("
        "${CleaningTaskTable.REF_CLEANING} INTEGER,"
        "${CleaningTaskTable.REF_TASK} INTEGER);");
  }

  Future _createCleaningProductTable( Database db){
    return db.execute("CREATE TABLE ${CleaningProductTable.table} ("
        "${CleaningProductTable.REF_CLEANING} INTEGER,"
        "${CleaningProductTable.REF_PRODUCT} INTEGER);");
  }
}
