import 'package:faxinapp/db/app_database.dart';
import 'package:faxinapp/pages/products/models/product.dart';

class ProductRepository {
  static final ProductRepository _productRepository =
      ProductRepository._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  ProductRepository._internal(this._appDatabase);

  static ProductRepository get() {
    return _productRepository;
  }

  Future<bool> save(Product product) async {
    var db = await _appDatabase.getDb();

    if (product.id == null || product.id == 0) {
      product.id = await db.insert(
        ProductTable.table,
        {
          ProductTable.NAME: product.name,
          ProductTable.UUID: product.uuid,
          ProductTable.CAPACITY: product.capacity,
          ProductTable.CURRENT_CAPACITY: product.currentCapacity,
          ProductTable.BRANDING: product.branding,
          ProductTable.STATE: product.state
        },
      );
    } else {
      await db.update(
        ProductTable.table,
        {
          ProductTable.NAME: product.name,
          ProductTable.UUID: product.uuid,
          ProductTable.CAPACITY: product.capacity,
          ProductTable.CURRENT_CAPACITY: product.currentCapacity,
          ProductTable.BRANDING: product.branding,
          ProductTable.STATE: product.state
        },
        where: '${ProductTable.ID} = ? ',
        whereArgs: [product.id],
      );
    }

    return true;
  }

  Future delete(Product product) async {
    var db = await _appDatabase.getDb();

    return await db.update(ProductTable.table, {ProductTable.STATE: 0},
        where: ProductTable.ID + " = ? ", whereArgs: [product.id]);
  }

  Future<List<Product>> findAll() async {
    var db = await _appDatabase.getDb();

    var result = await db.query(ProductTable.table,
        where: "${ProductTable.STATE} = 1",
        orderBy: '${ProductTable.NAME} COLLATE RTRIM');

    List<Product> products = List();

    for (Map<String, dynamic> item in result) {
      products.add(Product.fromMap(item));
    }
    return products;
  }

  Future<List<Product>> findEmpty() async {
    var db = await _appDatabase.getDb();

    var result = await db.query(ProductTable.table,
        where:
            "${ProductTable.STATE} = 1 and ((${ProductTable.CURRENT_CAPACITY} / ${ProductTable.CAPACITY}) * 100) < 25",
        orderBy: ProductTable.NAME);

    List<Product> products = List();

    for (Map<String, dynamic> item in result) {
      products.add(Product.fromMap(item));
    }
    return products;
  }

  Future import(List<Product> products) async {
    var db = await _appDatabase.getDb();

    products.forEach((p) async {
      var result = await db.query(ProductTable.table,
          where: "${ProductTable.UUID} = ?", whereArgs: [p.uuid]);

      if (result.isNotEmpty) {
        p.id = result.first['id'];
      } else {
        p.id = null;
      }

      await save(p);
    });
  }

  Future fill(Product product) async {
    var db = await _appDatabase.getDb();

    return await db.update(
        ProductTable.table, {ProductTable.CURRENT_CAPACITY: product.capacity},
        where: ProductTable.ID + " = ? ", whereArgs: [product.id]);
  }

  Future<List> getCharProducts() async {
    var db = await _appDatabase.getDb();

    return db.rawQuery("select "
        " P.name, ( CP.used / P.capacity ) as value"
        " from "
        " products P "
        " inner join "
        " ( "
        " select "
        " sum( amount ) as used,  "
        " ref_product "
        " from "
        " cleaning_products "
        " where "
        " realized = 1 "
        " group by "
        "ref_product "
        " ) as CP "
        " on "
        " CP.ref_product = P.id "
        " where "
        " P.state = 1 ");
  }

  Future<int> count() async {
    var db = await _appDatabase.getDb();

    var result = await db.rawQuery(
        'select count(*) as cnt from ${ProductTable.table} where ${ProductTable.FIXED} = 0 and ${ProductTable.STATE} = 1');

    if (result.isNotEmpty) return result[0]["cnt"];
    return 0;
  }
}
