import 'package:attendance_app/screens/admin_home_screen.dart';
import 'package:attendance_app/screens/admin_signin_screen.dart';
import 'package:attendance_app/screens/tabs_screen.dart';
import 'package:attendance_app/services/auth_service.dart';
import 'package:attendance_app/services/auth_state_notifier.dart';
import 'package:attendance_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false;
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final String iconImage = "assets/attenda.png";
    //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 0,
                  ),
                  Image.asset(
                    iconImage,
                    height: 150,
                    width: 180,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        textFormField(emailController, "Enter Email", false,
                            TextInputType.emailAddress, (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        }, context, Icons.email_outlined),
                        const SizedBox(
                          height: 20,
                        ),
                        PasswordField(
                            controller: passwordController,
                            hint: "Enter Password",
                            inputType: TextInputType.visiblePassword,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              } else if (value.length < 8) {
                                return "Password length should be greater than 8";
                              }
                              return null;
                            },
                            context: context)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell loginButton() {
    return InkWell(
      onTap: () {
        signIn();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).primaryColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Signin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(true);
        await authService.signInWithEmailAndPassword(
            emailController.text, passwordController.text);
        setState(() {
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed!';
      if (error.code == 'wrong-password') {
        errorMessage = 'Invalid password.';
      } else if (error.code == 'email-already-exists') {
        errorMessage = 'This email address is already in use.';
      } else if (error.code == 'invalid-email') {
        errorMessage = 'This is not a valid email address.';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'Could not find a user with that email.';
      }
      _showErrorDialog(errorMessage);
      setState(() {
        isLoading = false;
      });
      //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(false);
    } catch (err) {
      const errorMessage =
          'Could not authenticate you. Please try again later!';

      _showErrorDialog(errorMessage);
      //Provider.of<AuthStateNotifier>(context, listen: false).setLoading(false);
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }
  }
}
