import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/products/bloc/product_bloc.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductEditor extends StatelessWidget {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProductBloc bloc = BlocProvider.of(context);

    final Product product = new Product.create("");

    return Container(
        decoration: BoxDecoration(
            color: AppColors.PRIMARY_LIGHT,
            //borderRadius: BorderRadius.vertical(top: Radius.circular(30)) ),
            border: Border(
                top: BorderSide(
                    width: 5,
                    color: AppColors.SECONDARY,
                    style: BorderStyle.solid))),
        height: 225,
        //color: AppColors.PRIMARY_LIGHT,
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
                          onPressed: () async {
                            if (_formState.currentState.validate()) {
                              _formState.currentState.save();
                              await bloc.save(product);
                              Navigator.pop(context);
                            }
                          },
                          color: AppColors.SECONDARY,
                          textColor: Colors.white,
                          child: Text("Salvar"),
                        ))
                  ])),
              key: _formState,
            ),
          ],
        ));
  }
}
