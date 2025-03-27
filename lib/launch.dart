import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'component/bg.dart';
import 'shared/colors.dart';
import 'shared/custom_text.dart';
import 'view/onBording/splash_caroussel.dart';
import 'widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  bool logged = false;
  bool load = false;

  late String nom;
  late String email;
  late String token;

  late SharedPreferences prefs;
  int initScreen = 0;

  void checkLogged() async {
    Timer(const Duration(seconds: 3), () => checkLogin());
  }

  void checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      initScreen = (prefs.getInt("initScreen") ?? 0);
    });

    setState(() {
      load = true;
    });

    Timer(
      const Duration(seconds: 2),
      () {

        if(initScreen == 0){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: ((context) => const SplashCaroussel())),
          );
        }
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: ((context) => const WidgetTree())),
          );

        }


      }
    );
  }

  @override
  void initState() {
    //permission();
    checkLogged();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    "Easy SAVE",
                    color: orange(),
                    fontWeight: FontWeight.w800,
                    tex: 1.3,
                  ),
                ],
              ),
            ),
          ),
          load
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: SpinKitCircle(
                        color: blanc(),
                        size: 30.0,
                      ),
                    ),
                    Container(
                      height: 40,
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
