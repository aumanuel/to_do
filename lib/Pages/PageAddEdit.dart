import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/database.dart';

class PageAddEdit extends StatefulWidget {
  const PageAddEdit({
    Key? key,
    this.id = 0,
    this.date = 0,
    this.achieved = 0,
    this.title = '',
    this.content = '',
  }) : super(key: key);
  final int id;
  final int date;
  final int achieved;
  final String title;
  final String content;

  @override
  PageAddEditState createState() {
    return PageAddEditState();
  }
}

class PageAddEditState extends State<PageAddEdit> {
  late TextEditingController controllerDueDate = TextEditingController();
  late TextEditingController controllerDueHour = TextEditingController();
  late TextEditingController controllerDoneDate = TextEditingController();
  String pickedDueDate = "";
  String pickedDueHour = "";
  String pickedDoneDate = "";
  String taskTitle = "";
  String taskContent = "";

  @override
  void initState() {
    super.initState();

    // put initial values of edited task
    taskTitle = widget.title;
    taskContent = widget.content;
    // selected due day
    if (widget.date != 0) {
      final String _date =
          DateTime.fromMillisecondsSinceEpoch(widget.date).toString();
      pickedDueDate = _date.substring(0, 10);
      controllerDueDate = TextEditingController(text: pickedDueDate);
      // selected due hour
      if ((widget.date + DateTime.now().timeZoneOffset.inMilliseconds) %
              86400000 !=
          0) {
        pickedDueHour = _date.substring(11, 16);
        controllerDueHour = TextEditingController(text: pickedDueHour);
      }
    }
    // done day and hour
    if (widget.achieved != 0) {
      final String _date =
          DateTime.fromMillisecondsSinceEpoch(widget.achieved).toString();
      pickedDoneDate = _date.substring(0, 10);
      controllerDoneDate = TextEditingController(text: pickedDoneDate);
    }
  }

  datePicker(String type, String status, TextEditingController controller) {
    return Container(
      width: type == "Date" ? 150 : 100,
      child: DateTimePicker(
        type:
            type == "Date" ? DateTimePickerType.date : DateTimePickerType.time,
        icon: Icon(type == "Date" ? Icons.event : Icons.access_time),
        timeLabelText: type,
        controller: controller,
        onChanged: (val) => setState(() {
          if (type == "Date") {
            status == "Due" ? pickedDueDate = val : pickedDoneDate = val;
          } else if (type == "Hour") {
            pickedDueHour = val;
          }
        }),
        dateMask: 'd MMM, yyyy',
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 20),
      ),
    );
  }

  dateRow(String status) {
    if (status == "Done" && widget.achieved == 0) {
      return Container();
    } else
      return Column(children: [
        Row(
          children: [
            Text(status == "Due" ? "Deadline" : "Done date",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            datePicker("Date", status,
                status == "Due" ? controllerDueDate : controllerDoneDate),
            status == "Due"
                ? datePicker("Hour", status, controllerDueHour)
                : SizedBox(width: 1),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (status == "Due") {
                      pickedDueDate = "";
                      pickedDueHour = "";
                      controllerDueDate =
                          TextEditingController(text: pickedDueDate);
                      controllerDueHour =
                          TextEditingController(text: pickedDueHour);
                    } else if (status == "Done") {
                      pickedDoneDate = "";
                      controllerDoneDate =
                          TextEditingController(text: pickedDoneDate);
                    }
                  });
                },
                icon: Icon(Icons.delete, color: Colors.grey))
          ],
        )
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add a Task'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              dateRow("Due"),
              SizedBox(height: 20),
              dateRow("Done"),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 1,
                initialValue: taskTitle,
                onChanged: (String str) => taskTitle = str,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Task",
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: null,
                initialValue: taskContent,
                onChanged: (String str) => taskContent = str,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Useful information",
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.id != 0) deleteTask(widget.id);
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent, onPrimary: Colors.white),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        String _date = pickedDueHour != ""
                            ? pickedDueDate + " " + pickedDueHour
                            : pickedDueDate;

                        final newtask = Task(
                          id: widget.id != 0
                              ? widget.id
                              : DateTime.now().millisecondsSinceEpoch,
                          date: _date != ""
                              ? DateTime.parse(_date).millisecondsSinceEpoch
                              : 0,
                          achieved: pickedDoneDate != ""
                              ? DateTime.parse(pickedDoneDate)
                                  .millisecondsSinceEpoch
                              : 0,
                          title: taskTitle,
                          content: taskContent,
                        );
                        insertTask(newtask);
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green, onPrimary: Colors.white),
                    ),
                  ),
                ],
              )
            ])));
  }
}
