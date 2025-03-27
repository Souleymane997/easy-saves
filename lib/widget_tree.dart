import 'package:easy_saves/view/signup/authenticate.dart';
import 'package:flutter/material.dart';

import 'view/navigationbody.dart';
import 'view/signup/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: AuthController().authStateChanges,
        builder: (context, snapshot){
      if(snapshot.hasData){
        return NavigationPage() ;
      }
      else{
        return const Authenticate() ;
      }
        }

    );
  }
}
