import 'package:flutter/material.dart';
import 'package:simple_todo/Widgets/FormatedTimeString.dart';
import 'package:simple_todo/database.dart';

Card dismissibleCards(Task task, String setting) {
  Widget _row = Container();
  Widget _expansionTile = Container();

  _row = Container(
      padding: EdgeInsets.only(
          left: task.content == "" ? 17 : 0,
          right: task.content == "" ? 57 : 0),
      height: task.content == "" ? 65 : 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Flexible(
            child: Text(task.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87)),
          ),
          // hour or due date
          (setting == "Deadline" &&
                      ((task.date +
                                  DateTime.fromMillisecondsSinceEpoch(task.date)
                                      .timeZoneOffset
                                      .inMilliseconds) %
                              86400000) !=
                          0) ||
                  (setting == "Done" && task.date != 0)
              ? Text(
                  formatedTimeString(task.date,
                      setting == "Deadline" ? "hour" : "achieved due date"),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey))
              : Container(),
        ],
      ));

  _expansionTile = ExpansionTile(
    title: _row,
    children: [
      Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child: Text(task.content,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)))
            ],
          ))
    ],
  );

  return Card(elevation: 5, child: task.content == "" ? _row : _expansionTile);
}
