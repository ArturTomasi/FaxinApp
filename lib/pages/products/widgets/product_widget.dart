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
    _bloc.showCreate(true);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Produtos"),
        ),
        floatingActionButton: StreamBuilder<bool>(
            stream: _bloc.showFAB,
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data) {
                return FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      _bloc.showCreate(false);
                      await _scaffoldKey.currentState
                          .showBottomSheet((b) => ProductEditor())
                          .closed;
                      _bloc.showCreate(true);
                    });
              }
              return Container();
            }),
        body: BlocProvider(bloc: _bloc, child: ProductList()));
  }
}
