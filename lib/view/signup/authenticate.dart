import 'package:flutter/material.dart';
import 'login.dart';
import 'sign.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (showSignIn)? Login( toggleView : toggleView ) :  SignUp(toggleView : toggleView),
    );
  }
}
