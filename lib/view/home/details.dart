
import 'dart:async';

import 'package:easy_saves/controllers/seance_controller.dart';
import 'package:easy_saves/models/cours_model.dart';
import 'package:easy_saves/models/seance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signup/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/dialoguetoast.dart';

import '../../component/bg.dart';
import '../../component/cardCours.dart';
import '../../component/headers_component.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/function.dart';

class DetailsCoursPage extends StatefulWidget {
  const DetailsCoursPage({super.key , required this.idCours , required this.cours });
  final String idCours ;
  final CoursModel cours ;

  @override
  State<DetailsCoursPage> createState() => _DetailsCoursPageState();
}

class _DetailsCoursPageState extends State<DetailsCoursPage> {

  late User? user;
  List<SeanceModel> listSeance = [] ;
  List<String> listIDSeance = [] ;
  int coutTotal = 0 ;
  bool isLoad = true ;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 14));

  ///******************************************/

  getListSeance() async {
    user = AuthController().currentUser;
    if (user != null) {
      List<SeanceModel>  list =
      await SeanceController().getListSeance(widget.idCours);

      setState(() {
        listSeance = list ;
      });
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
    }

    Timer(Duration(milliseconds: 50), () {
      getListIDSeance() ;
      calculSommeTotal() ;
    });

  }

  loadPage() {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isLoad = false ;
      });
      //print("5 secondes écoulées !");
    });
  }

  getListIDSeance() async {
    user = AuthController().currentUser;
    if (user != null) {

      List<String>  list =
      await SeanceController().getListIDSeance(widget.idCours);
      setState(() {
        listIDSeance = list ;
      });
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
    }
  }

  calculSommeTotal(){
    int somme = 0 ;
    int prix = widget.cours.prix ;

    for (int i = 0; i < listSeance.length; i++) {
      somme = listSeance[i].duree * prix + somme ;
    }
    setState(() {
      coutTotal = somme ;
    });
  }


  void showBottomDatePicker(
      BuildContext context, DateTime dateData, bool dateLevel) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: blanc(),
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                backgroundColor: blanc(),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: dateData,
                minimumDate: DateTime(2015),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    dateData = DateTime(date.year, date.month, date.day);
                    if (dateLevel) {
                      startDate = dateData;
                    } else {
                      endDate = dateData;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CupertinoButton(
                color: orangeFonce(),
                child: CustomText(
                  'Fait',
                  color: noir(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

   getListTri( String idCours) async {
    List<SeanceModel>  list =
    await SeanceController().getListTri(idCours ,  formatDate(startDate)  ,  formatDate(endDate) );
    setState(() {
      listSeance = list ;
    });
    calculSommeTotal() ;
  }



  ///******************************************/


  @override
  void initState() {
    super.initState();
    loadPage() ;
    getListSeance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: noir(),
        body: SafeArea(
          child:isLoad
          ? Center(
            child: SizedBox(
              width: 100,
              height: 80,
              child: Center(
                child: SpinKitCircle(
                  color: orange(),
                  size: 30.0,
                ),
              ),
            ),
          )
          : Stack(
            children: [
              const Background(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ArrowBack(),

            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: marroon(),
                borderRadius: BorderRadius.circular(20),
              ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              widget.cours.titre.toUpperCase(),
                              family: 'RobotoItalic',
                              tex: TailleText(context).titre * 1.3,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  showBottomDatePicker(context, startDate, true);
                                },
                                child: DatePacket(date: formatMonthDay(startDate))),
                            InkWell(
                                onTap: () {
                                  showBottomDatePicker(context, endDate, false);
                                },
                                child: DatePacket(date: formatMonthDay(endDate))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0, left: 4.0 , top: 10),
                              child:OutlinedButton(
                                onPressed: () async {
                                  getListTri(widget.idCours) ;
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: orangeFonce(),
                                  side: BorderSide(color: orangeFonce(), width: 2), // Custom border
                                ),
                                child: CustomText(
                                  "Trier",
                                  fontWeight: FontWeight.w500,
                                  color: noir(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CustomText(
                            "Nombre de Seance : ${listSeance.length} ",
                            color: blanc().withValues(alpha: 0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CustomText(
                            "Cout Total Actuel : ${coutTotal}F",
                            color: blanc(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                ),
                 // DetailsHeaders(cours: widget.cours, listSeance: listSeance , coutTotal: coutTotal,idCours: widget.idCours,),
                  Expanded(child: ListViewDetails(listSeance: listSeance ,cours: widget.cours,listIDSeance: listIDSeance, idCours: widget.idCours )),
                ],
              ) ,
            ],
          ),

        ));
  }
}


void setSeance(BuildContext context , SeanceModel seance, String idSeance , CoursModel cours , String idCours ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int duree = seance.duree ;
      return AlertDialog(
        title: CustomText(
          'Modifier la Durée de la séance',
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
                      bool res = await SeanceController().updateSeance(idSeance, duree, seance.date) ;
                      if (res) {
                        DInfo.toastSuccess("Seance Modifée avec success !");
                        Timer(const Duration(milliseconds: 200), () {
                          Navigator.pop(context) ;
                          Navigator.pop(context) ;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                DetailsCoursPage(idCours: idCours, cours: cours)), // Remplace `MyPage` par ta page actuelle
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

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.back,
                  color: blanc(),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.001,
        ),
      ],
    );
  }
}

class DetailsHeaders extends StatefulWidget {
  const DetailsHeaders({super.key , required this.cours , required this.listSeance ,required this.idCours, required this.coutTotal});
  final CoursModel cours ;
  final List<SeanceModel> listSeance ;
  final String idCours ;
  final int coutTotal ;

  @override
  State<DetailsHeaders> createState() => _DetailsHeadersState();
}

class _DetailsHeadersState extends State<DetailsHeaders> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 14));
  List<SeanceModel> listSeance = []; // Déclarer une liste modifiable


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: marroon(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                widget.cours.titre.toUpperCase(),
                family: 'RobotoItalic',
                tex: TailleText(context).titre * 1.3,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    //showBottomDatePicker(context, startDate, true);
                  },
                  child: DatePacket(date: formatMonthDay(startDate))),
              InkWell(
                  onTap: () {
                    //showBottomDatePicker(context, endDate, false);
                  },
                  child: DatePacket(date: formatMonthDay(endDate))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0, left: 4.0 , top: 10),
                child:OutlinedButton(
                  onPressed: () async {
                    // List<SeanceModel> list = await getListTri(widget.idCours) ;
                    // setState(() {
                    //   listSeance =  list ;
                    // });

                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: orangeFonce(),
                    side: BorderSide(color: orangeFonce(), width: 2), // Custom border
                  ),
                  child: CustomText(
                    "Trier",
                    fontWeight: FontWeight.w500,
                    color: noir(),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomText(
              "Nombre de Seance : ${widget.listSeance.length} ",
              color: blanc().withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomText(
              "Cout Total Actuel : ${widget.coutTotal}F",
              color: blanc(),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class ListViewDetails extends StatefulWidget{
  const ListViewDetails({super.key , required this.listSeance , required this.cours , required this.listIDSeance , required this.idCours});
  final List<SeanceModel> listSeance ;
  final CoursModel cours ;
  final String idCours ;
  final List<String> listIDSeance ;

  @override
  State<ListViewDetails> createState() => _ListViewDetailsState();
}

class _ListViewDetailsState extends State<ListViewDetails> {
  delete(String idSeance) async {
    await SeanceController().deleteSeance(idSeance);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.listSeance.isEmpty ){
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: MediaQuery.sizeOf(context).height * 0.1,) ,
          Container(
            width: 100,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                image: const DecorationImage(
                  image: AssetImage('assets/icon/trash.png'),
                  fit: BoxFit.contain,
                )),
          ),
          CustomText("Votre Liste de Seance est vide"),
        ],
      )); //
    }


    return  ListView.builder(
      itemCount:  widget.listSeance.length ,
      itemBuilder: (BuildContext context, int index) {
          SeanceModel seance = widget.listSeance[index];
          return Dismissible(
            key: Key(index.toString()),
            direction: DismissDirection.endToStart,
            background: slideLeftBackground(),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: CustomText("Confirmer la suppression", color: noir(),
                      fontWeight: FontWeight.w700,
                      tex: TailleText(context).soustitre,),
                    backgroundColor: orange(),
                    content: Text(
                        "Voulez-vous vraiment supprimer cet élément ?"),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: noir().withValues(alpha: 0.3),
                          side: BorderSide(
                              color: noir(), width: 2), // Custom border
                        ),
                        child: CustomText(
                          "Annuller",
                          color: noir(),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: orangeFonce(),
                          side: BorderSide(
                              color: orangeFonce(), width: 2), // Custom border
                        ),
                        child: CustomText(
                          "Supprimer",
                          fontWeight: FontWeight.w500,
                          color: noir(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) async {
              // Supprimer l'élément de Firestore ou de la liste
              if (index < widget.listSeance.length) {
                delete(widget.listIDSeance[index]);
                widget.listSeance.removeAt(index);
                Timer(Duration(milliseconds: 00), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        DetailsCoursPage(idCours: widget.idCours, cours: widget
                            .cours)), // Remplace `MyPage` par ta page actuelle
                  );
                });
              }
            },
            child: CoursDetailsCard(
                cours: widget.cours,
                seance: seance,
                idCours: widget.idCours,
                idSeance: ( widget.listIDSeance.isNotEmpty) ? widget.listIDSeance[index] : "") ,
          );
        }

    );
  }
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.delete,
          color: Colors.white,
        ),
        Text(
          " Delete",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    ),
  );
}
