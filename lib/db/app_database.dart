import 'dart:async';
import 'dart:io';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "faxinapp.db");

    _database = await openDatabase(
      path,
      version: 10,
      onCreate: (
        Database db,
        int version,
      ) async {
        await _createTaskTable(db);
        await _createProductTable(db);
        await _createCleaningTable(db);
        await _createCleaningTaskTable(db);
        await _createCleaningProductTable(db);

        await _initTasks(db);
      },
      onUpgrade: (
        Database db,
        int oldVersion,
        int newVersion,
      ) async {
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

        await _initTasks(db);
      },
    );

    didInit = true;
  }

  Future _createTaskTable(Database db) {
    return db.execute("CREATE TABLE ${TaskTable.table} ("
        "${TaskTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskTable.GUIDELINES} TEXT, "
        "${TaskTable.UUID} TEXT, "
        "${TaskTable.STATE} INTEGER, "
        "${TaskTable.NAME} TEXT);");
  }

  Future _createProductTable(Database db) {
    return db.execute("CREATE TABLE ${ProductTable.table} ("
        "${ProductTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${ProductTable.NAME} TEXT,"
        "${ProductTable.UUID} TEXT,"
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
        "${CleaningTable.TYPE} INTEGER,"
        "${CleaningTable.NEXT_DATE} TEXT,"
        "${CleaningTable.DUE_DATE} TEXT,"
        "${CleaningTable.UUID} TEXT,"
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

  void _initTasks(Database db) {
    var names = [
      "Colocar roupas para lavar",
      "Varrer a casa",
      "Varrer o pátio",
      "Tirar o pó",
      "Limpar guarda-roupa",
      "Limpar eletrodomésticos",
      "Lavar o vaso sanitário",
      "Recolher o lixo",
      "Limpar o chão",
      "Passar aspirador",
      "Limpar os vidros",
      "Limpar janelas e aberturas",
      "Lavar cortinas e tapetes",
      "Descongelar geladeira/freezer",
      "Dedetizar ambientes contra insetos",
      "Trocar filtro do ar-condicionado",
      "Lavar caixa d'água",
      "Trocar filtro do aspirador",
      "Arrumar a cama",
      "Trocar roupa de cama, mesa e banho",
      "Trocar as toalhas de rosto do banheiro",
      "Revisar as roupas",
      "Passar roupas",
      "Organizar despensa de alimentos",
      "Virar colchões das camas"
    ];

    names.forEach(
      (n) {
        var t = Task();
        t.name = n;
        db.insert(
          TaskTable.table,
          {
            TaskTable.NAME: t.name,
            TaskTable.UUID: t.uuid,
            TaskTable.GUIDELINES: 'n/d',
            TaskTable.STATE: t.state,
          },
        );
      },
    );
  }
}
