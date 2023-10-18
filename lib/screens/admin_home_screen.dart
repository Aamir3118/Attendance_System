// import 'package:attendance_app/screens/login_selection_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth user = FirebaseAuth.instance;
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//             onPressed: () async {
//               try {
//                 await user.signOut();
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => loginSelectionScreen()),
//                     (route) => false);
//               } catch (e) {
//                 e.toString();
//               }
//             },
//             icon: const Icon(Icons.exit_to_app, color: Colors.white),
//           )
//         ],
//       ),
//     );
//   }
// }
