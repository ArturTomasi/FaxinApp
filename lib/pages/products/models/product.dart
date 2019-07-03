class Product {
  int id;
  String name = "";
  String branding = "";
  double capacity = 0;
  double currentCapacity = 0;
  int state = 1;

  Product({this.id}) : super();

  Product.fromMap(Map<String, dynamic> map) {
    id = map[ProductTable.ID];
    name = map[ProductTable.NAME];
    branding = map[ProductTable.BRANDING];
    capacity = map[ProductTable.CAPACITY];
    currentCapacity = map[ProductTable.CURRENT_CAPACITY];
    state = map[ProductTable.STATE];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

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
