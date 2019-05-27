import 'dart:async';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';

class ProductBloc extends BlocBase {
  StreamController<List<Product>> _productController =
      StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get products => _productController.stream;

  StreamController<bool> _showFABController =
      StreamController<bool>.broadcast();

  Stream<bool> get showFAB => _showFABController.stream;


  @override
  void dispose() {
    _productController.close();
    _showFABController.close();
  }

  ProductRepository _repository;

  ProductBloc() {
    _repository = ProductRepository.get();
  }

  void showCreate( bool b ){
    _showFABController.sink.add(b);
  }

  void refresh() async {
    _productController.sink.add( await _repository.findAll() );
  }

  void delete( Product p ){
    _repository.delete( p );
  }

  Future save(Product p) async {
    await _repository.save(p);
  }
}
