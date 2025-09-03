
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_saves/controllers/cours_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_saves/models/cours_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'dart:async';

import '../../component/bg.dart';
import '../../component/cardCours.dart';
import '../../component/headers_component.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/function.dart';
import '../signup/auth.dart';
import '../../controllers/seance_controller.dart';
import '../../models/seance.dart';
import '../../shared/slidepage.dart';
import '../../shared/dialoguetoast.dart';
import '../navigationbody.dart';


class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key , required this.date});
  final DateTime date ;

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {

  late User? user;
  List<CoursModel> listCours = [] ;
  List<String> listID = [] ;
  late DateTime date  ;
  bool isLoad = true ;

  late EasyRefreshController _controller;
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _controller = EasyRefreshController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _autoRefresh();
      }
    });
    setState(() {
      date = widget.date ;
    });

    getListCours();
    loadPage() ;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  loadPage() {
    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        isLoad = false ;
      });
      //print("5 secondes écoulées !");
    });
  }


  Future<int> getLisSeance(String idCours) async {
    DateTime startDate = DateTime(date.year, date.month,1);
    DateTime endDate = DateTime(date.year, date.month,30);
    List<SeanceModel>  list =
    await SeanceController().getListTri(idCours, formatDate(startDate) , formatDate(endDate) );
    return list.length ;
  }

  getListCours() async {
    user = AuthController().currentUser;
    if (user != null) {
      if (kDebugMode) {
        print(user!.uid);
      }

      List<CoursModel>  list =
      await CoursController().getListCours(user!.uid,false);

      setState(() {
        listCours = list ;
      });
      getListID() ;
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
    }
  }

  getListID() async {
    user = AuthController().currentUser;
    if (user != null) {

      List<String>  list =
      await CoursController().getListIDCours(user!.uid , "",false);
      setState(() {
        listID = list ;
      });
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
    }
  }

  Future<int> getCoutTotal(String idCours , CoursModel item) async {

    int somme = 0;
    List<SeanceModel>  list =
    await SeanceController().getListTri( idCours , formatDate(DateTime(date.year, date.month,1)) , formatDate(DateTime(date.year, date.month,30)));

      if(list.isNotEmpty){
        int prix = item.prix ;
        for (int i = 0; i < list.length; i++) {
          somme = list[i].duree * prix + somme ;
        }
        return somme ;
      }
      else{
        return 0 ;
      }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    getListCours() ;
    getListID() ;
    _controller.finishRefresh();
  }


  Future<void> _autoRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    _controller.callRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: noir(),
      body: isLoad
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
      ) :
      Stack(children: [
        const Background(),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            DetailsHeaders(date: date, listCours: listCours, listID: listID),
            Expanded(child: EasyRefresh(
                controller: _controller,
                onRefresh: _onRefresh,
                header: MaterialHeader(color: orange()),

                child: grid())),
           // Expanded(child: GridCours(listCours: listCours, listID: listID,date: date,)),
          ],
        )
      ]),
    );
  }




  Widget grid() {
    if (listCours.isEmpty || listID.isEmpty ){
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


      return GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: listCours.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: MediaQuery.of(context).size.height * 0.23,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 2,
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          CoursModel item = listCours[index] ;
          return FutureBuilder<int>(future: getLisSeance(listID[index]),
              builder: (context, snapshot)  {
                int long = snapshot.data ?? 0;
                if (listCours.isEmpty || listID.isEmpty ) {
                  return Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      CustomText("votre Liste de CD est vide"),
                    ],
                  )); // Handle empty state
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      child: Center(child: CircularProgressIndicator()), // Show loading indicator
                    ),
                  );
                } else {

                  return FutureBuilder<int>(
                    future: getCoutTotal(listID[index], item),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Card(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }
                      final cout = snapshot.data!;
                      return Padding(
                        padding: EdgeInsets.all(3.0),
                        child: CardCoursRecette(
                          item: item,
                          nbre: long,
                          idCours: listID[index],
                          cout: cout,
                          date: date,
                        ),
                      );
                    },
                  );
                }
              }) ;
        },
      );


  }
}



class DetailsHeaders extends StatefulWidget {
  const DetailsHeaders({super.key,required this.date, required this.listCours , required this.listID });
  final DateTime date ;
  final List<CoursModel> listCours ;
  final List<String> listID ;

  @override
  State<DetailsHeaders> createState() => _DetailsHeadersState();
}

class _DetailsHeadersState extends State<DetailsHeaders> {

  late DateTime date ;
  late DateTime startDate ;
  late DateTime endDate ;
  int recette = 0 ;
  bool load = true ;



  calculSommeTotal() async{

    for (int i = 0; i < widget.listCours.length; i++) {
      int somme = 0 ;
      int prix = widget.listCours[i].prix ;
      List<SeanceModel> listSeance = await getListSeance(widget.listID[i]) ;

      for (int j = 0; j < listSeance.length; j++) {
        somme = listSeance[j].duree * prix + somme ;
      }
      setState(() {
        recette = somme  + recette ;
      });

    }

    setState(() {
      load = false ;
    });
  }


