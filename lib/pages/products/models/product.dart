import 'package:meta/meta.dart';

class Product {
  int id;
  String name;
  String brand;
  double fill = 100;

  Product.create(this.name);

  Product.update({@required this.id, name = "", brand = "", fill = 100}) {
    if (name != "") {
      this.name = name;
    }
    if (brand != "") {
      this.brand = brand;
    }
    if(this.fill<=0){
      this.fill = 100;
    }
  }

  bool operator(o)=>o is Product && o.id == id;
  
  int get hashcode => id.hashCode;

  Product.fromMap(Map<String, dynamic> map)
      : this.update(
            id: map[ProductTable.ID],
            name: map[ProductTable.NAME],
            fill: map[ProductTable.FILL],
            brand: map[ProductTable.BRAND]);

  @override
  String toString() => name;
}

class ProductTable {
  static final table = "products";
  static const ID    = "id";
  static const NAME  = "name";
  static const BRAND = "brand";
  static const FILL  = "fill";
}
