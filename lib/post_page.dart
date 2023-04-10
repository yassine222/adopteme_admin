// ignore_for_file: prefer_const_constructors

import 'package:adopteme_admin/components/petCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  CollectionReference posts = FirebaseFirestore.instance.collection('UserPost');

  String? searchedRegion;
  bool sortPost = true;
  bool waitList = false;
  bool isAdopted = false;

  bool showInactivePost = false;
  bool showActivePost = false;

  Future<void> updateStatus(String id, bool stauts) {
    if (stauts == true) {
      return posts.doc(id).update({'isbanned': false});
    } else {
      return posts.doc(id).update({'isbanned': true});
    }
  }

  Future<void> deleteUser(doc) {
    return posts
        .doc(doc)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> deleteAccaount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  @override
  void initState() {
    searchedRegion = "";
    sortPost = true;
    showInactivePost = false;
    showActivePost = false;
    waitList = false;
    isAdopted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // condition1 ? value1
        //  : condition2 ? value2
        //  : condition3 ? value3

        stream: searchedRegion == "" &&
                showActivePost == false &&
                showInactivePost == false &&
                waitList == false &&
                isAdopted == false
            ? posts.orderBy("createdAt", descending: sortPost).snapshots()
            : searchedRegion != ""
                ? posts.where("owner", isEqualTo: searchedRegion).snapshots()
                : showInactivePost == true
                    ? posts.where("isactive", isEqualTo: false).snapshots()
                    : showActivePost == true
                        ? posts.where("isactive", isEqualTo: true).snapshots()
                        : waitList == true
                            ? posts
                                .where("isApproved", isEqualTo: "waiting")
                                .orderBy("createdAt", descending: false)
                                .snapshots()
                            : isAdopted == true
                                ? posts
                                    .where("isadopted", isEqualTo: true)
                                    .snapshots()
                                : posts
                                    .orderBy("createdAt", descending: false)
                                    .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wrong');
          }

          return SizedBox(
            height: queryData.size.height,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            searchedRegion = value;
                            sortPost = false;
                            setState(() {
                              searchedRegion = value.trim();
                            });
                          },
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Post by Owner Name'),
                        ),
                      ),
                      TextButton.icon(
                        label: Text("waiting for Approval"),
                        icon: Icon(
                          Icons.list,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showActivePost = false;
                            showInactivePost = false;
                            isAdopted = false;
                            waitList = true;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: sortPost == false
                            ? Text("Acending")
                            : Text("Descending"),
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (sortPost == false) {
                            setState(() {
                              sortPost = true;
                              showActivePost = false;
                              showInactivePost = false;
                              isAdopted = false;
                              waitList = false;
                            });
                          } else {
                            setState(() {
                              sortPost = false;
                            });
                          }
                        },
                      ),
                      TextButton.icon(
                        label: Text("Inactive Post"),
                        icon: Icon(
                          Icons.visibility_off,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showInactivePost = true;
                            showActivePost = false;
                            isAdopted = false;
                            waitList = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Active Post"),
                        icon: Icon(
                          Icons.visibility,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showActivePost = true;
                            showInactivePost = false;
                            isAdopted = false;
                            waitList = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Adopted Pets"),
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            showActivePost = false;
                            showInactivePost = false;
                            isAdopted = true;
                            waitList = false;
                            sortPost = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: queryData.size.height / 1.3,
                  child: (snapshot.connectionState == ConnectionState.waiting)
                      ? CircularProgressIndicator.adaptive()
                      : ListView(
                          children: snapshot.data!.docs.map((document) {
                            return PetCardWidget(
                                imageUrl: document["image"],
                                petName: document["name"],
                                breed: document["breed"],
                                region: "fff",
                                ownerName: document["owner"],
                                phoneOwner: document["phone"],
                                id: document["docID"],
                                status: document["isApproved"],
                                onDeletePressed: () {},
                                onActivateDiactivatePressed: () {},
                                onDisApprovePressed: () {},
                                onApprovePressed: () {});
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
