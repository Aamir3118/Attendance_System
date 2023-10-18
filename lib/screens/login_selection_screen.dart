// import 'package:attendance_app/screens/admin_signin_screen.dart';
// import 'package:attendance_app/screens/signin_screen.dart';
// import 'package:flutter/material.dart';

// class loginSelectionScreen extends StatelessWidget {
//   const loginSelectionScreen({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login Selection')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             SignInScreen())); // Navigate to FacultySignInScreen
//               },
//               child: Text('Faculty Login'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             AdminSignInScreen())); // Navigate to AdminSignInScreen
//               },
//               child: Text('Admin Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
