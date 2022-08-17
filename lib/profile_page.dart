import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imdb_clone/header_widget.dart';
import 'package:imdb_clone/home.dart';
import 'package:imdb_clone/update_field_page.dart';

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

class ProfilePage extends StatefulWidget {
  late User _user;
  late var _userData;

  ProfilePage({required User user, Key? key, required userData})
      : super(key: key) {
    _user = user;
    _userData = userData;
  }

  @override
  State<StatefulWidget> createState() =>
      new _ProfilePageState(user: _user, userData: _userData);
}

class _ProfilePageState extends State<ProfilePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  User user;
  var userData;

  _ProfilePageState({required this.user, required this.userData});

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Profile Page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
              ])),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg",
                            ))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    userData['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          leading: Icon(Icons.email),
                                          title: Text("Email"),
                                          subtitle: Text(user.email ?? "email"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.date_range),
                                          title: Text("Birthday"),
                                          subtitle: Text(userData["birthday"]),
                                          onTap: () => {
                                            Navigator.of(context,
                                                    rootNavigator: false)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateFieldPage(
                                                          Icons.date_range,
                                                          "birthday",
                                                          user.uid,
                                                          userData)),
                                            )
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.info_outline),
                                          title: Text("About Me"),
                                          subtitle:
                                              Text(userData["about"] ?? ""),
                                          onTap: () => {
                                            Navigator.of(context,
                                                    rootNavigator: false)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateFieldPage(
                                                          Icons.info_outline,
                                                          "about",
                                                          user.uid,
                                                          userData)),
                                            )
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
