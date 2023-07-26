// import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? authResult;
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    authResult = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult!.user;
    await FirebaseFirestore.instance.collection('faculties').doc(user!.uid).set(
      {
        'email': email,
        'password': password,
      },
    );
  }
}
//   Future signIn(String email, String password) async {
//     try {
//       FocusManager.instance.primaryFocus?.unfocus();

//       if (formKey.currentState!.validate()) {
//         setState(() {
//           isLoading = true;
//         });
//         authResult = await auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         User? user = authResult!.user;
//         await FirebaseFirestore.instance
//             .collection('faculties')
//             .doc(user!.uid)
//             .set(
//           {
//             'email': email,
//             'password': password,
//           },
//         );
//       }
//     } on FirebaseAuthException catch (error) {
//       var errorMessage = 'Authentication failed!';
//       if (error.code == 'wrong-password') {
//         errorMessage = 'Invalid password.';
//       } else if (error.code == 'email-already-exists') {
//         errorMessage = 'This email address is already in use.';
//       } else if (error.code == 'invalid-email') {
//         errorMessage = 'This is not a valid email address.';
//       } else if (error.code == 'user-not-found') {
//         errorMessage = 'Could not find a user with that email.';
//       }
//       _showErrorDialog(errorMessage);
//       setState(() {
//         isLoading = false;
//       });
//     } catch (err) {
//       const errorMessage =
//           'Could not authenticate you. Please try again later!';

//       _showErrorDialog(errorMessage);

//       setState(() {
//         isLoading = false;
//       });
//       print(err);
//     }
//   }

  

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('An Error Occurred!'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text('Ok'),
//           ),
//         ],
//       ),
//     );
//   }
// }
