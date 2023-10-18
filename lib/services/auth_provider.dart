// import 'package:attendance_app/screens/login_selection_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../screens/admin_home_screen.dart';
// import '../screens/tabs_screen.dart';

// class AuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User? _user;
//   User? get user => _user;

//   Future<void> checkUserRoleAndNavigate(BuildContext context) async {
//     _user = _auth.currentUser;

//     if (_user != null) {
//       DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
//           .collection('Admin')
//           .doc(_user!.uid)
//           .get();

//       if (adminSnapshot.exists) {
//         // If the user is an admin, navigate to AdminHomeScreen.
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AdminHomeScreen()),
//         );
//       } else {
//         DocumentSnapshot facultySnapshot = await FirebaseFirestore.instance
//             .collection('faculties')
//             .doc(_user!.uid)
//             .get();

//         if (facultySnapshot.exists) {
//           // If the user is a faculty member, navigate to TabsScreen.
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => TabsScreen()),
//           );
//         } else {
//           // If the user is neither admin nor faculty, navigate to LoginSelectionScreen.
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => loginSelectionScreen()),
//           );
//         }
//       }
//     } else {
//       // If no user is authenticated, navigate to LoginSelectionScreen.
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => loginSelectionScreen()),
//       );
//     }
//   }
// }
