// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: orange().withOpacity(0.1),
      child: Center(
        child: SpinKitCircle(
          color: blanc(),
          size: 50.0,
        ),
      ),
    );
  }
}

class LoadBack extends StatelessWidget {
  const LoadBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: noir().withOpacity(0.9));
  }
}
