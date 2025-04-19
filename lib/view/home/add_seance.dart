
import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/seance_controller.dart';
import '../../models/seance.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/function.dart';
import '../../shared/slidepage.dart';
import '../navigationbody.dart';




void showAddSeance(BuildContext context , String idCours ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      DateTime date = DateTime.now();
      //String dateData = formatDayMonthYear(date) ;
      String formattedDate = formatDate(date);
      int duree = 2 ;
      return AlertDialog(
        title: CustomText(
          'Durée de la séance',
          tex: TailleText(context).titre,
          color: noir(),
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        backgroundColor: orange(),
        content: StatefulBuilder(
  builder: (context, setState) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (duree > 0) {
                      duree --;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.remove_circle_outline_outlined,
                    size: 30,
                    color: noir(),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: noir().withValues(alpha: 0.5),
                    borderRadius:
                    BorderRadius.circular(13), // Rounded corners
                  ),
                  child: Center(
                      child: CustomText(
                        duree.toString(),
                        color: blanc(),
                        tex: TailleText(context).soustitre,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                      duree ++;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.control_point,
                    size: 30,
                    color: noir(),
                  ),
                ),
              ))
        ],
      ),
    ) ;
  }
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context) ;
                  },
                  style: OutlinedButton.styleFrom(
                  backgroundColor: noir().withValues(alpha: 0.3),
                  side: BorderSide(color: noir(), width: 2), // Custom border
                  ),
                child: CustomText(
                  "Retour",
                  color: noir(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0, left: 8.0),
                child:OutlinedButton(
                  onPressed: () async {
                    loadPop(context) ;
                    if (duree > 0) {
                      SeanceModel newSeance = SeanceModel(duree: duree, idCours: idCours , date: formattedDate);
                      bool res = await SeanceController().addSeance(newSeance) ;
                      if (res) {
                        DInfo.toastSuccess("Seance enregistrée avec success !");
                        Timer(const Duration(seconds: 1), () {
                          Navigator.pop(context) ;
                          Navigator.of(context).push(
                            SlideRightRoute(
                                child: NavigationPage(value: 0),
                                page: NavigationPage(value: 0),
                                direction: AxisDirection.left),
                          );
                        }
                        );
                      } else {
                        DInfo.toastError("une erreur est survenue !");
                      }
                    } else {
                      DInfo.toastError("Valeur incorrecte! Réessayer svp! ");
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: orangeFonce(),
                    side: BorderSide(color: orangeFonce(), width: 2), // Custom border
                  ),
                  child: CustomText(
                    "Valider",
                    fontWeight: FontWeight.w500,
                    color: noir(),
                  ),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

