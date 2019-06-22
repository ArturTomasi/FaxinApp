import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/widgets/product_editor.dart';
import 'package:faxinapp/pages/products/widgets/product_list.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ProductBloc _bloc = BlocProvider.of<ProductBloc>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Produtos"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(new MaterialPageRoute(
                  fullscreenDialog: true, builder: (c) => ProductEditor()));
              _bloc.refresh();
            }),
        body: BlocProvider(bloc: _bloc, child: ProductList()));
  }
}
