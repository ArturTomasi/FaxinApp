import 'package:meta/meta.dart';

class Product {
  int id;
  String name;
  String brand;

  Product.create(this.name);

  Product.update({@required this.id, name = "", brand = ""}) {
    if (name != "") {
      this.name = name;
    }
    if (brand != "") {
      this.brand = brand;
    }
  }

  bool operator(o) => o is Product && o.id == id;

  Product.fromMap(Map<String, dynamic> map)
      : this.update(
            id: map[ProductTable.id],
            name: map[ProductTable.name],
            brand: map[ProductTable.brand]);
}

class ProductTable {
  static final table = "products";
  static final id = "id";
  static final name = "name";
  static final brand = "brand";
}
