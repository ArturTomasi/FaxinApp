import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/animate_route.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/widgets/cleaning_editor.dart';
import 'package:flutter/material.dart';

import 'cleaning_list.dart';

class CleaningWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Faxinas"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            var bloc = BlocProvider(
              bloc: _bloc,
              child: CleaningEditor(
                cleaning: Cleaning(),
              ),
            );

            await Navigator.of(context).push(
                new AnimateRoute(fullscreenDialog: true, builder: (c) => bloc));

            _bloc.refresh();
          }),
      body: BlocProvider(
        bloc: _bloc,
        child: CleaningList(),
      ),
    );
  }
}
