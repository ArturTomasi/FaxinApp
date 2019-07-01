import 'package:faxinapp/pages/cleaning/models/cleaning.dart';
import 'package:faxinapp/pages/tasks/models/task.dart';

class CleaningTask {
  Task task;
  Cleaning cleaning;
  int realized = 0;

  CleaningTask( {this.cleaning, this.task, this.realized} );
}

class CleaningTaskTable {
  static const table = "cleaning_tasks";
  static const REF_TASK = "ref_task";
  static const REF_CLEANING = "ref_cleaning";
  static const REALIZED = "realized";
}
