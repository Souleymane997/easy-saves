// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../component/bg.dart';
import '../../component/stayinapp.dart';
import '../../component/textinputcard.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/function.dart';
import '../../shared/loading.dart';
import '../../shared/slidepage.dart';
import 'authenticate.dart';
import 'auth.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User? user = AuthController().currentUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isHidden = true;
  bool load = false;
  late String keyUser;
  bool exitValue = true;

  @override
  void initState() {
    // checkLogged();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  exit() {
    setState(() {
      exitValue = true;
    });
  }


  bool validateEmail(String? email) {
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final isEmailValid = emailRegex.hasMatch(email ?? "");
    if (!isEmailValid) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          onWillPopUp(context, exit);
          debugPrint(exitValue.toString());
          return exitValue;
        },
        child: Scaffold(
          body: Stack(children: [
            const Background(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      CustomText(
                        "Renitialisation du Mot de Passe",
                        tex: TailleText(context).titre * 1.25,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        LoginInput(
                            editController: emailController,
                            type: TextInputType.emailAddress,
                            bgcolor: grisFonce(),
                            curscolor: blanc(),
                            hint: " Email "),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                            onPressed: () async {
                              closeKeyboard(context);
                              setState(() {
                                load = true;
                              });
                              if (await validateAndSave()) {
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    load = false;
                                  });
                                  resultatPop(context);
                                });
                              } else {
                                setState(() {
                                  load = false;
                                });
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(orange()),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CustomText(
                                " Renitialiser ",
                                color: noir(),
                                tex: TailleText(context).soustitre * 0.9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              " ------------- ",
                              color: blanc().withOpacity(0.75),
                              tex: TailleText(context).contenu,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: const Authenticate(),
                                        page: const Authenticate(),
                                        direction: AxisDirection.left),
                                  );
                                },
                                child: CustomText(
                                  " Connexion ",
                                  color: orange(),
                                  tex: TailleText(context).titre,
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            (load) ? const Loading() : Container(),
          ]),
        ));
  }

  Future<bool> validateAndSave() async {
    if (emailController.text.isNotEmpty) {
      if (validateEmail(emailController.text)) {
        DInfo.toastError("Email non valid !");
        return false;
      }

      await AuthController().sendPasswordResetEmail(emailController.text);
      return true;
    } else {
      DInfo.toastError("Remplissez les champs svp !");
      return false;
    }
  }

  //*  pop de loading  ....
  resultatPop(
    BuildContext context,
  ) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                backgroundColor: orange(),
                insetPadding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                content: Builder(
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CustomText(
                                  'Renitialisation Soumis',
                                  color: noir(),
                                  textAlign: TextAlign.center,
                                  tex: TailleText(context).soustitre,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              //------------------------fonction-------------------------
                              Column(
                                children: [
                                  CustomText(
                                    "\nUn lien vous a été envoyé.\nVérifier votre compte mail svp  ",
                                    color: noir(),
                                    textAlign: TextAlign.center,
                                    tex: TailleText(context).soustitre * 0.75,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              Container(
                                height: 8,
                              ),
                              IconButton(
                                onPressed: () {
                                  Loading();
                                  Timer(const Duration(milliseconds: 200), () {
                                    Navigator.of(context).push(
                                      SlideRightRoute(
                                          child: const Authenticate(),
                                          page: const Authenticate(),
                                          direction: AxisDirection.right),
                                    );
                                  });
                                },
                                icon: Icon(
                                  CupertinoIcons.clear_circled,
                                  size: 30,
                                  color: noir(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
        });
  }
}
