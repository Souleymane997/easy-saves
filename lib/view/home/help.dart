import 'package:easy_saves/shared/colors.dart';
import 'package:flutter/material.dart';

import '../../component/bg.dart';
import '../compte/archive.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key, required this.val});
  final int val ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          const Background(),
          ListView(
          padding: EdgeInsets.all(16),
          children: [
            ArrowBack(val: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help, color: blanc(),),
                Text("Aide & Utilisation", style: TextStyle( color: blanc(), fontSize: 20, fontFamily: 'RobotoItalic'),),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.info, color: blanc(),),
                  Text("Gestion des Cours", style: TextStyle(color: blanc()),),
                ],
              ),
                subtitle: Text('\nVous pouvez organiser vos cours, suivre leur progrèssion , et interagir avec les parents d\'eleves.',) ,
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(Icons.book, color: blanc(),),
                  Text("Creation de cours", style: TextStyle(color: blanc()),),
                ],
              ),
              subtitle: Text('\nVous pouvez ajouter vos cours en cliquant sur le bouton "+" et remplir le formulaire',) ,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.delete, color: blanc(),),
                  Text("Suppression et Archivage de cours", style: TextStyle(color: blanc()),),
                ],
              ),
              subtitle: Text('\nVous pouvez supprimer ou archiver vos cours dans Recette en faisant un long press sur le Cours.',) ,
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(Icons.book, color: blanc(),),
                  Text("Gestion des seances", style: TextStyle(color: blanc()),),
                ],
              ),
              subtitle: Text('\nVous pouvez ajouter vos seances et suivre leur progression en faisant un long press sur le Cours.',) ,
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(Icons.delete, color: blanc(),),
                  Text("Suppression des seances", style: TextStyle(color: blanc()),),
                ],
              ),
              subtitle: Text('\nVous pouvez supprimer vos seances  en faisant glisser la seance vers la gauche.',) ,
            ),

            ListTile(
              title: Row(
                children: [
                  Icon(Icons.folder_zip_rounded, color: blanc(),),
                  Text("Desarchivage de cours ", style: TextStyle(color: blanc()),),
                ],
              ),
              subtitle: Text('\nVous pouvez desarchiver vos cours en cliquant sur le bouton "voir mes archives" ',) ,
            ),


          ],
        ),
    ]
      ),
    );
  }
}
