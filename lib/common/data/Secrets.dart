import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secrets {
  static Secrets _instance;
  String firebase;
  String key;
  String email;
  String password;
  String token;

  static Future<Secrets> instance() async {
    if (_instance == null) {
      _instance = await rootBundle
          .loadStructuredData<Secrets>('secrets.json', (jsonStr) async{
        return Secrets.fromJson(json.decode(jsonStr));
      });
    }

    return _instance;
  }

  Secrets({this.firebase, this.key, this.email, this.password});

  factory Secrets.fromJson(Map<String, dynamic> jsonMap) {
    return new Secrets(
      key: jsonMap["key"],
      firebase: jsonMap["firebase"],
      email: jsonMap["email"],
      password: jsonMap["password"],
    );
  }
}
