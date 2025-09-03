import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'custom_text.dart';
import 'colors.dart';
import 'package:intl/intl.dart';

//* function de select ...
DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: CustomText(
      item,
      tex: 0.85,
      color: orange(),
      textAlign: TextAlign.center,
    ));

//* function de disfranchisement dune page  ....

// Future refrech(Widget x, BuildContext context) async {
//   await Future.delayed(const Duration(milliseconds: 200));
//   Navigator.of(context).push(
//     SlideRightRoute(child: x, page: x, direction: AxisDirection.left),
//   );
// }

//* function de disfranchisement de la connexion ....

refrechPopConnectivity(Widget x, BuildContext context) async {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: ((context) => x),
    ),
  );
}

//*  Page de loading  ....

Widget loadingContainer(BuildContext context) {
  return Container(
    width: 100 ,
    height: 60 ,
    color: noir().withValues(alpha: 0.5),
    child: const Center(
      child: SpinKitFadingCircle(
        color: Colors.white,
        size: 50.0,
      ),
    ),
  );
}

bool neCommencePasParPonctuation(String texte) {
  const List<String> ponctuations = ['.', ',', '!', '?', '…'];

  if (texte.isEmpty) return true;

  return !ponctuations.contains(texte[0]);
}



void loadPop(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          margin: EdgeInsets.only(left: 20 , right: 20),
          decoration: BoxDecoration(
            color: noir(),
            borderRadius: BorderRadius.circular(13), // Rounded corners
          ),
            width: 100,
            height: 80,
            child: SpinKitFadingCircle(
              color: orange(),
              size: 30.0,
          ),
        ),
      );
    },
  );
}







Widget lineContain() {
  return Expanded(
    child: Container(
      height: 2,
      color: blanc(),
    ),
  );
}

// fermer le clavier
void closeKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String formatMonthDay(DateTime date) {
  // Converts DateTime to a "Month Day" format (e.g., Jan 1)
  return '${monthName(date.month)} ${date.day}';
}

DateTime parseDate(String dateString) {
  return DateFormat('yyyy-MM-dd').parse(dateString);
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String newFormat(DateTime date) {
  return DateFormat.yMMM().format(date);
}

String formatDayMonthYear(DateTime date) {
  // Converts DateTime to a "Month Day" format (e.g., Jan 1)
  return '${date.day} ${monthName(date.month)} ${date.year}';
}

String formatMonthYear(DateTime date) {
  // Converts DateTime to a "Month Day" format (e.g., Jan 1)
  return '${monthName(date.month)} ${date.year}';
}

String monthName(int month) {
  // Returns the month name based on its number
  const List<String> months = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre ',
    'Novembre',
    'Decembre'
  ];
  return months[month - 1];
}


