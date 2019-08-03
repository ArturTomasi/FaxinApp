import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secrets {
  static Secrets _instance;

  String firebase, key, logo, email, password, token;

  static Future<Secrets> instance() async {
    if (_instance == null) {
      _instance = await rootBundle.loadStructuredData<Secrets>('secrets.json',
          (jsonStr) async {
        return Secrets.fromJson(json.decode(jsonStr));
      });
    }

    return _instance;
  }

  Secrets({
    this.firebase,
    this.key,
    this.email,
    this.password,
    this.logo,
  });

  factory Secrets.fromJson(Map<String, dynamic> jsonMap) {
    return new Secrets(
      key: jsonMap["key"],
      firebase: jsonMap["firebase"],
      logo: jsonMap["logo"],
      email: jsonMap["email"],
      password: jsonMap["password"],
    );
  }
}
