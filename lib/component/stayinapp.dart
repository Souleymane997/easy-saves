import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../shared/colors.dart';
import '../shared/custom_text.dart';

class StayInApp extends StatelessWidget {
  const StayInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
            child: Row(
              children: [
                Flexible(
                  child: CustomText(
                    " Easy SAVE",
                    tex: TailleText(context).soustitre,
                    color: blanc(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}

class StayButton extends StatelessWidget {
  const StayButton(
      {super.key,
      required this.text,
      required this.exit,
      required this.val,
      required this.color});
  final String text;
  final Function exit;
  final bool val;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),
          onPressed: () {
            if (val) {
              Navigator.pop(context, true);
              SystemNavigator.pop();
              exit;
            } else {
              Navigator.pop(context, false);
            }
          },
          child: CustomText(
            text,
            color: blanc(),
            tex: TailleText(context).contenu,
          )),
    );
  }
}


onWillPopUp(BuildContext context, Function exit) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: orange().withValues(alpha: 0.7),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: StayInApp(),
          actions: [
            Column(
              children: [
                StayButton(
                  text: "Restez dans l'application !",
                  exit: exit,
                  val: false,
                  color: orangeFonce().withValues(alpha: 0.5),
                ),
                Container(
                  height: 5,
                ),
                StayButton(
                  text: "Quittez l'application ! ",
                  exit: exit,
                  val: true,
                  color: noir().withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        );
      });
}
