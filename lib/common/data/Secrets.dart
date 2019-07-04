import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class Secrets {
  static Secrets _instance;
  final String apiKey;
  final String server;

  static Future<Secrets> instance() async {
    if (_instance == null) {
      _instance = await rootBundle
          .loadStructuredData<Secrets>('secrets.json', (jsonStr) async {
        return Secrets.fromJson(json.decode(jsonStr));
      });
    }

    return _instance;
  }

  Secrets({this.apiKey, this.server});

  factory Secrets.fromJson(Map<String, dynamic> jsonMap) {
    return new Secrets(
      apiKey: jsonMap["api_key"],
      server: jsonMap["server"],
    );
  }
}
