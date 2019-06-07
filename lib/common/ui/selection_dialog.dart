import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class SelectionDialog<T> extends StatefulWidget {
  final List<T> elements;
  //final List<T> favoriteElements;
  final List<T> selecteds;
  final EmptyWidget emptyWidget;
  final Filter<T> filter;
  final ItemRenderer renderer;

  SelectionDialog(this.elements,
      {Key key,
      EmptyWidget emptyWidget,
      Filter filter,
      ItemRenderer renderer,
      List<T> selecteds})
      : assert(renderer != null, 'Renderer cannot be null'),
        this.emptyWidget = emptyWidget != null ? emptyWidget : EmptyWidget(),
        this.filter = filter != null ? filter : new DefaultFilter<T>(),
        this.renderer = renderer,
        this.selecteds = selecteds != null ? selecteds : [],
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState<T>();
}

class _SelectionDialogState<T> extends State<SelectionDialog<T>> {
  List<T> filteredElements;
  List<T> selecteds;
  bool multiSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.PRIMARY_LIGHT,
      contentPadding: EdgeInsets.only(),
      title: _titleWidget(),
      content: Container(
          color: AppColors.PRIMARY_LIGHT,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
              children: []
                //..add(_favouriteWidget())
                ..addAll(_bodyWidget()))),
      actions: _selectWidget(),
    );
  }

  Widget _titleWidget() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: AppColors.SECONDARY),
              labelText: "Procurar",
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 5, color: AppColors.SECONDARY)),
              labelStyle: TextStyle(color: AppColors.SECONDARY)),
          style: TextStyle(color: Colors.white),
          onChanged: _filterElements,
        ),
      ],
    );
  }

  List<Widget> _bodyWidget() {
    if (filteredElements.isEmpty) {
      return [widget.emptyWidget.widget()];
    } else {
      return filteredElements
          .map((e) => GestureDetector(
              onLongPress: () {
                setState(() {
                  multiSelected = true;
                  selecteds.add(e);
                });
              },
              child: SimpleDialogOption(
                  child: widget.renderer.renderer(e, selecteds.contains(e)),
                  onPressed: () {
                    setState(() {
                      if (multiSelected) {
                        if (!selecteds.contains(e)) {
                          selecteds.add(e);
                        } else {
                          selecteds.remove(e);
                        }
                      } else {
                        _selectItem(e);
                      }
                    });
                  })))
          .toList();
    }
  }

  List<Widget> _selectWidget() {
    List<Widget> buttons = [];
    buttons.add(RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.only(left: 15, right: 15),
      onPressed: () async {
        Navigator.pop(context);
      },
      color: AppColors.PRIMARY_DARK,
      textColor: Colors.white,
      child: Text("Cancelar", style: TextStyle(fontSize: 14)),
    ));

    if (multiSelected) {
      buttons.add(RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.only(left: 25, right: 25),
        onPressed: () async {
          Navigator.pop(context, selecteds);
        },
        color: AppColors.SECONDARY,
        textColor: Colors.white,
        child: Text("Ok", style: TextStyle(fontSize: 16)),
      ));
    }
    return buttons;
  }

  @override
  void initState() {
    this.selecteds = widget.selecteds;
    multiSelected = selecteds.isNotEmpty;
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    setState(() {
      filteredElements =
          widget.elements.where((e) => widget.filter.filter(s, e)).toList();
    });
  }

  void _selectItem(T e) {
    Navigator.pop(context, [e]);
  }
}

abstract class Filter<T> {
  bool filter(String text, T element);
}

class DefaultFilter<T> implements Filter<T> {
  bool filter(String text, T e) {
    if (text == null || text.isEmpty) return true;

    return e.toString().toUpperCase().contains(text.toUpperCase());
  }
}

abstract class ItemRenderer<T> {
  Widget renderer(T item, bool sel);
}

class EmptyWidget {
  Widget widget() => Center(
          child: Text(
        'Sem elementos para selecionar',
        style: TextStyle(color: AppColors.SECONDARY),
      ));
}
