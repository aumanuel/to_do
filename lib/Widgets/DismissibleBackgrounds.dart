import 'package:flutter/material.dart';

// side == primary when swipping from end to start
// side == secondary when swipping from start to end
Card dismissibleBackgrounds(String side, String setting) {
  Color bgColor = Colors.white;
  Icon bgIcon = Icon(Icons.clear);
  String bgText = "";

  // if side == "primary"
  Alignment bgAlignment = Alignment.centerLeft;
  MainAxisAlignment bgAxisAlignment = MainAxisAlignment.start;
  if (side == "secondary") {
    bgAlignment = Alignment.centerRight;
    bgAxisAlignment = MainAxisAlignment.end;
  }

  if ((setting == "Deadline" || setting == "No deadline") &&
      side == "primary") {
    bgColor = Colors.green;
    bgIcon = Icon(Icons.done, color: Colors.white);
    bgText = "Done";
  } else if (((setting == "Deadline" || setting == "No deadline") &&
          side == "secondary") ||
      (setting == "Done" && side == "primary")) {
    bgColor = Colors.blueAccent;
    bgIcon = Icon(Icons.edit, color: Colors.white);
    bgText = "Edit";
  } else if (setting == "Done" && side == "secondary") {
    bgColor = Colors.orangeAccent;
    bgIcon = Icon(Icons.remove_done, color: Colors.white);
    bgText = "Undone";
  }

  return Card(
      color: bgColor,
      child: Container(
          alignment: bgAlignment,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: bgAxisAlignment,
            children: [
              Text(bgText,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
              SizedBox(width: 10),
              bgIcon,
            ],
          ))

  );
}