  Future<List<SeanceModel>> getListSeance(String idCours) async {
    List<SeanceModel>  list = [] ;
    list =
      await SeanceController().getListTri(idCours , formatDate(startDate)  ,  formatDate(endDate) );
    return list ;
  }



  @override
  void initState() {
    super.initState();
    date = widget.date ;
    startDate = DateTime(date.year, date.month,1);
    endDate = DateTime(date.year, date.month,30);

    Timer(Duration(seconds: 5), () {
      calculSommeTotal() ;
    });


  }


  void showBottomDatePicker(BuildContext context, DateTime dateData) {
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
                onDateTimeChanged: (DateTime dates) {
                  setState(() {
                    dateData = DateTime(dates.year, dates.month, dates.day);
                    date = dateData ;
                    startDate = DateTime(date.year, date.month,1);
                    endDate = DateTime(date.year, date.month,30);
                    //print(date) ;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CupertinoButton(
                color: orange(),
                child: CustomText('Fait',color: noir(),),
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
                "Recette Cumulée ",
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
                  onTap: (){
                    showBottomDatePicker(context, date) ;
                  },
                  child: DatePacket(date:  formatMonthYear(date))),

              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    //print(date) ;

                    Navigator.of(context).push(
                      SlideRightRoute(
                          child: NavigationPage(value: 1, date: date),
                          page: NavigationPage(value: 1, date: date),
                          direction: AxisDirection.left),
                    );

                  });
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
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SizedBox(
              width: 100,
              child: Divider(
                color: blanc().withValues(alpha: 0.3),
                thickness: 2,
              ),
            ),
          ),

          load
              ? Center(
            child: SpinKitCircle(
              color: orange(),
              size: 30.0,
            ),
          )
              : CustomText(
            "Mois de ${monthName(date.month).toUpperCase()} : $recette FCFA",
            color: blanc(),
            fontWeight: FontWeight.w700,
          ),

        ],
      ),
    );
  }
}



// verifie les champs de saisie
Future<bool> archiveAndSave(String coursId, CoursModel item) async {
    bool check = await CoursController().archiveCours(coursId,item,true) ;

    if(check){
      //print("Cours Archivé");
      return true ;
    }
    else{
      DInfo.toastError("une erreur est survenue !");
      return false;
    }

}


// verifie les champs de saisie
Future<bool> deleteAndSave(String coursId) async {
  bool check = await CoursController().deleteCours(coursId ) ;

  if(check){
    //print("Cours supprimé");
    return true ;
  }
  else{
    DInfo.toastError("une erreur est survenue !");
    return false;
  }

}


void setCours(BuildContext context , CoursModel cours , String idCours ,DateTime date ) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: orange(),
        content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 4.0 , top: 3, bottom: 3),
                          child: OutlinedButton(
                            onPressed: () async {
                              loadPop(context) ;
                              if(await archiveAndSave(idCours, cours)){
                                DInfo.toastSuccess("Cours archivé avec success !");
                                Timer(const Duration(milliseconds: 200), () {
                                  Navigator.pop(context) ;
                                  Navigator.pop(context) ;
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: NavigationPage(value: 1, date: date),
                                        page: NavigationPage(value: 1, date: date),
                                        direction: AxisDirection.left),
                                  );
                                }
                                );
                              }


                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green.withValues(alpha: 0.3),
                              side: BorderSide(color: Colors.green.shade800, width: 2), // Custom border
                            ),
                            child: CustomText(
                              "Archivez le cours",
                              color: noir(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10) ,
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 8.0 , top: 3, bottom: 3),
                          child:OutlinedButton(
                            onPressed: () async {
                              loadPop(context) ;
                              if(await deleteAndSave(idCours)){
                                DInfo.toastSuccess("Cours supprimé avec success !");
                                Timer(const Duration(milliseconds: 200), () {
                                  Navigator.pop(context) ;
                                  Navigator.pop(context) ;
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: NavigationPage(value: 1, date: date),
                                        page: NavigationPage(value: 1, date: date),
                                        direction: AxisDirection.left),
                                  );
                                }
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: orangeFonce(),
                              side: BorderSide(color: Colors.deepOrange, width: 2), // Custom border
                            ),
                            child: CustomText(
                              "Supprimez le cours",
                              fontWeight: FontWeight.w500,
                              color: noir(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 8.0),
            child:OutlinedButton(
              onPressed: () async {
                Navigator.pop(context) ;
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: noir().withValues(alpha: 0.3),
                side: BorderSide(color: noir(), width: 2),// Custom border
              ),
              child: CustomText(
                "Retour",
                fontWeight: FontWeight.w500,
                color: noir(),
              ),
            ),
          )
        ],
      );
    },
  );
}





