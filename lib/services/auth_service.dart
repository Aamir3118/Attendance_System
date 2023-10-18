// import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //bool isAdmin = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    UserCredential authResult = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Future<void> signInAdminWithEmailAndPassword(
  //     String email, String password, String username) async {
  //   UserCredential authResult =
  //       await auth.signInWithEmailAndPassword(email: email, password: password);
  //   User? user = authResult.user;
  //   // Check if the user exists in Firestore using the user's UID.
  //   await FirebaseFirestore.instance.collection('Admin').doc(user!.uid).set({
  //     'email': email,
  //     'username': username,
  //   });

  //   // If the user doesn't exist in Firestore or is not an admin, throw an exception.
  // }
  String? getCurrentUserUID() {
    User? user = auth.currentUser;
    return user?.uid;
  }
}
