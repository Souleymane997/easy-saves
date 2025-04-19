// ignore_for_file: avoid_print

import 'dart:async';

import 'package:easy_saves/models/user.dart';
import 'package:easy_saves/view/compte/archive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

import '../../component/bg.dart';
import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/dialoguetoast.dart';
import '../../shared/loading.dart';
import '../../shared/slidepage.dart';
import '../../widget_tree.dart';
import '../signup/auth.dart';
import 'edit_account.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late User? user;
  AppUserData userInfo = AppUserData(
      email: 'email', username:"username" , phone: 'phone', password: 'password');
  bool exit = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: noir(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: orange().withValues(alpha: 0.3),
        foregroundColor: Colors.white,
        title: CustomText(
                  "Mon Compte",
                  tex: TailleText(context).titre * 1.3,
                ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0 , top: 2.0),
                child: IconButton(onPressed: (){ showPop(context);}, icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),

                    child: Center(child: Icon(Icons.logout , size: 30,)))),
              )
            ],
          )
        ],
      ),
      body: exit
          ? Stack(children: [
              const Background(),
              profilScreen(),
            ])
          : Loading()
    );


  }


  showPop(BuildContext context){

    showAdaptiveActionSheet(
      context: context,
      isDismissible: true,
      bottomSheetColor: Colors.black87,
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomText('Se deconnecter ' , tex: TailleText(context).soustitre * 1.4 , color: Colors.red, fontWeight: FontWeight.w700,),
                ),
                Divider(), // Line Divider
              ],
            ),
            onPressed: (_) {
              setState(() {
                exit = false;
              });
              Navigator.pop(context);

              Timer(const Duration(milliseconds: 1500), () async {
                await AuthController().signOut();
                DInfo.toastSuccess("Deconnecté avec succès");
              });
              Timer(const Duration(milliseconds: 2500), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const WidgetTree())),
                );
              });

            }




        ),
      ],

      cancelAction: CancelAction(title: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text('Annuler'),
      )),// onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  void showPopDeconnect(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.red,
      context: context,
      builder: (BuildContext contexte) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    size: 30,
                    weight: 4,
                  ),
                  title: CustomText(
                    'Se deconnecter',
                    color: noir(),
                    tex: TailleText(context).soustitre,
                    fontWeight: FontWeight.w700,
                  ),
                  onTap: () async {
                    setState(() {
                      exit = false;
                    });
                    Navigator.pop(contexte);

                    Timer(const Duration(milliseconds: 1500), () async {
                      await AuthController().signOut();
                      DInfo.toastSuccess("Deconnecté avec succès");
                    });
                    Timer(const Duration(milliseconds: 2500), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const WidgetTree())),
                      );
                    });
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  getData() async {
    user = AuthController().currentUser;
    if (user != null) {

      List<AppUserData> userInfos =
      await AuthController().getUserByEmail(user!.email);
      setState(() {
        userInfo = userInfos.first ;
      });
    }
    else{
      print("User null");
    }
  }

  Widget profilScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                color: orange().withValues(alpha: 0.3),
              ),
              Center(
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person,
                          size: 60, color: Colors.grey[700])))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomText(
              userInfo.username.toUpperCase(),
              tex: TailleText(context).titre,
              color: blanc(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          Info(
            infoKey: "Nom d'Utilisateur",
            info: userInfo.username,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          Info(
            infoKey: "Adresse mail",
            info: userInfo.email,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          Info(
            infoKey: "Telephone",
            info: userInfo.phone,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          const Info(
            infoKey: "Mot de passe",
            info: "**********",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 1,
              color: blanc().withValues(alpha: 0.1),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
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
                onPressed: () {
                  Navigator.of(context).push(
                    SlideRightRoute(
                        child: EditAccount(),
                        page: EditAccount(),
                        direction: AxisDirection.left),
                  );
                },
                child: CustomText(
                  "Edit profile",
                  color: noir(),
                ),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeFonce(),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    SlideRightRoute(
                        child: ArchivePage(),
                        page: ArchivePage(),
                        direction: AxisDirection.left),
                  );
                },
                child: CustomText(
                  "Voir mes archives",
                  color: noir(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// ******************************************

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0 , right: 5.0 , top: 3.0 , bottom: 3.0),
            child: CustomText(
              infoKey,
              color: blanc(),
              tex: TailleText(context).soustitre,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0 , right: 5.0 , top: 3.0 , bottom: 3.0),
            child: CustomText(
              info,
              color: blanc().withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              tex: TailleText(context).soustitre,
            ),
          ),
        ],
      ),
    );
  }
}
