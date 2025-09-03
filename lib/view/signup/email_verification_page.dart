import 'dart:async';
import 'package:easy_saves/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/bg.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/slidepage.dart';
import '../../view/signup/auth.dart';
import '../../widget_tree.dart';
import '../navigationbody.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  late User? user = AuthController().currentUser;

  Timer? timer;



  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => checkEmailVerified(),
    );
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() => isEmailVerified = true);
      DInfo.toastSuccess("Email vérifié avec succès !");
      timer?.cancel();
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          const Background(),
          isEmailVerified
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                      CustomText(
                        " Verification de l'Email éffectuée ",
                        color: blanc(),
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CupertinoButton(
                          color: orange(),
                          child: CustomText(
                            'Continuer',
                            tex: TailleText(context).soustitre,
                            fontWeight: FontWeight.w700 ,

                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              SlideRightRoute(
                                  child: NavigationPage(),
                                  page: NavigationPage(),
                                  direction: AxisDirection.up),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Center(
                      child: CustomText(
                        'Check your Email',
                          tex: TailleText(context).titre,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: CustomText(
                          " Nous avons envoyé un lien à l'adresse mail  ${user?.email}.\nVerifier vos mails ou vos Spam ",
                            textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(child: CircularProgressIndicator( color:orange(),)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: CustomText(
                          'Verifying email....',
                          textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.175),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CupertinoButton(
                          color: CupertinoColors.inactiveGray,
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          child: CustomText(
                            'Annuler',
                            tex: TailleText(context).soustitre,
                            fontWeight: FontWeight.w700,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut(); // 🔥 Déconnexion
                            Navigator.of(context).pushAndRemoveUntil(
                              SlideRightRoute(
                                child: const WidgetTree(),
                                page: const WidgetTree(),
                                direction: AxisDirection.up,
                              ),
                                  (route) => false,
                            );
                          },
                        ),
                        CupertinoButton(
                          color: CupertinoColors.activeOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          child: CustomText(
                            'Renvoyer',
                            tex: TailleText(context).soustitre,
                            fontWeight: FontWeight.w700,
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                              DInfo.toastSuccess("Email de vérification renvoyé !");
                            } catch (e) {
                              DInfo.toastError("Erreur lors de l'envoi : $e");
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
        ],
      )),
    );
  }
}
