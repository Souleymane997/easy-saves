// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'email_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../component/bg.dart';
import '../../component/buttoncard.dart';
import '../../component/stayinapp.dart';
import '../../component/textinputcard.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/function.dart';
import '../../shared/loading.dart';
import 'auth.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.toggleView});
  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  ////**********************************************/
  // Variables

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User? user = AuthController().currentUser;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();


  bool isHidden = true;
  bool obscureConfirmPassword = true;
  bool load = false;

  late String keyUser;
  bool exitValue = true;

  ////**********************************************/
  // Function
  exit() {
    setState(() {
      exitValue = true;
    });
    debugPrint(exitValue.toString());
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




  ////**********************************************///




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
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23.0),
                      color: orange().withOpacity(0.25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: ButtonCard(
                          text: "Se connecter",
                          color: noir(),
                          x: Login(toggleView: widget.toggleView),
                          textcolor: orange(),
                          taille: 0.3,
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: ButtonCard(
                          text: "Créer compte",
                          color: orange(),
                          x: SignUp(toggleView: widget.toggleView),
                          textcolor: noir(),
                          taille: 0.3,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.04,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      CustomText(
                        "Créer un Compte",
                        tex: 2.3,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.04,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        LoginInput(
                            editController: userNameController,
                            type: TextInputType.text,
                            bgcolor: grisFonce(),
                            curscolor: blanc(),
                            hint: " Nom d'utilisateur "),
                        const SizedBox(
                          height: 18,
                        ),
                        LoginInput(
                            editController: phoneController,
                            type: TextInputType.phone,
                            bgcolor: grisFonce(),
                            curscolor: blanc(),
                            hint: "Telephone"),
                        const SizedBox(
                          height: 18,
                        ),
                        LoginInput(
                            editController: emailController,
                            type: TextInputType.emailAddress,
                            bgcolor: grisFonce(),
                            curscolor: blanc(),
                            hint: " Email "),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 1, bottom: 8),
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
                                        obscureText: isHidden,
                                        validator: (val) => (val!.length < 6)
                                            ? "Mot de passe trop court"
                                            : null,
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
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 1, bottom: 8),
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
                                        controller: passwordConfirmController,
                                        keyboardType: TextInputType.text,
                                        onSaved: (onSavedval) {
                                          passwordConfirmController.text = onSavedval!;
                                        },
                                        obscureText: obscureConfirmPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez confirmer le mot de passe";
                                          }
                                          if (value != passwordController.text) {
                                            return "Les mots de passe ne correspondent pas";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                          color: blanc(),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: " Confirmer Mot de passe ",
                                          hintStyle: TextStyle(
                                              color: blanc().withOpacity(0.25),
                                              fontSize: 12),
                                          suffixIcon: IconButton(
                                            color:
                                            (obscureConfirmPassword) ? gris() : orange(),
                                            icon: Icon(obscureConfirmPassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                obscureConfirmPassword = !obscureConfirmPassword;
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
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                            onPressed: () async {
                              closeKeyboard(context);
                              setState(() {
                                load = true;
                              });
                              _formKey.currentState!.validate();

                              if (await validateAndSave()) {
                                Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    load = false;
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => EmailVerificationScreen()));

                                });
                              } else {
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
                                " Créer compte ",
                                color: noir(),
                                tex: TailleText(context).soustitre * 0.9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        userNameController.text.isNotEmpty) {

      print(neCommencePasParPonctuation(userNameController.text)) ;

      if (!neCommencePasParPonctuation(userNameController.text)) {
        DInfo.toastError("Username non valid !");
        return false;
      }

      if (validateEmail(emailController.text) || !neCommencePasParPonctuation(emailController.text)) {
        DInfo.toastError("Email non valid !");
        return false;
      }

      if (passwordController.text.length < 6 ) {
        DInfo.toastError("Mot de passe trop court ! 6 lettres au moins .");
        return false;
      }

      if (!neCommencePasParPonctuation(passwordController.text)) {
        DInfo.toastError("Mot de passe invalid !");
        return false;
      }

      if (!neCommencePasParPonctuation(phoneController.text)) {
        DInfo.toastError("Telephone Incorrect !");
        return false;
      }

      if (phoneController.text.length > 8 ||  phoneController.text.length < 8 ) {
        DInfo.toastError("Telephone Incorrect !");
        return false;
      }


      user = await AuthController().signUpWithEmailAndDetails(
          emailController.text,
          userNameController.text,
          passwordController.text,
          phoneController.text);



      if (user != null) {
        //final uid = user?.uid;
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
