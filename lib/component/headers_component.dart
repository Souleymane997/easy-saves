
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/colors.dart';
import '../shared/custom_text.dart';

class DatePacket extends StatelessWidget {
  const DatePacket({super.key, required this.date , });
  final String date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: orange(), width: 1), // Border color and size
          borderRadius: BorderRadius.circular(8),         // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0 , right: 3.0),
                child: Icon(Icons.date_range_outlined, color: blanc(), size: 35,),
              ) ,
              Padding(
                padding: const EdgeInsets.only(left: 3.0 , right: 3.0),
                child: CustomText(date , color: blanc(), tex:TailleText(context ).soustitre ,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SortPacket extends StatelessWidget {
  const SortPacket({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: orange(), width: 1), // Border color and size
          borderRadius: BorderRadius.circular(8),         // Rounded corners
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(3.0),
              color: orange(),
              onPressed: (){},
              child: Row(
                children: [
                  CustomText(
                    "Filtrer",
                    color: noir(),
                    tex: TailleText(context).soustitre,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


