import 'package:uuid/uuid.dart';

class Product {
  int id;
  String uuid = Uuid().v4();
  String name = "";
  String branding = "";
  double capacity = 0;
  double currentCapacity = 0;
  int state = 1;

  Product();

  Product.fromMap(Map<String, dynamic> map) {
    id = map[ProductTable.ID];
    name = map[ProductTable.NAME];
    uuid = map[ProductTable.UUID];
    branding = map[ProductTable.BRANDING];
    capacity = double.parse(map[ProductTable.CAPACITY].toString());
    currentCapacity =
        double.parse(map[ProductTable.CURRENT_CAPACITY].toString());
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
  static const UUID = "uuid";
  static const NAME = "name";
  static const BRANDING = "branding";
  static const CAPACITY = "capacity";
  static const CURRENT_CAPACITY = "current_capacity";
  static const STATE = "state";
}
