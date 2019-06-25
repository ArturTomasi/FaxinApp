import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class CleaningView extends StatelessWidget {
  final Cleaning cleaning;

  CleaningView(this.cleaning);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 256.0,
            backgroundColor: AppColors.SECONDARY,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(cleaning.name),
              centerTitle: true,
              background: Container(
                color: AppColors.SECONDARY,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              []
                ..add(Text('T A R E F A S'))
                ..addAll(cleaning.tasks
                    .map<Widget>((f) => Container(
                            child: Text(
                          f.name,
                          style: TextStyle(color: Colors.white),
                        )))
                    .toList())
                ..add(Text('P R O D U T O S'))
                ..addAll(cleaning.products
                    .map<Widget>((f) => Container(child: Text(f.name)))
                    .toList()),
            ),
          ),
        ],
      ),
    );
  }
}
