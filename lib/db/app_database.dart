import 'dart:async';
import 'dart:io';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
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
      version: 20,
      onCreate: (
        Database db,
        int version,
      ) async {
        await _createTaskTable(db);
        await _createProductTable(db);
        await _createCleaningTable(db);
        await _createCleaningTaskTable(db);
        await _createCleaningProductTable(db);

        _initTasks(db);
        _initProducts(db);
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

        _initTasks(db);
        _initProducts(db);
      },
    );

    didInit = true;
  }

  Future _createTaskTable(Database db) {
    return db.execute("CREATE TABLE ${TaskTable.table} ("
        "${TaskTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${TaskTable.GUIDELINES} TEXT, "
        "${TaskTable.UUID} TEXT, "
        "${TaskTable.FIXED} INTEGER DEFAULT 0, "
        "${TaskTable.STATE} INTEGER, "
        "${TaskTable.NAME} TEXT);");
  }

  Future _createProductTable(Database db) {
    return db.execute("CREATE TABLE ${ProductTable.table} ("
        "${ProductTable.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${ProductTable.NAME} TEXT,"
        "${ProductTable.UUID} TEXT,"
        "${ProductTable.FIXED} INTEGER DEFAULT 0, "
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
      "Arrumar camas",
      "Lavar roupas",
      "Dedetizar contra insetos",
      "Descongelar geladeira/freezer",
      "Limpar caixa d'água",
      "Lavar cortinas e tapetes",
      "Limpar o vaso sanitário",
      "Limpar eletrodomésticos",
      "Limpar guarda-roupa",
      "Limpar aberturas",
      "Limpar chão",
      "Varrer chão",
      "Limpar vidros",
      "Organizar despensa",
      "Passar aspirador",
      "Passar roupas",
      "Recolher lixo",
      "Revisar roupas",
      "Tirar pó",
      "Trocar toalhas",
      "Limpar filtro ar-condicionado",
      "Limpar lareira",
    ];

    names.forEach(
      (n) async {
        var t = Task();
        t.name = n;
        await db.insert(
          TaskTable.table,
          {
            TaskTable.NAME: t.name,
            TaskTable.UUID: t.uuid,
            TaskTable.GUIDELINES: '',
            TaskTable.STATE: t.state,
            TaskTable.FIXED: 1
          },
        );
      },
    );
  }

  void _initProducts(Database db) {
    var names = [
      {
        'name': 'Álcool',
        'capacity': 500.0,
      },
      {
        'name': 'Álcool gel',
        'capacity': 500.0,
      },
      {
        'name': 'Detergente',
        'capacity': 500.0,
      },
      {
        'name': 'Desengordurante',
        'capacity': 500.0,
      },
      {
        'name': 'Limpa-vidros',
        'capacity': 500.0,
      },
      {
        'name': 'Sabão',
        'capacity': 1000.0,
      },
      {
        'name': 'Amaciante',
        'capacity': 100.0,
      },
      {
        'name': 'Água sanitária',
        'capacity': 1000.0,
      },
      {
        'name': 'Multiuso',
        'capacity': 500.0,
      },
      {
        'name': 'Desinfetante',
        'capacity': 500.0,
      },
      {
        'name': 'Limpador de uso geral',
        'capacity': 1000.0,
      },
      {
        'name': 'Sapólio',
        'capacity': 500.0,
      },
      {
        'name': 'Vinagre',
        'capacity': 750.0,
      },
    ];

    names.forEach(
      (n) async {
        var p = Product();
        p.name = n['name'];
        p.capacity = n['capacity'];
        p.currentCapacity = p.capacity;

        await db.insert(
          ProductTable.table,
          {
            ProductTable.NAME: p.name,
            ProductTable.UUID: p.uuid,
            ProductTable.STATE: p.state,
            ProductTable.CAPACITY: p.capacity,
            ProductTable.CURRENT_CAPACITY: p.currentCapacity,
            ProductTable.BRANDING: '',
            ProductTable.FIXED: 1
          },
        );
      },
    );
  }
}
