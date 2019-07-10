import 'dart:async';

import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/ui/selection_dialog.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SelectionPicker<T> extends StatefulWidget {
  final ValueChanged<List<T>> onChanged;
  final FormFieldSetter<List<T>> onSaved;
  final List<T> selecteds;
  final List<T> elements;
  final String title;
  final ItemRenderer<T> renderer;
  final bool singleSelected;

  SelectionPicker(
      {this.onChanged,
      this.onSaved,
      this.singleSelected = false,
      this.title = "Seletor",
      this.renderer,
      this.elements = const [],
      this.selecteds = const []});

  @override
  State<StatefulWidget> createState() => _SelectionPickerState<T>();
}

class _SelectionPickerState<T> extends State<SelectionPicker<T>> {
  final SelectionBloc<T> bloc = new SelectionBloc<T>();
  List<T> _tempSelecteds;

  @override
  void initState() {
    super.initState();
    _tempSelecteds = widget.selecteds;
    bloc.selecteds.listen((data) => _publishSelection(_tempSelecteds = data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            List<T> value = await showDialog(
                context: context,
                builder: (c) {
                  return SelectionDialog<T>(
                    widget.elements,
                    singleSelected: widget.singleSelected,
                    selecteds: _tempSelecteds,
                    renderer: widget.renderer,
                  );
                });

            bloc.add(value);
          },
          child: StreamBuilder<List<T>>(
            stream: bloc.selecteds,
            initialData: widget.selecteds,
            builder: (context, snapshot) {
              return Container(
                color: AppColors.PRIMARY_LIGHT,
                padding: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(widget.title,
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.SECONDARY),
                              textAlign: TextAlign.start)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      snapshot.hasData
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runSpacing: 5,
                              children: <Widget>[]..addAll(snapshot.data
                                  .map<Chip>((p) => Chip(
                                      labelStyle: TextStyle(
                                          color: AppColors.PRIMARY_DARK),
                                      backgroundColor: AppColors.SECONDARY,
                                      labelPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      label: Text(p.toString())))
                                  .toList()),
                            )
                          : Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Toque para selecionar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        color: AppColors.PRIMARY_DARK,
                        width: double.infinity,
                        height: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _publishSelection(List<T> e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }
}

class SelectionBloc<T> implements BlocBase {
  StreamController<List<T>> controller =
      new StreamController<List<T>>.broadcast();

  Stream<List<T>> get selecteds => controller.stream;

  @override
  void dispose() {
    controller.close();
  }

  void add(List<T> els) {
    controller.sink.add(els);
  }
}
