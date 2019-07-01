import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductBloc bloc = ProductBloc();
    bloc.getEmpty();

    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<List<Product>>(
        stream: bloc.products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ProductListEmptyWidget(snapshot.data);
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
      ),
    );
  }
}

class ProductListEmptyWidget extends StatelessWidget {
  final List<Product> _products;

  ProductListEmptyWidget(this._products);

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
                    _bloc.fill(_products[i]);
                    _bloc.getEmpty();

                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.SECONDARY,
                        content: Text(
                          "Produto reposto com sucesso!",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                },
                background: Container(
                  color: Colors.lightGreen,
                  child: ListTile(
                    trailing: Text(
                      "Repor produto",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                child: ListTile(
                  leading: new Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
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
                    _products[i].branding.toLowerCase(),
                    style: TextStyle(
                        color: AppColors.SECONDARY,
                        fontStyle: FontStyle.italic),
                  ),
                  title: new Text(
                    _products[i].name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            }));
  }
}
