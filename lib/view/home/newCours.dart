// ignore_for_file: file_names

import 'dart:async';

import 'package:easy_saves/controllers/cours_controller.dart';
import 'package:easy_saves/models/cours_model.dart';
import 'package:easy_saves/shared/function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../component/bg.dart';
import '../../component/textinputcard.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/slidepage.dart';
import '../navigationbody.dart';
import '../signup/auth.dart';

class NewCoursPage extends StatefulWidget {
  const NewCoursPage({super.key});

  @override
  State<NewCoursPage> createState() => _NewCoursPageState();
}

class _NewCoursPageState extends State<NewCoursPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController intituleController = TextEditingController();
  TextEditingController tarifController = TextEditingController();
  TextEditingController phoneParentController = TextEditingController();


  late User? user;

  getIdUser() async {
    user = AuthController().currentUser;
    if (user != null) {
      if (kDebugMode) {
        print(user!.uid);
      }
    }
  }



  @override
  void initState() {
    getIdUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              ContainerInputState(
                  controllerEdit: intituleController,
                  input: TextInputType.text,
                  pathIcon: 'assets/icon/logo.png',
                  hintText: "  Intitule du cours "),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ContainerInputState(
                  controllerEdit: tarifController,
                  input: TextInputType.number,
                  pathIcon: 'assets/icon/coins.png',
                  hintText: "  Tarif de la séance par heure "),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ContainerInputState(
                  controllerEdit: phoneParentController,
                  input: TextInputType.phone,
                  pathIcon: 'assets/icon/phone.png',
                  hintText: "  Numero d'un parent "),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  onPressed: () async {
                  loadPop(context) ;
                  bool res = await validateAndSave() ;
                  Timer(Duration(milliseconds:2900 ), () {
                    if(res){
                      DInfo.toastSuccess("Cours ajouté avec success");
                      Navigator.pop(context) ;
                      Navigator.of(context).push(
                        SlideRightRoute(
                            child: NavigationPage(value: 0),
                            page: NavigationPage(value: 0),
                            direction: AxisDirection.left),
                      );
                    }
                    else{
                      Navigator.pop(context) ;
                    }
                  });
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(orange()),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CustomText(
                      " Enregistrer Cours ",
                      color: noir(),
                      tex: TailleText(context).soustitre * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 15
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.highlight_off_outlined , color: blanc(), size: 40,)
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10
          ),
        ],
      ),
    );
  }

  // verifie les champs de saisie
  Future<bool> validateAndSave() async {

    if (intituleController.text.isNotEmpty &&
        tarifController.text.isNotEmpty &&
        phoneParentController.text.isNotEmpty) {

      if (!neCommencePasParPonctuation(intituleController.text.trim())) {
        DInfo.toastError("Intitulé non valide !");
        return false;
      }

      if (!neCommencePasParPonctuation(tarifController.text.trim())) {
        DInfo.toastError("Tarif non valide !");
        return false;
      }

      if (!neCommencePasParPonctuation(phoneParentController.text.trim())) {
        DInfo.toastError("Telephone non valide !");
        return false;
      }

      if (phoneParentController.text.length > 8 ||  phoneParentController.text.length < 8 ) {
        DInfo.toastError("Telephone Incorrect !");
        return false;
      }

      bool checked = await CoursController().addCourseWithTransaction(intituleController.text) ;

      if(checked == true ){
        DInfo.toastError("Ce Cours existe déjà ! Changez le titre svp  ");
        return false;
      }
      else{

        CoursModel newCours = CoursModel(idUser:user!.uid, titre: intituleController.text, prix: int.parse(tarifController.text),
            numParent: phoneParentController.text , archive: false) ;

        bool res = await CoursController().addCours(newCours) ;
        if (res) {
          return true;
        } else {
          DInfo.toastError("une erreur est survenue !");
          return false;
        }

      }

    } else {
      DInfo.toastError("Remplissez les champs svp !");
      return false;
    }
  }
}


void showNewsCours(BuildContext context) {
  showModalBottomSheet(
    context: context,
    barrierLabel: "Barrier",
    elevation: 8.0,
    sheetAnimationStyle: AnimationStyle(curve: Curves.easeIn, ),
    backgroundColor: noir(),
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      side: BorderSide(
        color: orange(),
        width: 1,
      ),
    ),
    builder: (BuildContext context) {
      final viewInsets = MediaQuery.of(context).viewInsets ;

      return Padding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: MediaQuery.of(context).size.height * 0.58,
          child: Stack(children: [
              const Background(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove,color: blanc(), size: 30,),
                    Center(
                      child: CustomText(
                        " Ajouter un nouveau cours ",
                        tex: TailleText(context).titre * 1.2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const NewCoursPage(),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ]),
          ),

      );
    },
  );
}
