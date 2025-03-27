// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import '../../component/bg.dart';
import '../../component/stayinapp.dart';
import '../../shared/colors.dart';
import '../signup/authenticate.dart';
import 'btnnext.dart';
import 'pagecontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCaroussel extends StatefulWidget {
  const SplashCaroussel({super.key});

  @override
  State<SplashCaroussel> createState() => _SplashCarousselState();
}

class _SplashCarousselState extends State<SplashCaroussel> {
  int _current = 0;
  late bool newInstall;

  bool exitValue = true;

 late SharedPreferences prefs ;
  int initScreen = 0;

  List<PageViewContainer> listPage = const [
    PageViewContainer(
      pathImage: "assets/images/1.png",
      text: "Tracer vos cours Rapidement & Efficacement",
      text2: "Vous avez acces a l'historique de vos cours en temps reel.",
    ),
    PageViewContainer(
      pathImage: "assets/images/2.png",
      text: "Enregistrer vos seances et Visualiser vos Recettes Mensuelles",
      text2: "Enregistrement ultra rapide et facilite la gestion de tarifs",
    ),
    PageViewContainer(
      pathImage: "assets/images/3.png",
      text: "Devenez Plus \nProfessionnel et \nDynamique",
      text2: "Vos cours, vos tarifs, vos historiques annuels et mensuels sont archives et disponibles",
    )
  ];


  void checkLogged() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      initScreen = (prefs.getInt("initScreen") ?? 0);
    });
  }

  @override
  void initState()   {
    //requestPermission();
    checkLogged();
    super.initState();
  }

  exit() {
    setState(() {
      exitValue = true;
    });
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
    onWillPop: () async {
      onWillPopUp(context, exit);

      return exitValue;
    },
        child: Scaffold(
          body: Stack(
            children: [
              const Background(
             
            ),
              CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1,
                      reverse: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: listPage.toList()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listPage.map((url) {
                      int index = listPage.indexOf(url);
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? blanc()
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () async {
                        // setState(() {
                        //   viewSplash.setBool('install', false);
                        // });
                        await prefs.setInt("initScreen", 1);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const Authenticate()),
                          ),
                        );
                      },
                      child: const BtnNext(text: "Commencer", fin: true)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
