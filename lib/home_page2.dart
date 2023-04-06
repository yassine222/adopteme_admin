// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:adopteme_admin/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: FutureBuilder<DocumentSnapshot>(
                  future: admins.doc(user!.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Card(
                          color: Colors.deepPurple,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage("${data['image']}"),
                            ),
                            title: Text("${data['fullname']}"),
                            subtitle: Text("${data['email']}"),
                            trailing: Text(
                              'Admin',
                              style: TextStyle(),
                            ),
                          ));
                    }

                    return SizedBox();
                  },
                ),
              ),
              // Card(
              //   color: Colors.deepPurple,
              //   child: ListTile(
              //       leading: Icon(Icons.date_range), title: Text(date)),
              // ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Total Number of Users"),
          //         subtitle: Text("$profilecount"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Active Users"),
          //         subtitle: Text("$activeUser"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Banned Users"),
          //         subtitle: Text("$inactiveUser"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Total Number of Posts"),
          //         subtitle: Text("postcount"),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 50,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Active Posts"),
          //         subtitle: Text("activePost"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Inactive Posts"),
          //         subtitle: Text("inactivepost"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Published Articles"),
          //         subtitle: Text("totalArticle"),
          //       ),
          //     ),
          //     Card(
          //       color: Colors.deepPurple,
          //       child: ListTile(
          //         title: Text("Adopted Pets "),
          //         subtitle: Text("adoptedpets"),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
