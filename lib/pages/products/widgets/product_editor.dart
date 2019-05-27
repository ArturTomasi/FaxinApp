import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductEditor extends StatelessWidget {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ProductBloc bloc = BlocProvider.of<ProductBloc>(context);
    final Product product = new Product.create("");

    return Container(
        decoration: ShapeDecoration(
            color: AppColors.PRIMARY_LIGHT,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              side: new BorderSide(
                  color: AppColors.SECONDARY,
                  style: BorderStyle.solid,
                  width: 1),
            )),
        height: 225,
        child: ListView(
          children: <Widget>[
            Form(
              autovalidate: false,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Nome",
                          labelStyle: TextStyle(color: AppColors.SECONDARY),
                          counterStyle: TextStyle(color: AppColors.SECONDARY),
                          errorBorder: InputBorder.none),
                      maxLength: 80,
                      initialValue: product.name,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        return value.isEmpty ? "Requerido *" : null;
                      },
                      onSaved: (value) {
                        product.name = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Marca",
                          counterStyle: TextStyle(color: AppColors.SECONDARY),
                          labelStyle: TextStyle(color: AppColors.SECONDARY),
                          errorBorder: InputBorder.none),
                      maxLength: 80,
                      initialValue: product.name,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        return value.isEmpty ? "Requerido" : null;
                      },
                      onSaved: (value) {
                        product.brand = value;
                      },
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () async {
                            if (_formState.currentState.validate()) {
                              _formState.currentState.save();
                              await bloc.save(product);
                              Navigator.pop(context);
                              bloc.refresh();
                            }
                          },
                          color: AppColors.SECONDARY,
                          textColor: Colors.white,
                          child: Text("Salvar", style: TextStyle(fontSize: 16)),
                        ))
                  ])),
              key: _formState,
            ),
          ],
        ));
  }
}
