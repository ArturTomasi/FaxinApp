import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/products/models/product.dart';

class CleaningProduct {
  Product product;
  Cleaning cleaning;
  int realized, amount;

  CleaningProduct({this.cleaning, this.product, this.amount, this.realized});
  Map<String, dynamic> toJson() =>
      {"uuid": product.uuid, "realized": realized, "amount": amount};
}

class CleaningProductTable {
  static const table = "cleaning_products";
  static const REF_PRODUCT = "ref_product";
  static const REF_CLEANING = "ref_cleaning";
  static const AMOUNT = "amount";
  static const REALIZED = "realized";
}
