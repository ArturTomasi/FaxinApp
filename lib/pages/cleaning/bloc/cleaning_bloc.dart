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

  CleaningRepository _repository;

  StreamController<List<Cleaning>> _controllerPendency =
      StreamController<List<Cleaning>>.broadcast();

  Stream<List<Cleaning>> get pendencies => _controllerPendency.stream;

  List<Cleaning> pendencyCache;

  CleaningBloc() {
    this._repository = CleaningRepository.get();

    findPendents();
  }

  @override
  void dispose() {
    //_controller.close();
    //_controllerPendency.close();
  }

  refresh() async {
    _controller.sink.add(await _repository.findAll());

    findPendents();
  }

  update(Cleaning cleaning, Cleaning next) {
    if (cleaning != null && next != null) {
      int i = pendencyCache.indexOf(cleaning);

      if (i != -1) {
        pendencyCache.removeAt(i);
        pendencyCache.insert(i, next);
      }
    }
  }

  findPendents() async {
    pendencyCache = await _repository.findPendents();

    _controllerPendency.sink.add(pendencyCache);
  }

  Future delete(Cleaning c) async {
    _repository.delete(c);
  }

  Future save(Cleaning c) async {
    _repository.save(c);
  }
}
