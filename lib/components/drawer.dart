// ignore_for_file: prefer_const_constructors

import 'package:adopteme_admin/addBlog.dart';
import 'package:adopteme_admin/articleList.dart';
import 'package:adopteme_admin/post_page.dart';
import 'package:adopteme_admin/services/authService.dart';
import 'package:adopteme_admin/update_profile_page.dart';
import 'package:adopteme_admin/user_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CollectionReference admin =
        FirebaseFirestore.instance.collection('AdminProfile');
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
              0.0,
              1.0
            ],
                colors: [
              Theme.of(context).primaryColor.withOpacity(0.2),
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ])),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: admin.doc(user!.uid).get(),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage("${data['image']}"),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Get.to(() => UpdateProfile());
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${data['fullname']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${data['email']}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  }
                  return CircularProgressIndicator.adaptive();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.home,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Home Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                navigator?.pop(context);
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.list,
                  size: _drawerIconSize,
                  color: Theme.of(context).colorScheme.secondary),
              title: Text(
                'Users',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(() => UsersListPage());
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.pets,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Posts',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(() => PostListPage());
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.article_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Articles',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(() => ArticleListPage());
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Write an Article',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Get.to(() => MakeTips());
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                AuthService().LogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
