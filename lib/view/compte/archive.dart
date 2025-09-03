import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:easy_saves/shared/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../component/bg.dart';
import '../../component/cardCours.dart';
import '../../controllers/cours_controller.dart';
import '../../controllers/seance_controller.dart';
import '../../models/cours_model.dart';
import '../../models/seance.dart';
import '../../shared/colors.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/function.dart';
import '../../shared/slidepage.dart';
import '../navigationbody.dart';
import '../signup/auth.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key, required this.val});
  final int val ;

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  TextEditingController searchController = TextEditingController();
  late User? user;
  List<CoursModel> listCours = [] ;
  List<CoursModel> filteredCours = [];
  List<String> listID = [] ;
  List<String> searchListID = [] ;
  List<int> listPos = [] ;
  late EasyRefreshController _controller;
  final FocusNode _focusNode = FocusNode();
  bool isLoad = true ;


  @override
  void initState() {
    super.initState();
    getListCours();
    loadPage() ;
    _controller = EasyRefreshController();
    _controller = EasyRefreshController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _autoRefresh();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      )
          :

      Stack(children: [
        const Background(),
        ArrowBack(val: widget.val,),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25,) ,
              HomeHeader(length: listCours.length,),
              Container(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Form(
                  child: TextFormField(
                    validator: (value) {
                      return null;
                    },
                    onChanged: filterCours,
                    maxLines: 1,
                    onSaved: (onSavedval) {
                      searchController.text = onSavedval!;
                    },
                    style: const TextStyle(color: Colors.white),
                    controller: searchController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      hintStyle: const TextStyle(color: Color(0xFF757575)),
                      fillColor: const Color(0xFF979797).withValues(alpha: 0.1),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Recherche un cours",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Expanded(child: EasyRefresh(
                  controller: _controller,
                  onRefresh: _onRefresh,
                  header: MaterialHeader(color: orange()),
                  child: GridCours(listCours: filteredCours, listID: searchListID,))),
            ],
          ),
        ),
      ]),
    );
  }


  /* *************************************************/

  loadPage() {
    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        isLoad = false ;
      });
    });
  }


  filterCours(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCours = listCours;
        searchListID = listID ;
      } else {
        filteredCours = listCours.where((item) => item.titre.toLowerCase().contains(query.toLowerCase())).toList();
        //getListID() ;
        searchId() ;
      }
    });
  }

  searchId(){
    List<int> listPos = listCours
        .asMap()
        .entries
        .where((entry) => filteredCours.any((c) => c.titre == entry.value.titre))
        .map((entry) => entry.key)
        .toList();

    List<String> newList = [] ;

    for (int i = 0; i < listPos.length; i++) {
      String elem = listID[listPos[i]] ;
      newList.add(elem) ;
    }
    setState(() {
      searchListID = newList ;
    });
  }


  getListCours() async {
    user = AuthController().currentUser;
    if (user != null) {
      if (kDebugMode) {
        print(user!.uid);
      }

      List<CoursModel>  list =
      await CoursController().getListCours(user!.uid,true);

      setState(() {
        listCours = list ;
        filteredCours = list ;
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
      await CoursController().getListIDCours(user!.uid , searchController.text,true);


      setState(() {
        listID = list ;
        searchListID = listID ;
      });
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
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

}



//Header Widgets
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key, required this.length,
  });

  final int length ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 15,
            ),
            CustomText(
              "Mes Archives",
              tex: TailleText(context).titre * 1.5,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 15,
            ),
            CustomText(
              "Nombre de cours archivé : $length ",
              tex: TailleText(context).contenu * 1.3,
              color: blanc().withValues(alpha: 0.25),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    );
  }
}

class GridCours extends StatelessWidget {
  const GridCours({super.key, required this.listCours, required this.listID});
  final List<CoursModel> listCours ;
  final List<String> listID ;

  Future<int> getLisSeance(String idCours) async {
    List<SeanceModel>  list =
    await SeanceController().getListSeance(idCours);
    return list.length ;
  }


  @override
  Widget build(BuildContext context) {
    if (listCours.isEmpty || listID.isEmpty){
      return Center(child: Column(
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
          CustomText("Votre Liste d'Archive est vide"),
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
            builder: (context, snapshot) {
              int long = snapshot.data ?? 0;
              if (listCours.isEmpty || listID.isEmpty) {
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
                    CustomText("votre Liste d'Archive est vide"),
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
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CardCoursArchive(item: item , nbre: long , idCours: listID[index] ),
                );
              }
            }) ;

      },
    );
  }
}


class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key, required this.val});
  final int val ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,) ,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: IconButton(
                onPressed: () {
                  if(val == 0){
                    Navigator.pop(context);
                  }else{
                    Navigator.of(context).push(
                      SlideRightRoute(
                          child: NavigationPage(value: 2),
                          page: NavigationPage(value: 2),
                          direction: AxisDirection.left),
                    );
                  }
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



void setCoursArchive(BuildContext context , CoursModel cours , String idCours ) {
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
                                DInfo.toastSuccess("Cours desarchivé avec success !");
                                Timer(const Duration(milliseconds: 200), () {
                                  Navigator.pop(context) ;
                                  Navigator.pop(context) ;
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: ArchivePage(val: 1,),
                                        page: ArchivePage(val: 1,),
                                        direction: AxisDirection.right),
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
                              "Desarchivez le cours",
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
                                        child: ArchivePage(val: 1,),
                                        page: ArchivePage(val: 1,),
                                        direction: AxisDirection.right),
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


// verifie les champs de saisie
Future<bool> archiveAndSave(String coursId, CoursModel item) async {
  bool check = await CoursController().archiveCours(coursId,item,false) ;

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



