// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../shared/colors.dart';
import '../../shared/custom_text.dart';

class PageViewContainer extends StatelessWidget {
  const PageViewContainer({
    super.key,
    required this.pathImage,
    required this.text,
    required this.text2,
  });

  final String pathImage;
  final String text;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              pathImage,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 350.0,
                  child: CustomText(
                    text,
                    tex: 1.5,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 250.0,
                  child: CustomText(
                    text2,
                    tex: 1.0,
                    textAlign: TextAlign.center,
                    color: blanc().withOpacity(0.25),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}
