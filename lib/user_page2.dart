// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersListPage2 extends StatefulWidget {
  const UsersListPage2({super.key});

  @override
  State<UsersListPage2> createState() => _UsersListPage2State();
}

class _UsersListPage2State extends State<UsersListPage2> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('UserProfile');

  String? searchedEmail;
  bool sortUser = true;
  bool showBannedUser = false;
  bool showActiveUser = false;

  Future<void> updateStatus(String id, bool stauts) {
    if (stauts == true) {
      return users.doc(id).update({'isbanned': false});
    } else {
      return users.doc(id).update({'isbanned': true});
    }
  }

  Future<void> deleteUser(doc) {
    return users
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
    searchedEmail = "";
    sortUser = true;
    showBannedUser = false;
    showActiveUser = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Users List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // condition1 ? value1
        //  : condition2 ? value2
        //  : condition3 ? value3

        stream: searchedEmail == "" &&
                showActiveUser == false &&
                showBannedUser == false
            ? users.orderBy("createdAt", descending: sortUser).snapshots()
            : searchedEmail != ""
                ? users.where("email", isEqualTo: searchedEmail).snapshots()
                : showBannedUser == true
                    ? users.where("isbanned", isEqualTo: true).snapshots()
                    : showActiveUser == true
                        ? users.where("isbanned", isEqualTo: false).snapshots()
                        : users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
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
                            searchedEmail = value;
                            sortUser = false;
                            setState(() {
                              searchedEmail = value.trim();
                            });
                          },
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Search Users by email'),
                        ),
                      ),
                      TextButton.icon(
                        label: sortUser == false
                            ? Text("Acending")
                            : Text("Descending"),
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (sortUser == false) {
                            setState(() {
                              sortUser = true;
                              showActiveUser = false;
                              showBannedUser = false;
                            });
                          } else {
                            setState(() {
                              sortUser = false;
                            });
                          }
                        },
                      ),
                      TextButton.icon(
                        label: Text("Banned User"),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            showBannedUser = true;
                            showActiveUser = false;
                          });
                        },
                      ),
                      TextButton.icon(
                        label: Text("Active User"),
                        icon: Icon(
                          Icons.lock_open,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            showActiveUser = true;
                            showBannedUser = false;
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
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(document['image']),
                                ),
                                title: Text(document['email']),
                                // ignore: prefer_interpolation_to_compose_strings
                                subtitle: Text("ID:" +
                                    document.id +
                                    "\nPhone: " +
                                    document['phone']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                (document["isbanned"] == false)
                                                    ? Text('Ban User')
                                                    : Text('Unban User'),
                                            content: (document["isbanned"] ==
                                                    false)
                                                ? Text(
                                                    'Are you sure you want to ban this user ?')
                                                : Text(
                                                    'Are you sure you want to unban this user'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateStatus(
                                                      document.id,
                                                      document["isbanned"]
                                                          as bool);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        document["isbanned"] == true
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        color: document["isbanned"] == true
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      label: document["isbanned"] == true
                                          ? Text("Unban User")
                                          : Text("Ban User"),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Delete User'),
                                            content: Text(
                                                'Are you sure you want to delete this user ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteUser(document.id);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        "Delete User",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
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
