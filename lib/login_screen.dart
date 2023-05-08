// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:adopteme_admin/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/action_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width / 2,
                  color: Colors.deepPurple,
                ),
                Container(
                    height: double.infinity,
                    width: size.width / 2,
                    color: Colors.white),
              ],
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      "Bienvenue à AdopteMe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(200),
                    child: Image.asset(
                      "assets/icons/RescueMe logo.png",
                      height: size.height * 0.35,
                      scale: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Allons-y maintenant !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "C'est facile et prend moins de 30 secondes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Icon(
                  Icons.menu,
                  color: Color(0xFF6F35A5),
                  size: 28,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.copyright,
                      color: Colors.grey,
                      size: 24,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Copyright 2020",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(size.height > 770
                  ? 64
                  : size.height > 670
                      ? 32
                      : 16),
              child: Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: size.height *
                        (size.height > 770
                            ? 0.7
                            : size.height > 670
                                ? 0.8
                                : 0.9),
                    width: 500,
                    color: Colors.white,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "CONNEXION",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: 30,
                                  child: Divider(
                                    color: Colors.deepPurple,
                                    thickness: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    suffixIcon: Icon(
                                      Icons.mail_outline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                TextField(
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Mot de passe',
                                    labelText: 'Password',
                                    suffixIcon: Icon(
                                      Icons.lock_outline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 64,
                                ),
                                GestureDetector(
                                  child: actionButton("CONNEXION"),
                                  onTap: () {
                                    AuthService().SignIn(
                                        context,
                                        emailController.text.trim(),
                                        passwordController.text.trim());
                                  },
                                ),
                                Image.asset("assets/icons/RescueMe logo.png"),
                                SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
