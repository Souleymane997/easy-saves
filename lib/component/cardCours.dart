// ignore_for_file: file_names

import 'dart:async';
import 'package:easy_saves/models/cours_model.dart';
import 'package:easy_saves/models/seance.dart';
import 'package:easy_saves/view/recette/switch.dart';
import 'package:flutter/material.dart';

import '../shared/colors.dart';
import '../shared/custom_text.dart';
import '../shared/slidepage.dart';
import '../view/home/add_seance.dart';
import '../view/home/details.dart';
import '../../shared/function.dart';

class CardCours extends StatelessWidget {
  const CardCours({super.key , required this.item , required this.nbre , required this.idCours});
  final CoursModel item ;
  final int nbre ;
  final String idCours ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showAddSeance(context , idCours );
      },
      onTap: () {
        Timer(const Duration(milliseconds: 1), () {
          Navigator.of(context).push(
            SlideRightRoute(
                child: DetailsCoursPage( idCours: idCours ,cours: item),
                page: DetailsCoursPage( idCours: idCours ,cours: item),
                direction: AxisDirection.up),
          );
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: orange())),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.only(right: 2, top: 2),
                  decoration: BoxDecoration(
                    color: orange(),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                      child: CustomText(
                    "$nbre",
                        color: noir(),
                    tex: TailleText(context).contenu * 1.2,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ],
            ),
            Container(
              width: 100,
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/logo.png'),
                    fit: BoxFit.contain,
                  )),
            ),
            CustomText(
              item.titre.toUpperCase(),
              color: blanc(),
              tex: TailleText(context).soustitre,
            ),
            CustomText(
              " Seance : ${item.prix} F/H ",
              // ignore: deprecated_member_use
              color: blanc().withOpacity(0.5),
              tex: TailleText(context).contenu,
            ),
          ],
        ),
      ),
    );
  }
}

class CoursDetailsCard extends StatelessWidget {
  const CoursDetailsCard({super.key, required this.cours , required this.seance , required this.idSeance , required this.idCours});
  final CoursModel cours ;
  final SeanceModel seance ;
  final String idSeance ;
  final String idCours ;

  @override
  Widget build(BuildContext context) {
    DateTime date =  parseDate(seance.date) ;

    return GestureDetector(
      onTap: () {
        setSeance(context, seance,idSeance,cours,idCours) ;
      },

      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        margin: const EdgeInsets.all(10),
        height: 62,
        decoration: (BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: orange()),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  noir(),
                  orange(),
                ]))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/logo.png'),
                    fit: BoxFit.contain,
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.07,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  "Seance du ${formatDayMonthYear(date)} ",
                  tex: TailleText(context).soustitre * 1.2,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w400,
                  color: orangeLight(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CustomText(
                        " Duree : ${seance.duree}H",
                        tex: TailleText(context).mini * 1.5,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        color: orangeLight(),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CustomText(
                        " Cout : ${seance.duree * cours.prix } F",
                        tex: TailleText(context).mini * 1.5,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        color: orangeLight(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class CardCoursRecette extends StatelessWidget {
  const CardCoursRecette({super.key , required this.item , required this.nbre , required this.idCours , required this.cout , required this.date});
  final CoursModel item ;
  final int nbre ;
  final String idCours ;
  final int cout ;
  final DateTime date ;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onLongPress: () {
        setCours( context ,item, idCours, date) ;
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: orange())),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.only(right: 2, top: 2),
                  decoration: BoxDecoration(
                    color: orange(),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                      child: CustomText(
                        "$nbre",
                        color: noir(),
                        tex: TailleText(context).contenu * 1.2,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
            CustomText(
              "${item.titre.toUpperCase()}",
              color: blanc(),
              tex: TailleText(context).soustitre,
            ),
            Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/icon/logo.png'),
                    fit: BoxFit.contain,
                  )),
            ),

            CustomText(
              "prix : ${item.prix} F/H ",
              color: blanc(),
              tex: TailleText(context).contenu,
            ),
            CustomText(
              "heure Totale : ${(cout/item.prix).toInt()} H ",
              color: blanc(),
              tex: TailleText(context).contenu,
            ),
            CustomText(
              "Total: $cout F",
              color: orange(),
              fontWeight: FontWeight.w500,
              tex: TailleText(context).soustitre * 0.85,
            ),
          ],
        ),
      ),
    );
  }
}



