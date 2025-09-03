// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:easy_saves/view/signup/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_verification_page.dart';

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

  bool validateEmail(String? email) {
    RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.08,
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
                    height: MediaQuery
                        .sizeOf(context)
                        .height * 0.07,
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
                    height: MediaQuery
                        .sizeOf(context)
                        .height * 0.025,
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
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.9,
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
                                        validator: (val) =>
                                        (val!.length < 6)
                                            ? "Mot de passe trop court"
                                            : null,
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
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.025,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                              onPressed: () async {
                                closeKeyboard(context);
                                setState(() => load = true);

                                if (_formKey.currentState!.validate()) {
                                  final result = await validateAndSave();

                                  if (result == LoginResult.success) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => NavigationPage()),
                                    );
                                  } else if (result == LoginResult.emailNotVerified) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
                                    );
                                  }
                                }

                                setState(() => load = false);
                              },
                              style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(orange()),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.05,
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
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.05,
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
  Future<LoginResult> validateAndSave() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      DInfo.toastError("Remplissez les champs svp !");
      return LoginResult.error;
    }

    if (validateEmail(email) || !neCommencePasParPonctuation(email)) {
      DInfo.toastError("Email non valide !");
      return LoginResult.error;
    }

    if (password.length < 6 || !neCommencePasParPonctuation(password)) {
      DInfo.toastError("Mot de passe incorrect !");
      return LoginResult.error;
    }

    // 👉 Essayer connexion
    User? tempUser = await AuthController().signInWithEmailAndPassword(email, password);

    if (tempUser == null) {
      DInfo.toastError("Email ou mot de passe incorrect !");
      return LoginResult.error;
    }

    await tempUser.reload();
    tempUser = FirebaseAuth.instance.currentUser;

    // 👉 Vérifier si email vérifié
    if (tempUser != null && !tempUser.emailVerified) {
      DInfo.toastError("Veuillez valider votre compte !");
      //await FirebaseAuth.instance.signOut(); // 🔥 Déconnecter directement
      return LoginResult.emailNotVerified;
    }


    user = tempUser;

    DInfo.toastSuccess("Connexion établie avec succès");
    return LoginResult.success;
  }


}

enum LoginResult {
  success,               // email vérifié → NavigationPage
  emailNotVerified,      // email pas vérifié → EmailVerificationScreen
  error                  // email/mdp incorrect ou champs invalides
}
