import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductBloc bloc = BlocProvider.of(context);
    bloc.refresh();

    return StreamBuilder<List<Product>>(
      stream: bloc.products,
      builder: (context, snapshot) {
        if (snapshot.hasData ) {
          return ProductListWidget(snapshot.data);
        } else {
          return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class ProductListWidget extends StatelessWidget {
  final List<Product> _products;

  ProductListWidget(this._products);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.PRIMARY_LIGHT,
        child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int i) {
              return Dismissible(
                  key: ObjectKey(_products[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      ProductBloc _bloc = BlocProvider.of<ProductBloc>(context);
                      _bloc.delete(_products[i]);
                      _bloc.refresh();
                      
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppColors.SECONDARY,
                          content: Text(
                            "Produto excluida com sucesso!",
                            style: TextStyle(fontSize: 16),
                          )));
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: ListTile(
                        trailing: Icon(Icons.delete, color: Colors.white)),
                  ),
                  child: ListTile(
                      leading: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      subtitle:  new Text(_products[i].brand.toLowerCase(), style: TextStyle( color: AppColors.SECONDARY, fontStyle: FontStyle.italic), ),
                      title: new Text(_products[i].name.toUpperCase(),
                          style:
                              TextStyle(color: Colors.white, fontSize: 20))));
            }));
  }
}
