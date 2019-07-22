import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/data/Secrets.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SharedUtil {
  static StreamSubscription listener;

  static Future connectFirebase() async {
    try {
      Connectivity conn = Connectivity();

      if (await conn.checkConnectivity() == ConnectivityResult.none) {
        listener = conn.onConnectivityChanged.listen((x) {
          if (x != ConnectivityResult.none) {
            listener.cancel();

            connectFirebase();
          }
        });
        return;
      }

      Secrets s = await Secrets.instance();

      var res = await http.post(
          "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${s.key}",
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              "email": s.email,
              "password": s.password,
              "returnSecureToken": true,
            },
          ),
          encoding: Encoding.getByName('utf-8'));

      final Map<String, dynamic> data = json.decode(res.body);

      if (data.containsKey('idToken')) {
        s.token = data['idToken'];

        Timer(Duration(seconds: int.parse(data['expiresIn'])), connectFirebase);
      }
    } catch (ex) {
      print(ex);
    }
  }

  static Future<String> share(Cleaning c) async {
    Secrets secrets = await Secrets.instance();

    await http.patch(
      '${secrets.firebase}/shared/${c.uuid}.json?auth=${secrets.token}',
      headers: {'Content-Type': 'application/json'},
      body: json.encode(c),
      encoding: Encoding.getByName('utf-8'),
    );

    c.type = CleaningType.SHARED;

    CleaningRepository.get().save(c);

    return c.uuid;
  }

  static Future<Cleaning> obtain(String uuid) async {
    Secrets secrets = await Secrets.instance();

    var res = await http.get(
      '${secrets.firebase}/shared/$uuid.json?auth=${secrets.token}',
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (res.statusCode == 200) {
        if (res.body != null && res.body.isNotEmpty && res.body != 'null') {
          Cleaning c = Cleaning.fromMap(json.decode(res.body));
          c.type = CleaningType.IMPORTED;

          return c;
        }
      }
    } catch (e) {}
    
    return null;
  }

  static Future done(
    Cleaning cleaning,
    List<CleaningTask> tasks,
    List<CleaningProduct> products,
  ) async {
    Secrets secrets = await Secrets.instance();

    var js = {
      "uuid": cleaning.uuid,
      "due_date": cleaning.dueDate.toIso8601String(),
      "products:": products.map((p) => p.toJson()).toList(),
      "tasks:": tasks.map((t) => t.toJson()).toList()
    };

    await http.patch(
      '${secrets.firebase}/done/${cleaning.uuid}.json?auth=${secrets.token}',
      headers: {'Content-Type': 'application/json'},
      body: json.encode(js),
      encoding: Encoding.getByName('utf-8'),
    );
  }

  static Future syncronized(BuildContext context, {bool show = true}) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Verifique sua conexão",
          ),
        ),
      );
      return false;
    }

    CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);

    if (show) {
      _bloc.setLoading(true);
    }

    Secrets secrets = await Secrets.instance();

    List<Cleaning> cleanings = await CleaningRepository.get().findShared();

    cleanings.forEach((c) async {
      var res = await http.get(
        '${secrets.firebase}/done/${c.uuid}.json?auth=${secrets.token}',
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        if (res.body != null && res.body.isNotEmpty) {
          var map = json.decode(res.body);

          if (map != null) {
            List<CleaningProduct> products = [];
            List<CleaningTask> tasks = [];

            c.dueDate = DateTime.parse(map['due_date']);

            c.tasks.forEach((t) {
              var result =
                  map['tasks'].firstWhere((map) => map['uuid'] == t.uuid);

              if (result != null) {
                tasks.add(
                  new CleaningTask(
                    cleaning: c,
                    task: t,
                    realized: result['realized'],
                  ),
                );
              }
            });

            c.products.forEach((p) {
              var result =
                  map['products'].firstWhere((map) => map['uuid'] == p.uuid);

              if (result != null) {
                products.add(
                  new CleaningProduct(
                    cleaning: c,
                    product: p,
                    amount: result['amount'],
                    realized: result['realized'],
                  ),
                );
              }
            });

            Cleaning cn =
                await CleaningRepository.get().done(c, tasks, products);
            _bloc.update(c, cn);

            await new PushNotification(context).cancel(c);

            http.delete(
              '${secrets.firebase}/done/${c.uuid}.json?auth=${secrets.token}',
              headers: {'Content-Type': 'application/json'},
            );

            http.delete(
              '${secrets.firebase}/shared/${c.uuid}.json?auth=${secrets.token}',
              headers: {'Content-Type': 'application/json'},
            );
          }
        }
      }
    });

    if (show) {
      _bloc.setLoading(false);
    }

    return true;
  }
}
