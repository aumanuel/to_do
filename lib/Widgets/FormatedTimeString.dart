import 'package:simple_todo/globals.dart';

String formatedTimeString(int millisecondsSinceEpoch, String type) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String text = "";

  switch (type) {
    case "date":
      text =
      "${daysList[time.weekday]} ${padLeadingZeros(time.day.toString())} ${monthsList[time.month]}";
      break;
    case "achieved due date":
      text =
      "${padLeadingZeros(time.day.toString())}/${padLeadingZeros(time.month.toString())}";
      break;
    case "hour":
      text =
      "${padLeadingZeros(time.hour.toString())}h${padLeadingZeros(time.minute.toString())}";
      break;
  }

  return text;
}