import 'package:faxinapp/common/data/Secrets.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/qr_reader.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(color: AppColors.SECONDARY),
        title: Text(
          "Importar Faxina",
          style: TextStyle(
            color: AppColors.SECONDARY,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                      Icons.camera_alt,
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
                    },
                  ),
                  labelStyle: TextStyle(color: AppColors.SECONDARY),
                  counterStyle: TextStyle(color: AppColors.SECONDARY),
                  errorBorder: InputBorder.none),
              controller: _codeController,
              style: TextStyle(color: Colors.white),
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
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: _save,
                  color: AppColors.SECONDARY,
                  textColor: Colors.white,
                  child: Text("Importar", style: TextStyle(fontSize: 16)),
                )),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    String msg = "Importado faxina com sucesso!";

    if (_codeController.text != null && _codeController.text.isNotEmpty) {
      Secrets s = await Secrets.instance();

      var res = await http.get(
        '${s.server}/obtain/${_codeController.text}',
        headers: {
          'Content-Type': 'application/json',
          'api_key': s.apiKey,
        },
      );

      if (res.statusCode == 200) {
        var cleaning = Cleaning.fromMap(json.decode(res.body));

      } else if (res.statusCode == 404) {
        msg = "Faxina ${_codeController.text} não está compartilhada!";
      } else if (res.statusCode == 401) {
        msg = "Sem permissão!";
      } else if (res.statusCode == 500) {
        msg = "Ocorreu um erro ao importar faxina!";
      } else {
        msg = "Não foi possível importar a sua faxina";
      }
    } else {
      msg = "Código inválido!";
    }

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
