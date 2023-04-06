// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:adopteme_admin/components/customWidget.dart';
import 'package:adopteme_admin/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date = DateFormat.yMMMMEEEEd().format(DateTime.now());
  final User? user = FirebaseAuth.instance.currentUser;

  int? postcount;
  int? activePost;
  int? inactivepost;
  int? profilecount;
  int? catsArticle;
  int? dogsArticle;
  int? otherArticle;
  int? totalArticle;
  int? adoptedpets;
  int? activeUser;
  int? inactiveUser;
  int? f1() {
    FirebaseFirestore.instance
        .collection('UserProfile')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        profilecount = querySnapshot.docs.length;
      });
    });
    return profilecount;
  }

  int? f2() {
    FirebaseFirestore.instance
        .collection("UserProfile")
        .where('isbanned', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        activeUser = querySnapshot.docs.length;
      });
    });
    return activeUser;
  }

  int? f3() {
    FirebaseFirestore.instance
        .collection("UserProfile")
        .where('isbanned', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        inactiveUser = querySnapshot.docs.length;
      });
    });
    return inactiveUser;
  }

  @override
  void initState() {
    f1();
    f2();
    f3();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    CollectionReference admins =
        FirebaseFirestore.instance.collection('AdminProfile');

    FirebaseFirestore.instance
        .collection('Tips')
        .doc('CatsCare')
        .collection('post')
        .get()
        .then((QuerySnapshot querySnapshot) {
      catsArticle = querySnapshot.docs.length;
    });
    FirebaseFirestore.instance
        .collection('Tips')
        .doc('DogCare')
        .collection('post')
        .get()
        .then((QuerySnapshot querySnapshot) {
      dogsArticle = querySnapshot.docs.length;
    });
    FirebaseFirestore.instance
        .collection('Tips')
        .doc('OtherCare')
        .collection('post')
        .get()
        .then((QuerySnapshot querySnapshot) {
      otherArticle = querySnapshot.docs.length;
      totalArticle = otherArticle! + catsArticle! + dogsArticle!;
    });

    FirebaseFirestore.instance
        .collection("UserPost")
        .where('isactive', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      activePost = querySnapshot.docs.length;
    });

    FirebaseFirestore.instance
        .collection("UserPost")
        .where('isactive', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      inactivepost = querySnapshot.docs.length;
    });
    FirebaseFirestore.instance
        .collection("UserPost")
        .where('isadopted', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);

      adoptedpets = querySnapshot.docs.length;
    });

    FirebaseFirestore.instance
        .collection("UserPost")
        .get()
        .then((QuerySnapshot querySnapshot) {
      postcount = querySnapshot.docs.length;
    });
    FirebaseFirestore.instance
        .collection("UserProfile")
        .where('isbanned', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      activeUser = querySnapshot.docs.length;
    });

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "AdopteMe",
            textAlign: TextAlign.left,
          ),
        ),
        drawer: const MyDrawer(),
        body: SizedBox(
            height: queryData.size.height * 2,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FutureBuilder<DocumentSnapshot>(
                        future: admins.doc(user!.uid).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(left: 90),
                              child: SizedBox(
                                height: 100,
                                width: 400,
                                child: Card(
                                  color: Colors.deepPurple,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage("${data['image']}"),
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    ),
                                    title: Text(
                                      "${data['fullname']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    trailing: Text(
                                      'Admin',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    subtitle: Text(
                                      "${data['email']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 90),
                            child: SizedBox(
                              height: 100,
                              width: 400,
                              child: Card(
                                  color: Colors.deepPurple,
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  )),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(right: 90),
                      child: SizedBox(
                          width: 220,
                          height: 60,
                          child: Card(
                            color: Colors.deepPurple,
                            child: ListTile(
                                title: Text(
                              date,
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomWidget(
                          title: "Number of users",
                          subtitle: profilecount == null
                              ? CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  profilecount.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600),
                                )),
                      CustomWidget(
                          title: "Active users",
                          subtitle: activePost == null
                              ? CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  activeUser.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600),
                                )),
                      CustomWidget(
                          title: "Baned users",
                          subtitle: inactiveUser == null
                              ? CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  inactiveUser.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600),
                                )),
                      CustomWidget(
                          title: "Number of posts",
                          subtitle: postcount == null
                              ? CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  postcount.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w600),
                                )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    CustomWidget(
                        title: "Active posts",
                        subtitle: activePost == null
                            ? CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                activePost.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              )),
                    CustomWidget(
                        title: 'Inactive posts',
                        subtitle: inactivepost == null
                            ? CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                inactivepost.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              )),
                    CustomWidget(
                        title: 'Published articles',
                        subtitle: totalArticle == null
                            ? CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                totalArticle.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              )),
                    CustomWidget(
                        title: 'Adopted pets',
                        subtitle: adoptedpets == null
                            ? CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                adoptedpets.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600),
                              )),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ],
            )));
  }
}
