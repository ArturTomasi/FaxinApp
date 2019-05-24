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

    var result = await db.query(ProductTable.table,
        where: "upper( " +
            ProductTable.name +
            " ) = ? and " +
            "upper( " +
            ProductTable.brand +
            " ) = ? ",
        whereArgs: [product.name.toUpperCase(), product.brand.toUpperCase()]);

    if (result.length == 0) {
      int id = await update(product);
      product.id = id;
      return true;
    } else {
      return false;
    }
  }

  Future update(Product product) async {
    var db = await _appDatabase.getDb();

    return await db.insert( ProductTable.table, {
      ProductTable.name: product.name,
      ProductTable.brand: product.brand
    });
  }

  Future delete(Product product) async {
    var db = await _appDatabase.getDb();

    return await db.delete(ProductTable.table,
        where: ProductTable.id + " = ? ", whereArgs: [product.id]);
  }

  Future<List<Product>> findAll() async {
    var db = await _appDatabase.getDb();

    var result = await db.query(ProductTable.table);
    
    List<Product> products = List();

    for (Map<String, dynamic> item in result) {
      products.add(Product.fromMap(item));
    }
    return products;
  }
}
