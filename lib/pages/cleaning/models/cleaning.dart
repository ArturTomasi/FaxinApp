import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';
import 'package:flutter/material.dart';

class Frequency {
  static final Frequency NONE = Frequency._(0, "Manual");
  static final Frequency DAY = Frequency._(1, "Diário");
  static final Frequency WEEKLY = Frequency._(2, "Semanal");
  static final Frequency BI_WEEKLY = Frequency._(3, "Quinzenal");
  static final Frequency MONTH = Frequency._(4, "Mensal");
  static final Frequency YEAR = Frequency._(5, "Anual");

  static List<Frequency> values() =>
      [NONE, DAY, WEEKLY, BI_WEEKLY, MONTH, YEAR];

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
  String label;

  Frequency._(this.index, this.label);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Frequency && runtimeType == other.runtimeType && index == other.index;

  @override
  int get hashCode => runtimeType.hashCode ^ index.hashCode;

  @override
  String toString() => label;
}

class Cleaning {
  int id;
  String name = "";
  String guidelines = "";
  Frequency frequency;
  DateTime nextDate = DateTime.now(), dueDate;
  TimeOfDay estimatedTime = new TimeOfDay(hour: 1, minute: 0);
  List<Product> products;
  List<Task> tasks;

  Cleaning();

  Cleaning.fromMap(Map<String, dynamic> map) {
    id = map[CleaningTable.ID];
    name = map[CleaningTable.NAME];
    guidelines = map[CleaningTable.GUIDELINES];
    frequency = Frequency.valueOf(map[CleaningTable.FREQUENCY]);

    String t = map[CleaningTable.ESTIMATED_TIME]
        .toString()
        .replaceAll(RegExp("[^0-9]"), "");

    estimatedTime = new TimeOfDay(
        hour: int.parse(t.substring(0, 2)),
        minute: int.parse(t.substring(2, 4)));
    nextDate = DateTime.parse(map[CleaningTable.NEXT_DATE]);
    dueDate = map[CleaningTable.DUE_DATE] != null
        ? DateTime.parse(map[CleaningTable.DUE_DATE])
        : null;
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
  static const GUIDELINES = "guidelines";
  static const FREQUENCY = "frequency";
  static const NEXT_DATE = "next_date";
  static const DUE_DATE = "due_date";
  static const ESTIMATED_TIME = "estimated_time";
}
