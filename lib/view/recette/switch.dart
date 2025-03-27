
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../component/bg.dart';
import '../../component/cardCours.dart';
import '../../component/headers_component.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/function.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: noir(),
      body: Stack(children: [
        const Background(),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            DetailsHeaders(),
            Expanded(child: GridCours()),
          ],
        )
      ]),
    );
  }
}

class GridCours extends StatelessWidget {
  const GridCours({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 2,
          crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.all(5.0),
          child: CardCoursRecette(),
        );
      },
    );
  }
}




class DetailsHeaders extends StatefulWidget {
  const DetailsHeaders({super.key});


  @override
  State<DetailsHeaders> createState() => _DetailsHeadersState();
}

class _DetailsHeadersState extends State<DetailsHeaders> {

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 7));

  void showBottomDatePicker(BuildContext context, DateTime dateData , bool dateLevel) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: blanc(),
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                backgroundColor: blanc(),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: dateData,
                minimumDate: DateTime(2015),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (DateTime date) {
                  setState(() {
                    dateData = DateTime(date.year, date.month, date.day);
                    if(dateLevel) {
                      startDate = dateData ;
                    }
                    else{
                      endDate = dateData ;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CupertinoButton(
                color: orange(),
                child: CustomText('Fait',color: noir(),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: marroon(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                "Recette Cumulée ",
                family: 'RobotoItalic',
                tex: TailleText(context).titre * 1.3,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: (){
                    showBottomDatePicker(context, startDate,true) ;
                  },
                  child: DatePacket(date: formatMonthDay(startDate))),
              InkWell(
                  onTap: (){
                    showBottomDatePicker(context, endDate,false) ;
                  },
                  child: DatePacket(date: formatMonthDay(endDate))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              "Mois de ${monthName(startDate.month)} : 57000 F",
              color: blanc(),
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SortPacket(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





