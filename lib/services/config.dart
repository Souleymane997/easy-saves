// ignore_for_file: constant_identifier_names

// import 'package:shared_preferences/shared_preferences.dart';

// late SharedPreferences lienData;
// late String newLien;

// Future<String> checkLogged() async {
//   lienData = await SharedPreferences.getInstance();
//   newLien = (lienData.getString('lien') ?? "ddddd");
//   return newLien;
// }

// String lien = checkLogged() as String;

class Config {
  static String apiURL1 = "http://18.215.182.123/api/process/mobile";

  //* autres server
  static String apiURL = "http://196.28.242.238/api/process/mobile";

  // *************************************************************************************************** *//

  //* Gestion de Compte

  static const String PostLogin = "/login"; // se connecter

  static const String PostRegister =
      'http://196.28.242.242/api/process/mobile/register'; // s'inscrire

  static const String GetCompte = "/compte?"; //  + key  ; user connecté

  static const String GetEditCompte = "/edit_compte"; //  modifier compte

  static const String PostNewPassWord = "/newpass"; //  changer mot de passe

  static const String PostLogout = "/logout"; //  changer mot de passe

// *************************************************************************************************** *//
}
