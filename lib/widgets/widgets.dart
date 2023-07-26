import 'package:attendance_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextFormField textFormField(
  TextEditingController controller,
  String hint,
  bool obscure,
  TextInputType inputType,
  String? Function(String?)? validation,
) {
  return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(hintText: hint),
      obscureText: obscure,
      validator: validation);
}

InkWell loginButton(
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController,
  String btnName,
  BuildContext context,
) {
  var _isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential authResult;
  return InkWell(
    onTap: () async {
      try {
        FocusManager.instance.primaryFocus?.unfocus();

        if (formKey.currentState!.validate()) {
          print(emailController.text);
          print(passwordController.text);
          authResult = await auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
        }
      } catch (e) {}
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.deepPurple),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            btnName,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    ),
  );
}
