import 'package:simple_todo/database.dart';

Future tasksList(String setting) async {
  List<Task> tasksList = await getTasks();

  // remove from the list the tasks who dont belongs to the set category
  if (setting == "Deadline")
    tasksList
        .removeWhere((element) => element.date == 0 || element.achieved != 0);
  else if (setting == "No deadline")
    tasksList
        .removeWhere((element) => element.date != 0 || element.achieved != 0);
  else if (setting == "Done")
    tasksList.removeWhere((element) => element.achieved == 0);

  // sort by due date if deadline and by achieved date is done
  if (setting == "Deadline") {
    tasksList.sort((a, b) => a.date.compareTo(b.date));
  } else if (setting == "Done") {
    tasksList.sort((a, b) => a.achieved.compareTo(b.achieved));
  }

  return tasksList;
}
