import 'package:faxinapp/common/util/security_manager.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/products/models/product_repository.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/licensing_expired.dart';
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

    return FutureBuilder(
      future: SecurityManager.canAddProduct(),
      builder: (_, snap) {
        if (snap.hasData) {
          return snap.data || (product.id != null && product.id > 0)
              ? Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text("Produtos"),
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
                        child: Text("SALVAR",
                            style: TextStyle(
                              color: AppColors.PRIMARY_LIGHT,
                            )),
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
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Nome",
                                      labelStyle:
                                          TextStyle(color: AppColors.SECONDARY),
                                      counterStyle:
                                          TextStyle(color: AppColors.SECONDARY),
                                      errorBorder: InputBorder.none),
                                  maxLength: 80,
                                  autofocus: true,
                                  initialValue: product.name,
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
                                      labelStyle:
                                          TextStyle(color: AppColors.SECONDARY),
                                      errorBorder: InputBorder.none),
                                  maxLength: 80,
                                  initialValue: product.branding,
                                  onSaved: (value) {
                                    product.branding = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Capacidade",
                                      counterStyle:
                                          TextStyle(color: AppColors.SECONDARY),
                                      labelStyle:
                                          TextStyle(color: AppColors.SECONDARY),
                                      errorBorder: InputBorder.none),
                                  initialValue: product.capacity > 0
                                      ? product.capacity.toString()
                                      : '',
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Requerido";
                                    } else {
                                      try {
                                        if (double.parse(value) <= 0) {
                                          return "Capacidade deve ser maior que zero";
                                        }
                                      } catch (ex) {
                                        return "Número inválido";
                                      }
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    product.capacity = double.parse(value);
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                                SizedBox(height: 50),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onPressed: () async {
                                      if (_formState.currentState.validate()) {
                                        _formState.currentState.save();
                                        product.currentCapacity =
                                            product.capacity;
                                        product.state = 1;
                                        await ProductRepository.get()
                                            .save(product);
                                        Navigator.pop(context);
                                      }
                                    },
                                    color: AppColors.SECONDARY,
                                    textColor: Colors.white,
                                    child: Text(
                                      "Salvar",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          key: _formState,
                        ),
                      ],
                    ),
                  ),
                )
              : LicensingExipred();
        } else {
          return Container(
            color: AppColors.PRIMARY_LIGHT,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
