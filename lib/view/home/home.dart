// ignore_for_file: deprecated_member_use

import 'package:easy_saves/controllers/cours_controller.dart';
import 'package:easy_saves/models/cours_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_refresh/easy_refresh.dart';

import '../../component/bg.dart';
import '../../component/cardCours.dart';
import '../../controllers/seance_controller.dart';
import '../../models/seance.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../signup/auth.dart';
import 'newCours.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  late User? user;
  List<CoursModel> listCours = [] ;
  List<CoursModel> filteredCours = [];
  List<String> listID = [] ;
  List<String> searchListID = [] ;
  List<int> listPos = [] ;
  late EasyRefreshController _controller;
  final FocusNode _focusNode = FocusNode();




  @override
  void initState() {
    super.initState();
    getListCours();
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
      body: Stack(children: [
        const Background(),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    fillColor: const Color(0xFF979797).withOpacity(0.1),
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
                  onLoad: _onLoadMore,
                  child: GridCours(listCours: filteredCours, listID: searchListID,))),
            ],
          ),
        ),
        const FloatingButton(),
      ]),
    );
  }


  /* *************************************************/

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
        await CoursController().getListCours(user!.uid);

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
        await CoursController().getListIDCours(user!.uid , searchController.text);

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

    Future<void> _onLoadMore() async {
      await Future.delayed(Duration(seconds: 2));
      _controller.finishLoad(listCours.length < 30 ? IndicatorResult.success : IndicatorResult.noMore);
    }

    Future<void> _autoRefresh() async {
      await Future.delayed(Duration(milliseconds: 500));
      _controller.callRefresh();
    }

  /* *************************************************/



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
              "Mes Cours",
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
              "Nombre de cours : $length ",
              tex: TailleText(context).contenu * 1.3,
              color: blanc().withOpacity(0.25),
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
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: SpinKitCircle(
            color: orange(),
            size: 30.0,
          ),
        ),
      );
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
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: CardCours(item: item , nbre: long , idCours: listID[index] ),
                );
              }
        }) ;

      },
    );
  }
}

//Floating Button
class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Card(
        elevation: 8,
        color: Colors.transparent,
        margin: const EdgeInsets.only(right: 5, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            showNewsCours(context);
          },
          backgroundColor: orange(),
          child: Center(
            child: Icon(
              Icons.add_circle,
              size: 40,
              color: blanc(),
            ),
          ),
        ),
      ),
    );
  }
}
