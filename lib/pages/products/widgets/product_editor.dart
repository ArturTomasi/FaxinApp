import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class ProductEditor extends StatefulWidget {
  final Product product;

  ProductEditor({@required this.product});

  @override
  _ProductEditorState createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: new IconThemeData(color: AppColors.SECONDARY),
          title: Text("Produtos",
              style: TextStyle(color: AppColors.SECONDARY, fontSize: 22)),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (_formState.currentState.validate()) {
                  _formState.currentState.save();
                  product.currentCapacity = product.capacity;
                  product.state = 1;
                  await ProductRepository.get().save(product);
                  Navigator.pop(context);
                }
              },
              child:
                  Text("SALVAR", style: TextStyle(color: AppColors.SECONDARY)),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            color: AppColors.PRIMARY_LIGHT,
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
                              counterStyle:
                                  TextStyle(color: AppColors.SECONDARY),
                              errorBorder: InputBorder.none),
                          maxLength: 80,
                          autofocus: true,
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
                              counterStyle:
                                  TextStyle(color: AppColors.SECONDARY),
                              labelStyle: TextStyle(color: AppColors.SECONDARY),
                              errorBorder: InputBorder.none),
                          maxLength: 80,
                          initialValue: product.branding,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            return value.isEmpty ? "Requerido" : null;
                          },
                          onSaved: (value) {
                            product.branding = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Capacidade",
                              counterStyle:
                                  TextStyle(color: AppColors.SECONDARY),
                              labelStyle: TextStyle(color: AppColors.SECONDARY),
                              errorBorder: InputBorder.none),
                          style: TextStyle(color: Colors.white),
                          initialValue: product.capacity.toString(),
                          validator: (value) {
                            return value.isEmpty ? "Requerido" : null;
                          },
                          onSaved: (value) {
                            product.capacity = double.parse(value);
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () async {
                                if (_formState.currentState.validate()) {
                                  _formState.currentState.save();
                                  product.currentCapacity = product.capacity;
                                  product.state = 1;
                                  await ProductRepository.get().save(product);
                                  Navigator.pop(context);
                                }
                              },
                              color: AppColors.SECONDARY,
                              textColor: Colors.white,
                              child: Text("Salvar",
                                  style: TextStyle(fontSize: 16)),
                            ))
                      ])),
                  key: _formState,
                ),
              ],
            )));
  }
}
