// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adopteme_admin/editArticle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArticleCard extends StatelessWidget {
  final String imageUrl;
  final String headline;
  final String categorie;
  final String author;
  final Timestamp createdAt;
  final bool isPopular;
  final DocumentSnapshot snapshot;

  ArticleCard({
    Key? key,
    required this.imageUrl,
    required this.headline,
    required this.categorie,
    required this.author,
    required this.createdAt,
    required this.isPopular,
    required this.snapshot,
  }) : super(key: key);
  CollectionReference Tips = FirebaseFirestore.instance.collection('Tips');

  Future<void> updateStatus(String id, bool stauts) {
    if (stauts == true) {
      return Tips.doc(id).update({'isPopular': false});
    } else {
      return Tips.doc(id).update({'isPopular': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = (createdAt).toDate();
    String publishedAt = DateFormat.yMMMMEEEEd().format(date);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                height: 140,
                width: 260,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Name
                  Row(
                    children: [
                      Icon(
                        Icons.title,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        headline,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Breed
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(categorie),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Region
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(author),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Owner Name
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.deepPurple),
                      SizedBox(width: 8.0),
                      Text(publishedAt),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  // Phone Owner
                ],
              ),
            ),
            SizedBox(width: 16.0),
            // Buttons

            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: isPopular
                            ? Text('Remove from  Popular section')
                            : Text('Add to Popular'),
                        content: isPopular
                            ? Text(
                                'Are you sure you want to Remove this Article from popular section ?')
                            : Text(
                                'Are you sure you want to Add this Article to Popular section ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              updateStatus(snapshot.id, snapshot["isPopular"])
                                  .then((value) => Navigator.pop(context));
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: isPopular
                      ? Icon(
                          Icons.star,
                          color: Colors.amber,
                        )
                      : Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        ),
                  label: isPopular
                      ? Text("Remove from Popular section")
                      : Text("Add to Popular section"),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Article'),
                        content: Text(
                            'Are you sure you want to Delete this Article ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
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
                  label: Text("delete Article"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.to(EditArticle(documentSnapshot: snapshot));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  label: Text("Edit Article"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
