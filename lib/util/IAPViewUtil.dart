import 'package:faxinapp/common/util/security_manager.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPViewUtil extends StatefulWidget {
  @override
  _IAPViewUtilState createState() => _IAPViewUtilState();
}

class _IAPViewUtilState extends State<IAPViewUtil> {
  
  @override
  void initState() {
    super.initState();
    FlutterInappPurchase.initConnection;
  }

  @override
  void dispose() {
    super.dispose();
    FlutterInappPurchase.endConnection;
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: AppColors.SECONDARY,
        body: Container(
          child: ListView(
            children: <Widget>[]
              ..add(
                Text("AvailablePurchases"),
              )
              ..add(
                FutureBuilder<List<PurchasedItem>>(
                  future: getAvailablePurchases(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData && snap.data.isNotEmpty) {
                      widget.addAll(snap.data.map((f) {
                        try {
                          return Text(
                              '${f.productId} --- ${f.purchaseToken}  --- ${f.transactionDate}');
                        } catch (e) {
                          return Text('$f --- EROROOR');
                        }
                      }));
                    } else if (snap.hasData && snap.data.isEmpty) {
                      widget.add(Text('Sem dados'));
                    }
                    return Column(children: widget);
                  },
                ),
              )
              //to do
              ..add(
                Text("PurchaseHistory"),
              )
              ..add(
                FutureBuilder<List<PurchasedItem>>(
                  future: getPurchaseHistory(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData && snap.data.isNotEmpty) {
                      widget.addAll(snap.data.map((f) {
                        try {
                          return Text(
                              '${f.productId} --- ${f.purchaseToken}  --- ${f.transactionDate}');
                        } catch (e) {
                          return Text('$f --- EROROOR');
                        }
                      }));
                    } else if (snap.hasData && snap.data.isEmpty) {
                      widget.add(Text('Sem dados'));
                    }
                    return Column(children: widget);
                  },
                ),
              )
              ..add(
                Text("getProducts"),
              )
              ..add(
                FutureBuilder<List<IAPItem>>(
                  future: getProducts(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData && snap.data.isNotEmpty) {
                      widget.addAll(snap.data.map((f) {
                        try {
                          return Text(
                              '${f.productId} --- ${f.description} --- ${f.price}  --- ${f.title}');
                        } catch (e) {
                          return Text('$f --- EROROOR');
                        }
                      }));
                    } else if (snap.hasData && snap.data.isEmpty) {
                      widget.add(Text('Sem dados'));
                    }
                    return Column(children: widget);
                  },
                ),
              )
              ..add(
                Text("IS PREMIUM"),
              )
              ..add(
                FutureBuilder<bool>(
                  future: isPremium(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData) {
                      widget.add( Text( '${snap.data}') );
                    } else {
                      widget.add( Text( 'Sem dados') );
                    }
                    return Column(children: widget);
                  },
                ),
              )

              ..add(
                Text("SHARED"),
              )
              ..add(
                FutureBuilder<bool>(
                  future: isShared(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData) {
                      widget.add( Text( '${snap.data}') );
                    } else {
                      widget.add( Text( 'Sem dados') );
                    }
                    return Column(children: widget);
                  },
                ),
              )

              ..add(
                Text("Security sem reload"),
              )
              ..add(
                FutureBuilder<bool>(
                  future: SecurityManager.isPremium(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData) {
                      widget.add( Text( '${snap.data}') );
                    } else {
                      widget.add( Text( 'Sem dados') );
                    }
                    return Column(children: widget);
                  },
                ),
              )

              ..add(
                Text("Security com reload"),
              )
              ..add(
                FutureBuilder<bool>(
                  future: SecurityManager.isPremium(),
                  builder: (_, snap) {
                    List<Widget> widget = <Widget>[];
                    if (snap.hasData) {
                      widget.add( Text( '${snap.data}') );
                    } else {
                      widget.add( Text( 'Sem dados') );
                    }
                    return Column(children: widget);
                  },
                ),
              )
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        backgroundColor: AppColors.PRIMARY_LIGHT,
        body: Container(
          child: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<List<PurchasedItem>> getAvailablePurchases() async {
    try {
      return await FlutterInappPurchase.getAvailablePurchases();
    } catch (e) {
      show(e.toString());
      return [];
    }
  }

  Future<List<PurchasedItem>> getPurchaseHistory() async {
    try {
      return await FlutterInappPurchase.getPurchaseHistory();
    } catch (e) {
      show(e.toString());
      return [];
    }
  }

  Future<List<IAPItem>> getProducts() async {
    print('ARTTTT');
    try {
      return await FlutterInappPurchase.getProducts(['faxinapp']);
    } catch (e) {
      show(e.toString());
      return [];
    }
  }

  Future<bool> isShared() async {
    var sp = await SharedPreferences.getInstance();

    return sp.getBool('isPremium');
  }

  Future<bool> isPremium() async {
    bool f = false;
    //Fez a compra e não consumiou o produto"
    List<PurchasedItem> purchased =
        await FlutterInappPurchase.getAvailablePurchases();

    if (purchased != null && purchased.isNotEmpty) {
      for (var p in purchased) {
        if (p.productId == "faxiapp"){
          f = true;
        } 
      }
    }

    if ( ! f )
    {
       show( "se chegou aqui deu ruim" );
    }
    //historico de compras
    purchased = await FlutterInappPurchase.getPurchaseHistory();

    if (purchased != null && purchased.isNotEmpty) {
      for (var p in purchased) {
        if (p.productId == 'faxinapp'){
          f = true;
        } 
      }
    }

    return f;
  }

  void show(String wee) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Center(
          child: Text(
            "Aviso",
            style: TextStyle(
              color: AppColors.PRIMARY_LIGHT,
            ),
          ),
        ),
        backgroundColor: AppColors.SECONDARY.withOpacity(0.8),
        contentPadding: EdgeInsets.all(20),
        children: <Widget>[
          Center(
            child: Text(
              wee,
              style: TextStyle(
                color: AppColors.PRIMARY_LIGHT,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
