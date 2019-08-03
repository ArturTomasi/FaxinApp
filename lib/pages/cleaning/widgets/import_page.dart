import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/util/share_util.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_reader/qr_reader.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _codeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Importar Faxina",
        ),
      ),
      body: StreamBuilder<String>(
        initialData: null,
        stream: _bloc.loading,
        builder: (_, snap) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              color: AppColors.PRIMARY_LIGHT,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Código",
                        icon: GestureDetector(
                          child: Icon(
                            MdiIcons.qrcodeScan,
                            size: 40,
                            color: AppColors.SECONDARY,
                          ),
                          onTap: () async {
                            _codeController.text = await QRCodeReader()
                                .setAutoFocusIntervalInMs(200) // default 5000
                                .setForceAutoFocus(true) // default false
                                .setTorchEnabled(true) // default false
                                .setHandlePermissions(true) // default true
                                .setExecuteAfterPermissionGranted(
                                    true) // default true
                                .scan();

                            _save();
                          },
                        ),
                        labelStyle: TextStyle(color: AppColors.SECONDARY),
                        counterStyle: TextStyle(color: AppColors.SECONDARY),
                        errorBorder: InputBorder.none),
                    controller: _codeController,
                    validator: (value) {
                      return value.isEmpty ? "Requerido *" : null;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      onPressed: _save,
                      color: AppColors.SECONDARY,
                      textColor: Colors.white,
                      child: Text(
                        "Importar",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            !snap.hasData || snap.data == null
                ? Container()
                : Container(
                    color: AppColors.PRIMARY_LIGHT.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text(
                            snap.data,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.SECONDARY,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    String msg = "Código inválido!";

    if (_codeController.text != null && _codeController.text.isNotEmpty) {
      CleaningBloc _bloc = BlocProvider.of(context);
      _bloc.setLoading("Conectando ao servidor");
      Cleaning c = await SharedUtil.obtain(_codeController.text);
      if (c != null) {
        _bloc.setLoading("Validando sua faxina");
        var _current = await CleaningRepository.get().find(c.id);

        if (_current != null && _current.type.index == CleaningType.SHARED.index) {
          msg = "Você não pode importar sua própria faxina!";
        } else {
          _bloc.setLoading("Importando faxina");
          await CleaningRepository.get().import(c);

          _bloc.setLoading("Agendando faxina");
          PushNotification(context)..schedule(c);

          _bloc.setLoading("Atualizando...");
          BlocProvider.of<CleaningBloc>(context).findPendents();

          msg = "Importado faxina com sucesso!";

          Navigator.of(context).pop();
        }
      }

      _bloc.setLoading(null);
    }

    _codeController.text = '';

    _globalKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.SECONDARY,
        content: Text(
          msg,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
