import 'package:attendance_app/screens/signin_screen.dart';
import 'package:attendance_app/screens/tabs_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, facultySnapshot) {
          String? facultyUid = AuthService().getCurrentUserUID();

          User? user = facultySnapshot.data;
          //if (adminSnapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('faculties')
                  .doc(facultyUid)
                  .get(),
              builder: (ctx, facultyDataSnapshot) {
                if (facultyDataSnapshot.data != null &&
                    facultyDataSnapshot.data!.exists) {
                  print("Faculty");
                  return TabsScreen();
                } else {
                  return SignInScreen();
                }
              });
        });
    // StreamBuilder(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (ctx, facultySnapshot) {
    //       //String? adminUid = AuthService().getCurrentUserUID();

    //       User? user = facultySnapshot.data;
    //       //if (adminSnapshot.hasData) {
    //       return FutureBuilder<DocumentSnapshot>(
    //           future: FirebaseFirestore.instance
    //               .collection('faculties')
    //               .doc(user!.uid)
    //               .get(),
    //           builder: (ctx, facultyDataSnapshot) {
    //             if (facultyDataSnapshot.data != null &&
    //                 facultyDataSnapshot.data!.exists) {
    //               print("Faculty");
    //               return TabsScreen();
    //             } else {
    //               return SignInScreen();
    //             }
    //           });
    //     });

    //   // Data not found in "Admin" collection, show a dialog.
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: Text('Data Not Found'),
    //       content:
    //           Text('Data not found in the "Admin" collection.'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(ctx).pop(); // Close the dialog.
    //             Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => SignInScreen()),
    //             ); // Navigate back to SignInScreen.
    //           },
    //           child: Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    //   return Container(); // Return an empty container while showing the dialog.
    // }
  }
}
