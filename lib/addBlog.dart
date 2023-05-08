// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:adopteme_admin/articleList.dart';
import 'package:adopteme_admin/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import 'components/categorieSelector.dart';

class MakeTips extends StatefulWidget {
  const MakeTips({super.key});

  @override
  State<MakeTips> createState() => _MakeTipsState();
}

class _MakeTipsState extends State<MakeTips> {
  String categorie = "Dogs";
  File? imagetoupload;

  String defaultimage =
      'https://www.pulsecarshalton.co.uk/wp-content/uploads/2016/08/jk-placeholder-image.jpg';
  final auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  final QuillController _controller = QuillController.basic();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController titleControlller = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  String? imageurl;
  bool isPopular = false;
  @override
  void dispose() {
    imageUrlController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    CollectionReference tips = FirebaseFirestore.instance.collection('Tips');

    Future<void> addArticle(Timestamp time, QuillController body, String title,
        String author, bool popular, String? image, String cat) {
      final formattedText = body.document.toDelta().toJson();
      return tips
          .add({
            'content': formattedText,
            'headline': title,
            'image': image,
            'author': author,
            'categorie': cat,
            'createdAt': time,
            'isPopular': popular,
          })
          .then((value) => print("Tips Posted"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    User? user = auth.currentUser;
    String uid = user!.uid;
    CollectionReference admins =
        FirebaseFirestore.instance.collection('AdminProfile');
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: const Text(
              'Write an Article',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Write an Article',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          imageurl ?? defaultimage,
                          height: 200,
                          width: 400,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(
                        height: 50,
                        width: 450,
                        child: TextFormField(
                          controller: imageUrlController,
                          onChanged: (value) {
                            setState(() {
                              imageurl = value;
                            });
                          },
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Add a image Url';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            icon: Icon(
                              Icons.image,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: queryData.size.width * 0.5),
                        child: CategoryDropdown(
                          categories: const [
                            'Dog',
                            'Cat',
                            'Parrot',
                            'Fish',
                            "Other"
                          ],
                          onChanged: (value) {
                            setState(() {
                              categorie = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      TextFormField(
                        controller: titleControlller,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Article Headline is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.deepPurple,
                        decoration: const InputDecoration(
                          labelText: 'Headline',
                          icon: Icon(
                            Icons.title,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      QuillToolbar.basic(
                        controller: _controller,
                        showIndent: false,
                        showLink: false,
                        showListCheck: false,
                        showBackgroundColorButton: false,
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QuillEditor.basic(
                              controller: _controller, readOnly: false),
                        ),
                      ),

                      TextFormField(
                        controller: authorController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Author is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.deepPurple,
                        decoration: const InputDecoration(
                          labelText: 'Author',
                          icon: Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // ignore: deprecated_member_use
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Popular"),
                          Switch(
                              value: isPopular,
                              onChanged: (value) {
                                setState(() {
                                  isPopular = value;
                                });
                              }),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addArticle(
                                        Timestamp.now(),
                                        _controller,
                                        titleControlller.text,
                                        authorController.text,
                                        isPopular,
                                        imageurl,
                                        categorie)
                                    .then((value) =>
                                        Get.to((() => ArticleListPage())));
                              }
                            },
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
