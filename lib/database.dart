import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  final int id;
  final int date;
  final int achieved;
  final String title;
  final String content;

  Task({
    this.id = 0,
    this.date = 0,
    this.achieved = 0,
    this.title = '',
    this.content = '',
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "achieved": achieved,
      "title": title,
      "content": content,
    };
  }

  @override
  String toString() {
    return "User{id: $id, date: $date, achieved: $achieved, title: $title, content: $content}";
  }
}

Future<Database> database() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), "tasks_database.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, date INTEGER, achieved INTEGER, title TEXT, content TEXT)");
    },
    version: 1,
  );
  return database;
}

Future<void> insertTask(Task task) async {
  final db = await database();
  await db.insert(
    "tasks",
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> deleteTask(int id) async {
  final db = await database();

  await db.delete(
    'tasks',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<List<Task>> getTasks() async {
  final db = await database();
  final List<Map<String, dynamic>> tasks = await db.query("tasks");

  return List.generate(tasks.length, (i) {
    return Task(
      id: tasks[i]["id"],
      date: tasks[i]["date"],
      achieved: tasks[i]["achieved"],
      title: tasks[i]["title"],
      content: tasks[i]["content"],
    );
  });
}
