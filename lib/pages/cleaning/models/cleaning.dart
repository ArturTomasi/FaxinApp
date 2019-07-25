import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum CleaningType { IMPORTED, SHARED, COMMON }

class Frequency {
  static final Frequency NONE = Frequency._(0, "Manual", "#5B9279");
  static final Frequency DAY = Frequency._(1, "Diário", "#8FCB9B");
  static final Frequency WEEKLY = Frequency._(2, "Semanal", "#77bda9" );
  static final Frequency BI_WEEKLY = Frequency._(3, "Quinzenal", "#6DAC9A");
  static final Frequency MONTH = Frequency._(4, "Mensal", "#578A7B");
  static final Frequency YEAR = Frequency._(5, "Anual", "#9CCFC0");

  static List<Frequency> values() => [
        NONE,
        DAY,
        WEEKLY,
        BI_WEEKLY,
        MONTH,
        YEAR,
      ];

  static Frequency valueOf(int index) {
    switch (index) {
      case 1:
        return DAY;
      case 2:
        return WEEKLY;
      case 3:
        return BI_WEEKLY;
      case 4:
        return MONTH;
      case 5:
        return YEAR;
      default:
        return NONE;
    }
  }

  int index;
  String label, color;

  Frequency._(this.index, this.label, this.color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Frequency &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => runtimeType.hashCode ^ index.hashCode;

  @override
  String toString() => label;
}

class Cleaning {
  int id;
  String name = "";
  String uuid = Uuid().v4();
  String guidelines = "";
  Frequency frequency = Frequency.NONE;
  CleaningType type = CleaningType.COMMON;
  DateTime nextDate = DateTime.now(), dueDate;
  TimeOfDay estimatedTime = new TimeOfDay(hour: 1, minute: 0);
  List<Product> products = [];
  List<Task> tasks = [];

  Cleaning();

  Cleaning.fromMap(Map<dynamic, dynamic> map) {
    id = map[CleaningTable.ID];
    name = map[CleaningTable.NAME];
    uuid = map[CleaningTable.UUID];
    type = CleaningType.values.elementAt(
        map[CleaningTable.TYPE] != null ? map[CleaningTable.TYPE] : 2);
    guidelines = map[CleaningTable.GUIDELINES];
    frequency = Frequency.valueOf(map[CleaningTable.FREQUENCY]);

    String t = map[CleaningTable.ESTIMATED_TIME]
        .toString()
        .replaceAll(RegExp("[^0-9]"), "");

    estimatedTime = new TimeOfDay(
        hour: int.parse(t.substring(0, 2)),
        minute: int.parse(t.substring(2, 4)));

    nextDate = DateTime.parse(map[CleaningTable.NEXT_DATE]);
    dueDate = map[CleaningTable.DUE_DATE] != null &&
            map[CleaningTable.DUE_DATE].toString().isNotEmpty
        ? DateTime.parse(map[CleaningTable.DUE_DATE])
        : null;

    if (map.containsKey('products') && map['products'] != null) {
      products = [];
      map['products'].forEach((m) => products.add(Product.fromMap(m)));
    }

    if (map.containsKey('tasks') && map['tasks'] != null) {
      tasks = [];
      map['tasks'].forEach((m) => tasks.add(Task.fromMap(m)));
    }
  }

  DateTime futureDate() {
    int days = 0;
    if (frequency == Frequency.DAY) {
      days = 1;
    } else if (frequency == Frequency.WEEKLY) {
      days = 7;
    } else if (frequency == Frequency.BI_WEEKLY) {
      days = 15;
    } else if (frequency == Frequency.MONTH) {
      days = 30;
    } else if (frequency == Frequency.YEAR) {
      days = 365;
    }

    return DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day + days,
      nextDate.hour,
      nextDate.minute,
      nextDate.second,
      nextDate.millisecond,
      nextDate.microsecond,
    );
  }

  Map<String, dynamic> toJson() {
    List pJson = [];
    List tJson = [];

    products.forEach((p) {
      var map = {
        ProductTable.ID: p.id,
        ProductTable.NAME: p.name,
        ProductTable.UUID: p.uuid,
        ProductTable.STATE: p.state,
        ProductTable.CAPACITY: p.capacity,
        ProductTable.CURRENT_CAPACITY: p.currentCapacity,
        ProductTable.BRANDING: p.branding
      };
      pJson.add(map);
    });

    tasks.forEach((t) {
      var map = {
        TaskTable.ID: t.id,
        TaskTable.UUID: t.uuid,
        TaskTable.NAME: t.name,
        TaskTable.STATE: t.state,
        TaskTable.GUIDELINES: t.guidelines
      };
      tJson.add(map);
    });

    return {
      CleaningTable.ID: id,
      CleaningTable.NAME: name,
      CleaningTable.UUID: uuid,
      CleaningTable.TYPE: type.index,
      CleaningTable.GUIDELINES: guidelines,
      CleaningTable.FREQUENCY: frequency.index,
      CleaningTable.NEXT_DATE: nextDate.toIso8601String(),
      CleaningTable.DUE_DATE:
          (dueDate != null ? dueDate.toIso8601String() : null),
      CleaningTable.ESTIMATED_TIME: estimatedTime.toString(),
      "products": pJson,
      "tasks": tJson
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cleaning && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => name;
}

class CleaningTable {
  static const table = "cleanings";
  static const ID = "id";
  static const NAME = "name";
  static const UUID = "uuid";
  static const GUIDELINES = "guidelines";
  static const FREQUENCY = "frequency";
  static const NEXT_DATE = "next_date";
  static const DUE_DATE = "due_date";
  static const ESTIMATED_TIME = "estimated_time";
  static const TYPE = "type";
}
