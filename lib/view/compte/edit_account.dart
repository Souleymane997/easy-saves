import 'dart:async';
import 'dart:io';

import 'package:easy_saves/shared/dialoguetoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../component/bg.dart';
import '../../component/textinputcard.dart';
import '../../models/user.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/function.dart';
import '../../shared/slidepage.dart';
import '../navigationbody.dart';
import '../signup/auth.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: noir(),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: orange().withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          title: CustomText(
            "Editer Mon Compte",
            tex: TailleText(context).titre * 1.3,
          ),
        ),
        body: Stack(children: [
          const Background(),
          Stack(children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              color: orange().withValues(alpha: 0.3),
            ),
            EditProfileScreen(),
          ]),
        ]));
  }
}

/* ###############################################################? */

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHidden = true;
  bool load = false;

  File? _avatar; // File to store the selected image
  late User? user;
  AppUserData userInfo = AppUserData(
      email: 'email', username:"username" , phone: 'phone', password: 'password');


  /* ###############################################################? */

  getData() async {
    user = AuthController().currentUser;
    if (user != null) {

      List<AppUserData> userInfos =
      await AuthController().getUserByEmail(user!.email);
      setState(() {
        userInfo = userInfos.first ;

        Timer(Duration(milliseconds:50 ), () {
          userNameController.text = userInfo.username ;
          phoneController.text = userInfo.phone ;
          emailController.text = userInfo.email;
          passwordController.text = "**********" ;
        });

      });
    }
    else{
      if (kDebugMode) {
        print("User null");
      }
    }
  }

/* ###############################################################? */

  Future<bool> editMyData() async {
    user = AuthController().currentUser;

    AppUserData data = AppUserData(email: userInfo.email, username: userNameController.text, phone: phoneController.text, password: userInfo.password) ;

    bool result = await AuthController().updateUserInfo(user!.uid , data);

    if(result){
      return true ;
    }
    else{
      DInfo.toastError("Erreur , reesayer svp!") ;
      if (kDebugMode) {
        print("User null");
      }
      return false ;
    }
  }


  /* ###############################################################? */

  @override
  void initState() {
    getData();
    super.initState();
  }

/* ###############################################################? */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.08),
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                  child: _avatar == null
                      ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                      : null,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          Form(
            child: Column(
              children: [
                LoginInput(
                    editController: userNameController,
                    type: TextInputType.text,
                    bgcolor: grisFonce(),
                    curscolor: blanc(),
                    hint: " Nom d'utilisateur "),
                const SizedBox(
                  height: 18,
                ),
                LoginInput(
                    editController: phoneController,
                    type: TextInputType.phone,
                    bgcolor: grisFonce(),
                    curscolor: blanc(),
                    hint: " Telephone"),
                const SizedBox(
                  height: 18,
                ),
                LoginInputReadOnly(
                    editController: emailController,
                    type: TextInputType.emailAddress,
                    bgcolor: grisLight().withValues(alpha: 0.3),
                    curscolor: blanc(),
                    hint: " email"),
                const SizedBox(
                  height: 18,
                ),
                LoginInput(
                    editController: passwordController,
                    type: TextInputType.text,
                    bgcolor: grisLight().withValues(alpha: 0.3),
                    curscolor: blanc(),
                    hint: " mot de passe"),
                const SizedBox(
                  height: 18,
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withValues(alpha: 0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: CustomText("Annuler"),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange(),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      loadPop(context) ;
                      bool res = await editMyData();
                      Timer(Duration(milliseconds:2900 ), () {
                       if(res){
                         DInfo.toastSuccess("Informations mis à jour");
                         Navigator.of(context).push(
                           SlideRightRoute(
                               child: NavigationPage(value: 2),
                               page: NavigationPage(value: 2),
                               direction: AxisDirection.left),
                         );
                       }
                      });
                    },
                    child: CustomText(
                      "Enregistrer",
                      color: noir(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


