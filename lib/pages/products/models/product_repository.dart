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

    product.id = await db.insert(ProductTable.table, {
      ProductTable.NAME: product.name,
      ProductTable.CAPACITY: product.capacity,
      ProductTable.CURRENT_CAPACITY: product.currentCapacity,
      ProductTable.BRANDING: product.branding,
      ProductTable.STATE: product.state
    });
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
        where: "${ProductTable.STATE} = 1", orderBy: ProductTable.NAME);

    List<Product> products = List();

    for (Map<String, dynamic> item in result) {
      products.add(Product.fromMap(item));
    }
    return products;
  }
}
