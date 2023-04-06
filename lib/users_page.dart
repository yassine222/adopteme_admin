// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('UserProfile');

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
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Users List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          return Container(
            child: (snapshot.connectionState == ConnectionState.waiting)
                ? CircularProgressIndicator.adaptive()
                : ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                document['fullname'],
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                document['adresse'],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(document['image']),
                                backgroundColor: Colors.deepPurple,
                                radius: 40,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                document['email'],
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                document['phone'],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(width: 8),
                                TextButton(
                                  child: (document["isbanned"] == false)
                                      ? Text(
                                          'desactiver',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Text(
                                          'Activer',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: (document["isbanned"] == false)
                                            ? Text('Désactiver utilisateur')
                                            : Text('Activer utilisateur'),
                                        content: (document["isbanned"] == false)
                                            ? Text(
                                                'Voulez-vous désactiver cet utilisateur ?')
                                            : Text(
                                                'Voulez-vous activer cet utilisateur ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              updateStatus(document.id,
                                                  document["isbanned"] as bool);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Oui'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                    child: const Text(
                                      'Supprimer',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Supprimer utilisateur'),
                                          content: Text(
                                              'Voulez-vous supprimer cet utilisateur ?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Non'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteUser(document.id);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Oui'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }
}
