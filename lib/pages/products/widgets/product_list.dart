import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/widgets/product_editor.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductBloc bloc = BlocProvider.of<ProductBloc>(context);
    bloc.refresh();

    return StreamBuilder<List<Product>>(
      stream: bloc.products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return ProductListWidget(snapshot.data);
          } else {
            return Container(
              color: AppColors.PRIMARY_LIGHT,
              child: Center(
                  child: Icon(Icons.shopping_cart,
                      size: 100, color: AppColors.SECONDARY)),
            );
          }
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
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          return Dismissible(
            key: ObjectKey(_products[i]),
            direction: DismissDirection.endToStart,
            confirmDismiss: (d) {
              if (_products[i].fixed == 0) {
                return Future.value(true);
              }
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.SECONDARY,
                  content: Text(
                    "Produto padrão não pode ser excluído",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );

              return Future.value(false);
            },
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
              child:
                  ListTile(trailing: Icon(Icons.delete, color: Colors.white)),
            ),
            child: ListTile(
              onTap: () async {
                await Navigator.of(context).push(
                  AnimateRoute(
                    fullscreenDialog: true,
                    builder: (c) => ProductEditor(
                      product: _products[i],
                    ),
                  ),
                );
                BlocProvider.of<ProductBloc>(context).refresh();
              },
              leading: new Icon(
                Icons.shopping_cart,
                color: AppColors.SECONDARY,
              ),
              trailing: Chip(
                  backgroundColor: AppColors.SECONDARY,
                  label: Text(
                    '${((_products[i].currentCapacity / _products[i].capacity) * 100).round()}%',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
              subtitle: new Text(
                _products[i].branding,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              title: new Text(
                _products[i].name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
