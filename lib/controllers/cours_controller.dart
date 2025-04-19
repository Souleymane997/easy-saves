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
          .where('idUser', isEqualTo: idUser).where('archive', isEqualTo: false)
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
          'titre': item.titre.toLowerCase(),
          'prix': item.prix,
          'numParent': item.numParent,
          'archive':item.archive
        });

       // print("✅ Cours ajouté avec succès !");
        return true ;

      } catch (error) {
        //print(" Erreur lors de l'ajout du cours : $error");
        return false ;
      }
    }


  Future<bool> addCourseWithTransaction(String title) async {
    final firestore = FirebaseFirestore.instance;

    int val = 0 ;

    await firestore.runTransaction((transaction) async {
      var querySnapshot = await firestore
          .collection('Cours')
          .where('titre', isEqualTo: title.toLowerCase())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("Le titre existe déjà !");
        val = 1 ;
      }
      else{
        print("Le titre n'existe pas encore !");
        val = 0 ;
      }

    });

    if(val == 0){
      return false ;
    }
    else{
      return true ;
    }



  }



  Future<bool> archiveCours(String coursId, CoursModel item, bool val) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Utilisateur non connecté !");
      }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('Cours').doc(coursId).update({
        'idUser': item.idUser,
        'titre': item.titre,
        'prix': item.prix,
        'numParent': item.numParent,
        'archive':val
      }) ;
      if(val){
        print("Archivé avec succès !");
      }
      else{
        print("Desarchivé avec succès !");
      }

      return true ;
    } catch (error) {
      print(" Erreur lors de l'archivage du cours : $error");
      return false ;
    }
  }



  Future<bool> deleteCours(String idCours ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Utilisateur non connecté !");
      }
      // Référence Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query all seances linked to the course
      final querySnapshot = await firestore
          .collection('Seance')
          .where('idCours', isEqualTo: idCours)
          .get();

      // Delete each matching seance
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      await firestore.collection('Cours').doc(idCours).delete();
      print("✅ Cours supprimé avec succès !");

      return true ;

    } catch (error) {
      print(" Erreur lors de la suppression : $error");
      return false ;
    }
  }



  /// Check if a user is signed in
  bool get isSignedIn => currentUser != null;
}
