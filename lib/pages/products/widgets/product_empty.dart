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
                padding: EdgeInsets.symmetric(horizontal: 50),
                color: AppColors.PRIMARY_LIGHT,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 100,
                        color: AppColors.SECONDARY,
                      ),
                      Text(
                        "Serão exibidos aqui produtos com 25% ou menos de sua capacidade!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.SECONDARY,
                        ),
                      )
                    ],
                  ),
                ),
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
        physics: BouncingScrollPhysics(),
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
              color: AppColors.SECONDARY,
              child: ListTile(
                trailing: Text(
                  "Repor produto",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            child: ListTile(
              leading: new Icon(
                Icons.shopping_cart,
                color: AppColors.SECONDARY,
              ),
              trailing: Chip(
                backgroundColor: AppColors.SECONDARY,
                label: Text(
                  '${((_products[i].currentCapacity / _products[i].capacity) * 100).round()}%',
                  style: TextStyle(),
                ),
              ),
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
