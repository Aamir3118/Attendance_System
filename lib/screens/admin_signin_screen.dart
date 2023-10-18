// import 'package:attendance_app/screens/signin_screen.dart';
// import 'package:attendance_app/services/auth_service.dart';
// import 'package:attendance_app/widgets/widgets.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../services/auth_state_notifier.dart';

// class AdminSignInScreen extends StatefulWidget {
//   const AdminSignInScreen({super.key});

//   @override
//   State<AdminSignInScreen> createState() => _AdminSignInScreenState();
// }

// class _AdminSignInScreenState extends State<AdminSignInScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final usernameController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   var isLoading = false;
//   final AuthService authService = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     "Sign In",
//                     style: TextStyle(color: Colors.deepPurple, fontSize: 30),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Form(
//                     key: formKey,
//                     child: Column(
//                       children: <Widget>[
//                         textFormField(
//                           usernameController,
//                           "Enter Username",
//                           false,
//                           TextInputType.name,
//                           (value) {
//                             if (value!.isEmpty) {
//                               return "Please enter username";
//                             }
//                             return null;
//                           },
//                         ),
//                         textFormField(
//                           emailController,
//                           "Enter Email",
//                           false,
//                           TextInputType.emailAddress,
//                           (value) {
//                             final bool isValid =
//                                 EmailValidator.validate(value!);
//                             if (value.isEmpty) {
//                               return "Please enter email";
//                             } else if (!isValid) {
//                               return "Please enter valid email";
//                             }
//                             return null;
//                           },
//                         ),
//                         textFormField(
//                           passwordController,
//                           "Enter Password",
//                           true,
//                           TextInputType.text,
//                           (value) {
//                             if (value!.isEmpty) {
//                               return "Please enter password";
//                             } else if (value.length < 8) {
//                               return "Password length should be greater than 8";
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   loginButton(),
//                   Row(
//                     children: <Widget>[
//                       Text(
//                         "Sign in using faculty?",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SignInScreen(),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "Faculty Sign In",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InkWell loginButton() {
//     return InkWell(
//       onTap: () {
//         signInAdmin();
//       },
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12), color: Colors.deepPurple),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Center(
//             child: isLoading
//                 ? const CircularProgressIndicator(
//                     color: Colors.white,
//                   )
//                 : const Text(
//                     "Signin",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> signInAdmin() async {
//     try {
//       FocusManager.instance.primaryFocus?.unfocus();

//       if (formKey.currentState!.validate()) {
//         setState(() {
//           isLoading = true;
//         });
//         //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(true);
//         await authService.signInAdminWithEmailAndPassword(
//           emailController.text,
//           passwordController.text,
//           usernameController.text,
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
//       //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(false);
//     } catch (err) {
//       const errorMessage =
//           'Could not authenticate you. Please try again later!';

//       _showErrorDialog(errorMessage);
//       //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(false);
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
