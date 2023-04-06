import 'package:adopteme_admin/home_page.dart';
import 'package:adopteme_admin/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDEQtT7SbNmSjzMg2T6S41q5RHHYdsjvyw",
    appId: "1:316956774805:web:a4bd7adfbe10a1dbbee69c",
    authDomain: "rescuemeapp-d0e4b.firebaseapp.com",
    messagingSenderId: "316956774805",
    projectId: "rescuemeapp-d0e4b",
    storageBucket: "rescuemeapp-d0e4b.appspot.com",
  ));
  runApp(const MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorkey,
      title: 'AdopteMe',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
