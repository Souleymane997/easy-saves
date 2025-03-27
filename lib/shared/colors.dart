// ignore_for_file: deprecated_member_use

import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

Color orange() {
  return HexColor("#FFB267");
}

Color orangeFonce() {
  return HexColor("#FFFF7643");
}

Color orangeLight() {
  return HexColor("#FFF7E9");
}

Color marroon() {
  return HexColor("#FF3E2723");
}

Color noir() {
  return HexColor("#211D1D");
}

Color blanc() {
  return HexColor("#FFFFFF");
}

Color grisLight() {
  return HexColor("#E3E8ED");
}

Color gris() {
  return HexColor("#777777");
}

Color grisFonce() {
  return HexColor("#161C22");
}

Decoration backGround = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
        begin: Alignment.bottomRight,
        stops: const [0.1, 0.9],
        colors: [noir(), noir()]));

Decoration backGroundBody = BoxDecoration(
    borderRadius: BorderRadius.circular(0),
    gradient: LinearGradient(
        begin: Alignment.bottomRight,
        stops: const [0.00, 0.3],
        colors: [orange().withOpacity(0.1), noir()]));




double radiusButton = 15 ;