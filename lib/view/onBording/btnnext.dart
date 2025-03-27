import 'package:flutter/material.dart';

import '../../shared/colors.dart';
import '../../shared/custom_text.dart';

class BtnNext extends StatelessWidget {
  const BtnNext({super.key, required this.text, required this.fin});
  final String text;
  final bool fin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: orange(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
        child: CustomText(
          text,
          tex: 1.0,
          fontWeight: FontWeight.w500,
          color: noir(),
        ),
      ),
    );
  }
}
