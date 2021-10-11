import 'package:flutter/material.dart';
import 'package:simple_todo/Pages/PageAddEdit.dart';
import 'package:simple_todo/Widgets/DismissibleBackgrounds.dart';
import 'package:simple_todo/Widgets/DismissibleCard.dart';
import 'package:simple_todo/Widgets/FormatedTimeString.dart';
import 'package:simple_todo/Widgets/TasksList.dart';
import 'package:simple_todo/database.dart';

class PageListing extends StatefulWidget {
  const PageListing({Key? key, this.setting = ""}) : super(key: key);
  final String setting;

  @override
  PageListingState createState() {
    return PageListingState();
  }
}

class PageListingState extends State<PageListing> {
  List<Widget> cardList = [];

  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    List<Task> sortedTasksList = await tasksList(widget.setting);
    cardList = await tasksListGenerator(sortedTasksList);
    setState(() {});
  }

  // generate the liste of dates and dismissibles
  tasksListGenerator(List<Task> sortedTasksList) async {
    List<Widget> _cardList = [];

    for (int i = 0, nbDates = 0, currentDay = 0;
        i < sortedTasksList.length;
        i++) {
      // add the due date
      if (widget.setting == "Deadline" || widget.setting == "Done") {
        int date = sortedTasksList[i].date;
        if (date == 0) date = sortedTasksList[i].achieved;

        if (currentDay + 86400000 <= date) {
          _cardList.add(Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
              child: Text(formatedTimeString(date, "date"),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey))));

          currentDay = date - date % 86400000;
          nbDates++;
        }
      }

      // add the dismissibles
      _cardList.add(Container(
          child: Dismissible(
        key: Key(sortedTasksList[i].id.toString()),
        child: dismissibleCards(sortedTasksList[i], widget.setting),
        background: dismissibleBackgrounds("primary", widget.setting),
        secondaryBackground:
            dismissibleBackgrounds("secondary", widget.setting),
        onDismissed: (DismissDirection direction) {
          setState(() => _cardList.removeAt(i + nbDates));

          // edit task
          if ((direction == DismissDirection.endToStart &&
                  (widget.setting == "Deadline" ||
                      widget.setting == "No deadline")) ||
              (direction == DismissDirection.startToEnd &&
                  widget.setting == "Done")) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageAddEdit(
                            id: sortedTasksList[i].id,
                            date: sortedTasksList[i].date,
                            achieved: sortedTasksList[i].achieved,
                            title: sortedTasksList[i].title,
                            content: sortedTasksList[i].content)))
                .then((value) => loadData());
          }

          // set a task to done by setting the achieved timer
          else if (direction == DismissDirection.startToEnd &&
              (widget.setting == "Deadline" ||
                  widget.setting == "No deadline")) {
            Task modifiedTask = Task(
              id: sortedTasksList[i].id,
              date: sortedTasksList[i].date,
              achieved: DateTime.now().millisecondsSinceEpoch,
              title: sortedTasksList[i].title,
              content: sortedTasksList[i].content,
            );
            insertTask(modifiedTask);
          }

          // undo a done task, by setting the achieved timer to 0
          else if (direction == DismissDirection.endToStart &&
              widget.setting == "Done") {
            Task modifiedTask = Task(
              id: sortedTasksList[i].id,
              date: sortedTasksList[i].date,
              achieved: 0,
              title: sortedTasksList[i].title,
              content: sortedTasksList[i].content,
            );
            insertTask(modifiedTask);
          }
        },
      )));
    }
    return _cardList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cardList,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => PageAddEdit()));
            loadData();
          },
          tooltip: 'Add a task',
          child: Icon(Icons.add),
        ));
  }
}
