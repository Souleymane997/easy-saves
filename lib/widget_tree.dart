import 'package:easy_saves/view/signup/authenticate.dart';
import 'package:flutter/material.dart';

import 'view/navigationbody.dart';
import 'view/signup/auth.dart';
import 'view/signup/email_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthController().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Affiche un écran de chargement pendant que Firebase vérifie l'état
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;

          // Si l'email n'est pas vérifié, bloque sur EmailVerificationScreen
          if (!user.emailVerified) {
            return const EmailVerificationScreen();
          }

          // Email vérifié → NavigationPage
          return NavigationPage();
        }

        // Pas connecté → Authenticate
        return const Authenticate();
      },
    );
  }
}
