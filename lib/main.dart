import 'package:attendance_app/screens/signin_screen.dart';
import 'package:attendance_app/screens/tabs_screen.dart';
import 'package:attendance_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(user?.uid);

    return

        // ChangeNotifierProvider(create: (_) {
        //   return AuthProvider();
        // })

        MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Attendance System',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Theme.of(context).primaryColor),
                useMaterial3: true,
                appBarTheme: AppBarTheme(
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                iconTheme: IconThemeData(color: Colors.blue),
                buttonTheme: ButtonThemeData(buttonColor: Colors.blue)),
            home: Wrapper()

            // StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (ctx, userSnapshot) {
            //     if (userSnapshot.hasData) {
            //       User? user = userSnapshot.data;
            //       DocumentReference adminRef = FirebaseFirestore.instance
            //           .collection('faculties')
            //           .doc(user!.uid);
            //       return FutureBuilder<DocumentSnapshot>(
            //           future: adminRef.get(),
            //           builder: (ctx, adminSnapshot) {
            //             if (adminSnapshot.hasData && adminSnapshot.data!.exists) {
            //               return AdminHomeScreen();
            //             } else {
            //               return TabsScreen();
            //             }
            //           });
            //       //return const TabsScreen();
            //     } else {
            //       return const loginSelectionScreen();
            //     }
            //   },
            // ),
            );
  }
}
