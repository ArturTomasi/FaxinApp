class Product {
  int id;
  String name;
  String branding;
  double capacity = 0;
  double currentCapacity = 0;
  int state;

  Product();

  Product.fromMap(Map<String, dynamic> map) {
    id = map[ProductTable.ID];
    name = map[ProductTable.NAME];
    branding = map[ProductTable.BRANDING];
    capacity = map[ProductTable.CAPACITY];
    currentCapacity = map[ProductTable.CURRENT_CAPACITY];
    state = map[ProductTable.STATE];
  }

  bool operator(o) => o is Product && o.id == id;

  int get hashcode => id.hashCode;

  @override
  String toString() => name;
}

class ProductTable {
  static final table = "products";
  static const ID = "id";
  static const NAME = "name";
  static const BRANDING = "branding";
  static const CAPACITY = "capacity";
  static const CURRENT_CAPACITY = "current_capacity";
  static const STATE = "state";
}
