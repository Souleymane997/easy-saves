// ignore_for_file: avoid_print

import 'package:easy_saves/models/seance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeanceController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<List<SeanceModel>> getListTri(String? idCours , String dateDebut , String dateFin) async {
      List<SeanceModel> result = [];

      print(dateDebut) ;
      print(dateFin) ;
      try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Seance')
          .where('idCours', isEqualTo: idCours)
          .where('date', isGreaterThanOrEqualTo: dateDebut)
          .where('date', isLessThanOrEqualTo: dateFin)
          .get();

          if (querySnapshot.docs.isNotEmpty) {
          // Extraction des documents
          List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
          }).toList();

          // Conversion en objets AppUserData
          result = documents.map((e) => SeanceModel.fromJson(e)).toList();
          //print(result.first.idCours);
          return result ;

      } else {
          print("0 Seance .");
          return result ;
      }
      } catch (e) {
          print("Erreur : $e");
      }
      return result ;
  }

  Future<List<SeanceModel>> getListSeance(String? idCours) async {
    List<SeanceModel> result = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Seance')
          .where('idCours', isEqualTo: idCours)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extraction des documents
        List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();

        // Conversion en objets AppUserData
        result = documents.map((e) => SeanceModel.fromJson(e)).toList();
        //print(result.first.idCours);
        return result ;

      } else {
        print("0 Seance .");
        return result ;
      }
    } catch (e) {
      print("Erreur : $e");
    }
    return result ;
  }




  Future<List<String>> getListIDSeance(String? idCours ) async {
    List<String> result = [];
    QuerySnapshot querySnapshot ;
    try {
        querySnapshot = await FirebaseFirestore.instance
            .collection('Seance')
            .where('idCours', isEqualTo: idCours)
            .get();

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

  Future<bool> updateSeance(String seanceId, int newDuree, String newDate) async {
    try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          throw Exception("Utilisateur non connecté !");
        }
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('Seance').doc(seanceId).update({
          'duree': newDuree,
          'date': newDate,
        }) ;
        print("Séance mise à jour avec succès !");
        return true ;
    } catch (error) {
      print(" Erreur lors de l'ajout dee la seance : $error");
      return false ;
    }
  }

  Future<bool> addSeance(SeanceModel item ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Utilisateur non connecté !");
      }
      // Référence Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('Seance').add({
        'idCours': item.idCours,
        'duree': item.duree,
        'date':item.date
      });

      //print("✅ Seance ajouté avec succès !");
      return true ;

    } catch (error) {
      //print(" Erreur lors de l'ajout dee la seance : $error");
      return false ;
    }
  }

  Future<bool> deleteSeance(String idSeance ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Utilisateur non connecté !");
      }
      // Référence Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('Seance').doc(idSeance).delete();

      print("✅ Seance supprimé avec succès !");
      return true ;

    } catch (error) {
      //print(" Erreur lors de l'ajout dee la seance : $error");
      return false ;
    }
  }





}
