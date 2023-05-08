// ignore_for_file: prefer_const_constructors

import 'package:adopteme_admin/components/articleCard.dart';
import 'package:adopteme_admin/components/petCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  CollectionReference Tips = FirebaseFirestore.instance.collection('Tips');

  String? searchedArticle;
  bool sortPost = true;
  bool showDogArticle = false;
  bool showCatArticle = false;
  bool showParrotArticle = false;
  bool showFishArticle = false;
  bool showOtherArticle = false;
  bool showAllArticle = false;
  bool showPopularArticle = false;

  Future<void> updateStatus(String id, bool stauts) {
    if (stauts == true) {
      return Tips.doc(id).update({'isPopular': false});
    } else {
      return Tips.doc(id).update({'isPopular': true});
    }
  }

  Future<void> deleteUser(doc) {
    return Tips.doc(doc)
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
    searchedArticle = "";
    sortPost = true;
    showAllArticle = false;
    showPopularArticle = false;
    showOtherArticle = false;
    showFishArticle = false;
    showParrotArticle = false;
    showDogArticle = false;
    showCatArticle = false;
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

        stream: searchedArticle == "" &&
                showPopularArticle == false &&
                showAllArticle == false &&
                showDogArticle == false &&
                showCatArticle == false &&
                showFishArticle == false &&
                showParrotArticle == false &&
                showOtherArticle == false
            ? Tips.orderBy("createdAt", descending: sortPost).snapshots()
            : searchedArticle != ""
                ? Tips.where("headline", isEqualTo: searchedArticle).snapshots()
                : showAllArticle == true
                    ? Tips.snapshots()
                    : showPopularArticle == true
                        ? Tips.where("isPopular", isEqualTo: true).snapshots()
                        : showDogArticle == true
                            ? Tips.where("categorie", isEqualTo: "Dog")
                                .snapshots()
                            : showCatArticle == true
                                ? Tips.where("categorie", isEqualTo: "Cat")
                                    .snapshots()
                                : showParrotArticle == true
                                    ? Tips.where("categorie",
                                            isEqualTo: "Parrot")
                                        .snapshots()
                                    : showFishArticle == true
                                        ? Tips.where("categorie",
                                                isEqualTo: "Fish")
                                            .snapshots()
                                        : showOtherArticle == true
                                            ? Tips.where("categorie",
                                                    isEqualTo: "Other")
                                                .snapshots()
                                            : Tips.orderBy("createdAt",
                                                    descending: sortPost)
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
                            searchedArticle = value;
                            sortPost = false;
                            setState(() {
                              searchedArticle = value.trim();
                            });
                          },
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Article by Headline'),
                        ),
                      ),
                      TextButton.icon(
                        label: Text("All Articles"),
                        icon: Icon(
                          Icons.list,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showPopularArticle = false;
                            showAllArticle = true;
                            showCatArticle = false;
                            showDogArticle = false;
                            showFishArticle = false;
                            showParrotArticle = false;
                            showOtherArticle = false;
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
                              showPopularArticle = false;
                              showAllArticle = false;
                              showCatArticle = false;
                              showDogArticle = false;
                              showFishArticle = false;
                              showParrotArticle = false;
                              showOtherArticle = false;
                            });
                          } else {
                            setState(() {
                              sortPost = false;
                            });
                          }
                        },
                      ),
                      TextButton.icon(
                        label: Text("Popular Articles"),
                        icon: Icon(
                          FontAwesomeIcons.star,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showAllArticle = false;
                            showPopularArticle = true;
                            showCatArticle = false;
                            showDogArticle = false;
                            showFishArticle = false;
                            showParrotArticle = false;
                            showOtherArticle = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Dog Articles"),
                        icon: Icon(
                          FontAwesomeIcons.dog,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            sortPost = false;
                            showPopularArticle = false;
                            showAllArticle = false;
                            showCatArticle = false;
                            showDogArticle = true;
                            showFishArticle = false;
                            showParrotArticle = false;
                            showOtherArticle = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Cats Article"),
                        icon: Icon(
                          FontAwesomeIcons.cat,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            showPopularArticle = false;
                            showAllArticle = false;
                            showCatArticle = true;
                            showDogArticle = false;
                            sortPost = false;
                            showFishArticle = false;
                            showParrotArticle = false;
                            showOtherArticle = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Parrot Articles"),
                        icon: Icon(
                          FontAwesomeIcons.crow,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            showPopularArticle = false;
                            showAllArticle = false;
                            showCatArticle = false;
                            showDogArticle = false;
                            sortPost = false;
                            showFishArticle = false;
                            showParrotArticle = true;
                            showOtherArticle = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Fish Articles"),
                        icon: Icon(
                          FontAwesomeIcons.fish,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            showPopularArticle = false;
                            showAllArticle = false;
                            showCatArticle = false;
                            showDogArticle = false;
                            sortPost = false;
                            showFishArticle = true;
                            showParrotArticle = false;
                            showOtherArticle = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Other Articles"),
                        icon: Icon(
                          FontAwesomeIcons.paw,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            showPopularArticle = false;
                            showAllArticle = false;
                            showCatArticle = false;
                            showDogArticle = false;
                            sortPost = false;
                            showFishArticle = false;
                            showParrotArticle = false;
                            showOtherArticle = true;
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
                            return ArticleCard(
                                snapshot: document,
                                imageUrl: document["image"],
                                headline: document["headline"],
                                categorie: document["categorie"],
                                author: document["author"],
                                createdAt: document["createdAt"],
                                isPopular: document["isPopular"]);
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

  Future<void> delletePost(String postId) {
    return FirebaseFirestore.instance
        .collection('UserPost')
        .doc(postId)
        .update({'isApproved': "yes"});
  }
}
