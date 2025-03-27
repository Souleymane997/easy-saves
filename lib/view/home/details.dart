
import 'package:easy_saves/controllers/seance_controller.dart';
import 'package:easy_saves/models/cours_model.dart';
import 'package:easy_saves/models/seance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signup/auth.dart';
import 'package:flutter/foundation.dart';

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
    getListIDSeance() ;
    calculSommeTotal() ;
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


  @override
  void initState() {
    super.initState();
    getListSeance();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: noir(),
        body: SafeArea(
          child: Stack(
            children: [
              const Background(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ArrowBack(),
                  DetailsHeaders(cours: widget.cours, listSeance: listSeance , coutTotal: coutTotal,),
                  Expanded(child: ListViewDetails(listSeance: listSeance ,cours: widget.cours,listIDSeance: listIDSeance )),
                ],
              ),
            ],
          ),
        ));
  }
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
  const DetailsHeaders({super.key , required this.cours , required this.listSeance , required this.coutTotal});
  final CoursModel cours ;
  final List<SeanceModel> listSeance ;
  final int coutTotal ;

  @override
  State<DetailsHeaders> createState() => _DetailsHeadersState();
}

class _DetailsHeadersState extends State<DetailsHeaders> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));

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
              padding: const EdgeInsets.all(3.0),
              child: CupertinoButton(
                color: orange(),
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
                padding: const EdgeInsets.all(8.0),
                child: SortPacket(),
              ),
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

class ListViewDetails extends StatelessWidget {
  const ListViewDetails({super.key , required this.listSeance , required this.cours , required this.listIDSeance });
  final List<SeanceModel> listSeance ;
  final CoursModel cours ;
  final List<String> listIDSeance ;

  delete(String idSeance) async {
      bool res =
      await SeanceController().deleteSeance(idSeance);
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listSeance.length,
      itemBuilder: (BuildContext context, int index) {
        SeanceModel seance = listSeance[index] ;

        return Dismissible(
          key: Key(index.toString()),
          direction: DismissDirection.endToStart,
          background: slideLeftBackground(),
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: CustomText("Confirmer la suppression" , color: noir(), fontWeight: FontWeight.w700, tex: TailleText(context).soustitre,),
                  backgroundColor: orange(),
                  content: Text("Voulez-vous vraiment supprimer cet élément ?"),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                         Navigator.of(context).pop(false) ;
                      },
                      style: OutlinedButton.styleFrom(
                      backgroundColor: noir().withValues(alpha: 0.3),
                      side: BorderSide(color: noir(), width: 2), // Custom border
                      ),
                      child: CustomText(
                      "Annuller",
                      color: noir(),
                      ),
                      ),

                    OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true) ;
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: orangeFonce(),
                        side: BorderSide(color: orangeFonce(), width: 2), // Custom border
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
            delete(listIDSeance[index]) ;
          },
          child: CoursDetailsCard(cours: cours, seance: seance),
        );

      },
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
