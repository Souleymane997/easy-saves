// ignore_for_file: avoid_print

import 'package:easy_saves/models/cours_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<List<String>> getListIDCours(String? idUser , String? searchQuery) async {
    List<String> result = [];
    QuerySnapshot querySnapshot ;
    try {

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
         querySnapshot = await FirebaseFirestore.instance
            .collection('Cours')
            .where('idUser', isEqualTo: idUser)
            .where('titre', arrayContains: searchQuery)
            .get();
      }
      else{
        querySnapshot = await FirebaseFirestore.instance
            .collection('Cours')
            .where('idUser', isEqualTo: idUser)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          //print("L'ID du document est : ${doc.id}");
          result.add(doc.id.toString()) ;
        }
      } else {
        print("Aucun document trouvé.");
      }
      return result ;

    } catch (e) {
      print("Erreur : $e");
    }
    return result ;
  }




  Future<List<CoursModel>> getListCours(String? idUser) async {
    List<CoursModel> result = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cours')
          .where('idUser', isEqualTo: idUser)
          .get();

          // Extraction des documents
          List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          // Conversion en objets AppUserData
          result = documents.map((e) => CoursModel.fromJson(e)).toList();
          //print(result.first.titre);
          return result ;
    } catch (e) {
      print("Erreur : $e");
    }
    return result ;
  }

  /// Create a new user with email, username, password, and phone
  Future<bool> addCours(CoursModel item ) async {

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          throw Exception("Utilisateur non connecté !");
        }
        // Référence Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('Cours').add({
          'idUser': item.idUser,
          'titre': item.titre,
          'prix': item.prix,
          'numParent': item.numParent
        });

       // print("✅ Cours ajouté avec succès !");
        return true ;

      } catch (error) {
        //print(" Erreur lors de l'ajout du cours : $error");
        return false ;
      }
    }


  /// Check if a user is signed in
  bool get isSignedIn => currentUser != null;
}
