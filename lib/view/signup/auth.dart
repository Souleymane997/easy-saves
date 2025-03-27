// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';
import '../../shared/dialoguetoast.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Create a new user with email, username, password, and phone
  Future<User?> signUpWithEmailAndDetails(
      String email, String username, String password, String phone) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save additional details to Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'username': username,
          'email': email,
          'phone': phone,
          'password': password
        });
      }

      return user;
    } catch (e) {
      debugPrint('Sign Up Error: $e');
      return null;
    }
  }

  /// Sign in a user with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DInfo.toastError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        DInfo.toastError('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }



  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign Out Error: $e');
    }
  }

  /// Send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Password Reset Error: $e');
    }
  }

  Future<bool> updateUserInfo(String userId, AppUserData data) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('Users').doc(userId).update(data.toJson());
      //print("Infos mises à jour avec succès !");
      return true ;
    } catch (e) {
     // print("Erreur lors de la mise à jour : $e");
      return false ;
    }

  }


  Future<List<AppUserData>> getUserByEmail(String? email) async {
    List<AppUserData> result = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {

          // Extraction des documents
          List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          // Conversion en objets AppUserData
          result = documents.map((e) => AppUserData.fromJson(e)).toList();
          print(result.first.email);

          return result ;
        }
      } else {
        print("Aucun utilisateur trouvé avec cet email.");
        return result ;
      }
    } catch (e) {
      print("Erreur lors de la récupération par email : $e");
    }
    return result ;
  }


  /// Check if a user is signed in
  bool get isSignedIn => currentUser != null;
}
