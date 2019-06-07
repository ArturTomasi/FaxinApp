import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/selection_dialog.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_editor.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class CleaningWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Faxinas"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              var bloc = BlocProvider(
                bloc: CleaningBloc(),
                child: CleaningEditor(),
              );

              Cleaning x = await Navigator.of(context).push(
                  new MaterialPageRoute(
                      fullscreenDialog: true, builder: (c) => bloc));

              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  backgroundColor: AppColors.SECONDARY,
                  content: Text(
                    x.title + "\n" + x.info + "\n" + x.products.toString(),
                    style: TextStyle(fontSize: 16),
                  )));
            }),
        body: Container(
            color: AppColors.PRIMARY_LIGHT,
            child: Center(
                child: new Icon(
              Icons.clear_all,
              color: AppColors.SECONDARY,
              size: 100,
            ))));
  }
}

class MyWidget implements ItemRenderer<Product> {
  @override
  Widget renderer(Product p, bool sel) {
    return Container(
        alignment: Alignment(-0.8, 0),
        height: 50,
        color: !sel ? AppColors.PRIMARY_LIGHT : AppColors.PRIMARY,
        child: Text(
            p.name.substring(0, 1).toUpperCase() +
                p.name.substring(1, p.name.length).toLowerCase(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}
