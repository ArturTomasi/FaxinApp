/*
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Cleaning
{
    String title, info;
    int id, date, time, status;
    List<String> labelList = List();

    Task.create(
      {@required this.title
      this.comment = "",
      this.dueDate = -1,
      this.priority = Status.PRIORITY_4}) {
    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
    this.tasksStatus = TaskStatus.PENDING;
  }
}

class Table
{
    static final name       = "cleanings";
    static final dbId       = "id";
    static final dbTitle    = "title";
    static final dbInfo     = "info";
    static final dbDate     = "dt_programed";
    static final dbTime     = "dt_time";
    static final dbStatus   = "status";
}

class Tasks {



 

  bool operator ==(o) => o is Tasks && o.id == id;

  Tasks.update(
      {@required this.id,
      @required this.title,
      @required this.projectId,
      this.comment = "",
      this.dueDate =-1,
      this.priority = Status.PRIORITY_4,
      this.tasksStatus = TaskStatus.PENDING}) {
    if (this.dueDate == -1) {
      this.dueDate = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Tasks.fromMap(Map<String, dynamic> map)
      : this.update(
          id: map[dbId],
          title: map[dbTitle],
          projectId: map[dbProjectID],
          comment: map[dbComment],
          dueDate: map[dbDueDate],
          priority: Status.values[map[dbPriority]],
          tasksStatus: TaskStatus.values[map[dbStatus]],
        );
}

enum TaskStatus {
  PENDING,
  COMPLETE,
}
*/