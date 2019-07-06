import 'dart:math' as math;
import 'package:connectivity/connectivity.dart';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    CleaningBloc bloc = BlocProvider.of(context);
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
                    if (widget.cleaning.type == CleaningType.SHARED) {
                      show('Faxina compartilhada não pode ser concluida!');
                      return false;
                    }
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
              curve: Interval(0.0, 0.6, curve: Curves.easeOut),
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
                    if (widget.cleaning.type == CleaningType.IMPORTED) {
                      show('Faxina importada não pode ser executada!');
                      return false;
                    }
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
        Container(
          height: 70.0,
          width: 150.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 0.4, curve: Curves.easeOut),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.elliptical(10, 10),
                      right: Radius.elliptical(10, 10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Compartilhar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: 'share',
                  mini: true,
                  onPressed: () async {
                    try {
                      if ( await Connectivity().checkConnectivity() == ConnectivityResult.none )  {
                        show( "Verifica sua conexão");
                        return false;
                      }

                      bloc.setLoading(true);
                      await SharedUtil.share(widget.cleaning);
                      bloc.setLoading(false);
                      await showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              contentPadding: EdgeInsets.all(20),
                              children: <Widget>[
                                Container(
                                  width: math.min(
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height),
                                  child: QrImage(
                                    foregroundColor: AppColors.PRIMARY,
                                    backgroundColor: Colors.white,
                                    data: '${widget.cleaning.uuid}',
                                  ),
                                ),
                                RaisedButton(
                                  color: AppColors.PRIMARY,
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: '${widget.cleaning.uuid}',
                                      ),
                                    );

                                    Navigator.pop(context);

                                    show('Código copiado!');
                                  },
                                  child: Text(
                                    "Copiar código",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                      );
                    } catch (ex) {
                      show(ex.toString());
                    }
                  },
                  child: Icon(
                    Icons.share,
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

  void show(String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
        ),
      ),
    );
  }
}
