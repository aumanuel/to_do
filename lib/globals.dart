/*
**  ================================[ GLOBALS ]=================================
*/

// DateTime weekday 1-7
List<String> daysList = [
  "",
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche",
];

// DateTime month 1-12
List<String> monthsList = [
  "",
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Août",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre",
];

String padLeadingZeros(String num) {
  while (num.length < 2){
    num = "0" + num;
  }
  return num;
}
