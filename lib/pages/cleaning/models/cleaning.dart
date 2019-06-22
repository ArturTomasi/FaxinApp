import 'package:faxinapp/pages/products/models/product.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

class Frequency {
  static final Frequency NONE = Frequency._(0, "Manual");
  static final Frequency DAY = Frequency._(1, "Diário");
  static final Frequency WEEKLY = Frequency._(2, "Semanal");
  static final Frequency BI_WEEKLY = Frequency._(3, "Quinzenal");
  static final Frequency MONTH = Frequency._(4, "Mensal");
  static final Frequency YEAR = Frequency._(5, "Anual");
  
  static List<Frequency> values() => [ NONE, DAY, WEEKLY, BI_WEEKLY, MONTH, YEAR ];

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

  int index; String label;

  Frequency._(this.index, this.label);
  
  @override
  String toString() => label;
}

class Cleaning {
  int id;
  String name;
  String guidelines;
  Frequency frequency;
  DateTime nextDate, startDate, endDate, estimatedTime;
  List<Product> products;
  List<Task> tasks;

  Cleaning();

  Cleaning.fromMap(Map<String, dynamic> map) {
    id = map[CleaningTable.ID];
    name = map[CleaningTable.NAME];
    guidelines = map[CleaningTable.GUIDELINES];
    frequency = Frequency.valueOf(map[CleaningTable.FREQUENCY]);
    nextDate = map[CleaningTable.NEXT_DATE];
    endDate = map[CleaningTable.END_DATE];
    startDate = map[CleaningTable.START_DATE];
    estimatedTime = map[CleaningTable.ESTIMATED_TIME];
  }
}

class CleaningTable {
  static const table = "cleanings";
  static const ID = "id";
  static const NAME = "name";
  static const GUIDELINES = "guidelines";
  static const FREQUENCY = "frequency";
  static const NEXT_DATE = "next_date";
  static const START_DATE = "start_date";
  static const END_DATE = "end_date";
  static const ESTIMATED_TIME = "estimated_time";
}

class CleaningTaskTable {
  static const table = "cleaning_tasks";
  static const REF_TASK = "ref_task";
  static const REF_CLEANING = "ref_cleaning";
  static const REALIZED = "realized";
}

class CleaningProductTable {
  static const table = "cleaning_products";
  static const REF_PRODUCT = "ref_product";
  static const REF_CLEANING = "ref_cleaning";
  static const AMOUNT = "amount";
  static const REALIZED = "realized";
}
