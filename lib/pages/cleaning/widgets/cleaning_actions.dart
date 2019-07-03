import 'dart:math' as math;

import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';

class CleaningActions extends StatefulWidget {
  final Cleaning cleaning;
  final VoidCallback onEdit;
  final VoidCallback onDone;
  final VoidCallback onDelete;

  CleaningActions(this.cleaning, {this.onDelete, this.onDone, this.onEdit});

  @override
  State<StatefulWidget> createState() => _CleaningActionsState();
}

class _CleaningActionsState extends State<CleaningActions>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 70.0,
          width: 120.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.elliptical(10, 10),
                      right: Radius.elliptical(10, 10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Concluir",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  heroTag: 'done',
                  onPressed: () async {
                    widget.onDone();
                  },
                  child: Icon(
                    Icons.done,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 120.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.elliptical(10, 10),
                      right: Radius.elliptical(10, 10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Editar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: 'edit',
                  mini: true,
                  onPressed: () async {
                    widget.onEdit();
                  },
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                child: Icon(
                  _controller.isDismissed ? Icons.more_vert : Icons.close,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
