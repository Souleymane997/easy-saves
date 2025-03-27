// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../shared/colors.dart';
import '../shared/custom_text.dart';
import '../shared/slidepage.dart';
import '../view/navigationbody.dart';

class ButtonCard extends StatelessWidget {
  ButtonCard(
      {super.key,
      required this.text,
      required this.color,
      this.x,
      required this.textcolor,
      required this.taille});
  final String text;
  final Color color;
  final Color textcolor;
  Widget? x;
  final double taille;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * taille,
      child: ElevatedButton(
        onPressed: () {
          x != null
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: ((context) => x!)),
                )
              : null;
        },
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomText(
            text,
            color: textcolor,
            tex: TailleText(context).contenu,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ButtonOthers extends StatelessWidget {
  const ButtonOthers(
      {super.key,
      required this.text,
      required this.color, required this.x,
      required this.textcolor,
      required this.taille
      });
  final String text;
  final Color color;
  final Color textcolor;
  final Widget x;
  final double taille;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * taille,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            SlideRightRoute(
                child: NavigationPage(),
                page: NavigationPage(),
                direction: AxisDirection.up),
          );
        },
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                child: CustomText(
                  text,
                  color: textcolor,
                  tex: TailleText(context).soustitre * 0.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonOutlaned extends StatelessWidget {
  const ButtonOutlaned({super.key, required this.text, required this.bgColor, required this.a});

  final String text;
  final Color bgColor;
  final Future<bool>  a ;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        a ;
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor.withValues(alpha: 0.3),
        side: BorderSide(color: orangeFonce(), width: 2), // Custom border
      ),
      child: CustomText(
        text,
        color: noir(),
      ),
    );
  }
}