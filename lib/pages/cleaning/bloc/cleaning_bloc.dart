import 'dart:async';

import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';

class CleaningBloc implements BlocBase {
  StreamController<List<Cleaning>> _controller =
      StreamController<List<Cleaning>>.broadcast();

  Stream<List<Cleaning>> get cleanings => _controller.stream;

  StreamController<List<Product>> _controller2 =
      StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get products => _controller2.stream;

  CleaningRepository _repository;
  
  CleaningBloc() {
    this._repository = CleaningRepository.get();
  }

  @override
  void dispose() {
    _controller.close();
    _controller2.close();
  }

  refresh() async {
    _controller.sink.add(await _repository.findAll());
  }

  Future delete(Cleaning c) async {
    _repository.delete(c);
  }

  Future save(Cleaning c) async {
    _repository.save(c);
  }

  Future<List<Product>> loadProducts() async {
    List<Product> p = await ProductRepository.get().findAll();

    _controller2.sink.add( p );

    return p;
  }
}
