// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:easy_saves/view/signup/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../component/bg.dart';
import '../../component/buttoncard.dart';
import '../../component/stayinapp.dart';
import '../../component/textinputcard.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/function.dart';
import '../../shared/loading.dart';
import '../../shared/slidepage.dart';
import '../../shared/dialoguetoast.dart';
import '../navigationbody.dart';
import 'forget.dart';
import 'sign.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.toggleView});
  final Function toggleView;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  exit() {
    setState(() {
      exitValue = true;
    });
  }

  bool validateEmail(String? email){
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') ;
    final isEmailValid = emailRegex.hasMatch(email??"") ;
    if(!isEmailValid){
      return true ;
    }
    return false ;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          onWillPopUp(context, exit);
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
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23.0),
                        color: orange().withOpacity(0.25)),
                    child: Row(
                      children: [
                        Expanded(
                            child: ButtonCard(
                          text: "Se connecter",
                          color: orange(),
                          x: Login(toggleView: widget.toggleView),
                          textcolor: noir(),
                          taille: 0.3,
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: ButtonCard(
                          text: "Creer compte",
                          color: noir(),
                          x: SignUp(toggleView: widget.toggleView),
                          textcolor: orange(),
                          taille: 0.3,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      CustomText(
                        "Connexion",
                        tex: 2.3,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.025,
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
                        Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 8),
                          child: Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: grisFonce(),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextFormField(
                                        maxLines: 1,
                                        cursorColor: blanc(),
                                        controller: passwordController,
                                        keyboardType: TextInputType.text,
                                        onSaved: (onSavedval) {
                                          passwordController.text = onSavedval!;
                                        },
                                        validator: (val) => (val!.length < 6 )? "Mot de passe trop court" :  null,
                                        obscureText: isHidden,
                                        style: TextStyle(
                                          color: blanc(),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: " Mot de passe ",
                                          hintStyle: TextStyle(
                                              color: blanc().withOpacity(0.25),
                                              fontSize: 12),
                                          suffixIcon: IconButton(
                                            color:
                                                (isHidden) ? gris() : orange(),
                                            icon: Icon(isHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                isHidden = !isHidden;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: const ForgetPass(),
                                        page: const ForgetPass(),
                                        direction: AxisDirection.left),
                                  );
                                },
                                child: CustomText(
                                  "Mot de passe oublié?",
                                  color: orange(),
                                  tex: TailleText(context).contenu,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.025,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                            onPressed: () async {
                              closeKeyboard(context);
                              setState(() {
                                load = true;
                              });

                              _formKey.currentState!.validate() ;

                              if (await validateAndSave()) {
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    load = false;
                                  });
                                  Navigator.of(context).push(
                                    SlideRightRoute(
                                        child: NavigationPage(),
                                        page: NavigationPage(),
                                        direction: AxisDirection.up),
                                  );
                                });
                              }
                              else{
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    load = false;
                                  });
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
                                " Se connecter ",
                                color: noir(),
                                tex: TailleText(context).soustitre * 0.9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              " ------------ ",
                              color: blanc().withOpacity(0.25),
                              tex: TailleText(context).contenu,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonOthers(
                              text: "Se connecter sans Compte",
                              color: blanc(),
                              x: NavigationPage(),
                              textcolor: noir(),
                              taille: 0.75
                            )
                          ],
                        )
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

  // verifie les champs de saisie
  Future<bool> validateAndSave() async {

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {

      if( validateEmail(emailController.text) ) {
        DInfo.toastError("Email non valid !");
        return false;
      }

      if( passwordController.text.length < 6 ) {
        DInfo.toastError("Mot de passe trop court !");
        return false;
      }
      user = await AuthController().signInWithEmailAndPassword(
          emailController.text, passwordController.text);


      if (user != null) {
        DInfo.toastSuccess(
            "Connexion etablie avec succes");
        return true;
      } else {
        DInfo.toastError("une erreur est survenue !");
        return false;
      }
    } else {
      DInfo.toastError("Remplissez les champs svp !");
      return false;
    }
  }
}
