/*
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:faxinapp/bloc/bloc_provider.dart';
import 'package:faxinapp/common/data/Secrets.dart';
import 'package:faxinapp/pages/cleaning/bloc/cleaning_bloc.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_repository.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:faxinapp/util/AppColors.dart';
import 'package:faxinapp/util/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SharedFirebase {
  static Future<String> share(Cleaning c) async {
    Secrets secrets = await Secrets.instance();

    var app = await FirebaseApp.appNamed(FirebaseApp.defaultAppName);

    var db = FirebaseDatabase(
      app: app,
      databaseURL: '${secrets.firebase}',
    );

    await db.reference().child('shared/${c.uuid}').update(c.toJson());

    c.type = CleaningType.SHARED;

    CleaningRepository.get().save(c);

    return c.uuid;
  }

  static Future<Cleaning> obtain(String uuid) async {
    Secrets secrets = await Secrets.instance();

    var app = await FirebaseApp.appNamed(FirebaseApp.defaultAppName);

    var db = FirebaseDatabase(
      app: app,
      databaseURL: '${secrets.firebase}',
    );

    var snapshot = await db.reference().child('shared/$uuid').once();

    if (snapshot.value != null) {
      return Cleaning.fromMap(snapshot.value)..type = CleaningType.IMPORTED;
    }

    return null;
  }

  static Future done(
    Cleaning cleaning,
    List<CleaningTask> tasks,
    List<CleaningProduct> products,
  ) async {
    Secrets secrets = await Secrets.instance();

    var app = await FirebaseApp.appNamed(FirebaseApp.defaultAppName);

    var db = FirebaseDatabase(
      app: app,
      databaseURL: '${secrets.firebase}',
    );

    await db.reference().child('done/${cleaning.uuid}').update({
      "uuid": cleaning.uuid,
      "due_date": cleaning.dueDate.toIso8601String(),
      "products": products.map((p) => p.toJson()).toList(),
      "tasks": tasks.map((t) => t.toJson()).toList()
    });
  }

  static Future syncronized({
    GlobalKey<ScaffoldState> globalKey,
    BuildContext buildContext,
  }) async {
    ScaffoldState state;
    BuildContext context;

    if (buildContext == null && globalKey != null) {
      context = globalKey.currentContext;
      state = globalKey.currentState;
    } else if (state == null && context != null) {
      state =
          buildContext.ancestorStateOfType(const TypeMatcher<ScaffoldState>());
      context = buildContext;
    } else {
      NullThrownError();
    }

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      state.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.SECONDARY,
          content: Text(
            "Verifique sua conexão",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else {
      CleaningBloc _bloc = BlocProvider.of<CleaningBloc>(context);

      if (globalKey != null) {
        _bloc.setLoading('Conectando ao servidor');
      }

      String msg = "Sincronizado com sucesso";

      try {
        Secrets secrets = await Secrets.instance();

        var app = await FirebaseApp.appNamed(FirebaseApp.defaultAppName);

        var db = FirebaseDatabase(
          app: app,
          databaseURL: '${secrets.firebase}',
        );

        _bloc.setLoading('Buscando suas faxinas compartilhadas');

        List<Cleaning> cleanings = await CleaningRepository.get().findShared();

        for (Cleaning c in cleanings) {
          _bloc.setLoading('Sincronizando ${c.name}');
          var snapshot = await db.reference().child('done/${c.uuid}').once();

          if (snapshot.value != null) {
            _bloc.setLoading('Convertendo faxina ${c.name}');
            List<CleaningProduct> products = [];
            List<CleaningTask> tasks = [];

            c.dueDate = DateTime.parse(snapshot.value['due_date']);

            for (Task t in c.tasks) {
              var result = snapshot.value['tasks']
                  .firstWhere((map) => map['uuid'] == t.uuid);

              if (result != null) {
                tasks.add(
                  new CleaningTask(
                    cleaning: c,
                    task: t,
                    realized: result['realized'],
                  ),
                );
              }
            }

            for (Product p in c.products) {
              var result = snapshot.value['products']
                  .firstWhere((map) => map['uuid'] == p.uuid);

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
            }

            Cleaning cn =
                await CleaningRepository.get().done(c, tasks, products);
            _bloc.update(c, cn);

            new PushNotification(context)
              ..cancel(c)
              ..schedule(cn);

            await db.reference().child('done/${c.uuid}').remove();
            await db.reference().child('shared/${c.uuid}').remove();
          }
        }
      } catch (e) {
        msg = "Ocorreu um erro ao importar faxina";
      }

      if (globalKey != null) {
        _bloc.setLoading(null);
      }

      state.showSnackBar(
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

  static Future syncronizedJob() async {
    if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
      Secrets secrets = await Secrets.instance();

      var app = await FirebaseApp.appNamed(FirebaseApp.defaultAppName);

      var db = FirebaseDatabase(
        app: app,
        databaseURL: '${secrets.firebase}',
      );

      List<Cleaning> cleanings = await CleaningRepository.get().findShared();

      for (Cleaning c in cleanings) {
        var snapshot = await db.reference().child('done/${c.uuid}').once();

        if (snapshot.value != null) {
          List<CleaningProduct> products = [];
          List<CleaningTask> tasks = [];

          c.dueDate = DateTime.parse(snapshot.value['due_date']);

          for (Task t in c.tasks) {
            var result = snapshot.value['tasks']
                .firstWhere((map) => map['uuid'] == t.uuid);

            if (result != null) {
              tasks.add(
                new CleaningTask(
                  cleaning: c,
                  task: t,
                  realized: result['realized'],
                ),
              );
            }
          }

          for (Product p in c.products) {
            var result = snapshot.value['products']
                .firstWhere((map) => map['uuid'] == p.uuid);

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
          }

          Cleaning cn = await CleaningRepository.get().done(c, tasks, products);

          new PushNotification(null)
            ..cancel(c)
            ..schedule(cn);

          await db.reference().child('done/${c.uuid}').remove();
          await db.reference().child('shared/${c.uuid}').remove();
        }
      }
    }
  }
}
*/