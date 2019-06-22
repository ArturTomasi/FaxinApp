import 'dart:async';
import 'dart:io';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  AppDatabase._internal();

  Database _database;

  static AppDatabase get() {
    return _appDatabase;
  }

  bool didInit = false;

  Future<Database> getDb() async {
    if (!didInit) await _init();
    return _database;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "faxinapp.db");
    _database = await openDatabase(path, version: 6,
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
        "${TaskTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskTable.GUIDELINES} TEXT, "
        "${TaskTable.STATE} INTEGER, "
        "${TaskTable.NAME} TEXT);");
  }

  Future _createProductTable(Database db) {
    return db.execute("CREATE TABLE ${ProductTable.table} ("
        "${ProductTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${ProductTable.NAME} TEXT,"
        "${ProductTable.BRANDING} TEXT,"
        "${ProductTable.CAPACITY} DOUBLE,"
        "${ProductTable.CURRENT_CAPACITY} DOUBLE,"
        "${ProductTable.STATE} INT );");
  }

  Future _createCleaningTable(Database db) {
    return db.execute("CREATE TABLE ${CleaningTable.table} ("
        "${CleaningTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${CleaningTable.NAME} TEXT,"
        "${CleaningTable.FREQUENCY} INTEGER,"
        "${CleaningTable.NEXT_DATE} TEXT,"
        "${CleaningTable.START_DATE} TEXT,"
        "${CleaningTable.END_DATE} TEXT,"
        "${CleaningTable.ESTIMATED_TIME} TEXT,"
        "${CleaningTable.GUIDELINES} TEXT);");
  }

  Future _createCleaningTaskTable(Database db) {
    return db.execute("CREATE TABLE ${CleaningTaskTable.table} ("
        "${CleaningTaskTable.REF_CLEANING} INTEGER,"
        "${CleaningTaskTable.REALIZED} INTEGER,"
        "${CleaningTaskTable.REF_TASK} INTEGER);");
  }

  Future _createCleaningProductTable(Database db) {
    return db.execute("CREATE TABLE ${CleaningProductTable.table} ("
        "${CleaningProductTable.REF_CLEANING} INTEGER,"
        "${CleaningProductTable.REALIZED} INTEGER,"
        "${CleaningProductTable.AMOUNT} DOUBLE,"
        "${CleaningProductTable.REF_PRODUCT} INTEGER);");
  }
}
