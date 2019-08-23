import 'dart:async';
import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_product.dart';
import 'package:faxinapp/pages/cleaning/models/cleaning_task.dart';
import 'package:faxinapp/pages/cleaning/util/share_firebase.dart';
import 'package:faxinapp/pages/cleaning/util/shared_mongo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SharedUtil {
  static bool _firebase = false;

  static Future<String> share(Cleaning c) async {
    if (_firebase) {
      return await SharedFirebase.share(c);
    } else {
      return await SharedMongo.share(c);
    }
  }

  static Future<Cleaning> obtain(String uuid) async {
    if (_firebase) {
      return await SharedFirebase.obtain(uuid);
    } else {
      return await SharedMongo.obtain(uuid);
    }
  }

  static Future done(
    Cleaning cleaning,
    List<CleaningTask> tasks,
    List<CleaningProduct> products,
  ) async {
    if (_firebase) {
      return await SharedFirebase.done(cleaning, tasks, products);
    } else {
      return await SharedMongo.done(cleaning, tasks, products);
    }
  }

  static Future syncronized({
    GlobalKey<ScaffoldState> globalKey,
    BuildContext buildContext,
  }) async {
    if (_firebase) {
      return await SharedFirebase.syncronized(
          globalKey: globalKey, buildContext: buildContext);
    } else {
      return await SharedMongo.syncronized(
          globalKey: globalKey, buildContext: buildContext);
    }
  }

    static Future syncronizedJob() async {
    if (_firebase) {
      return await SharedFirebase.syncronizedJob();
    } else {
      return await SharedMongo.syncronizedJob();
    }
  }
}
