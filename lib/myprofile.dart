import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';

import 'dart:convert';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key key, this.title, this.username, this.gravatarLink}) : super(key: key);
  final String gravatarLink;
  final String title;
  final String username;

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  String signinError = "";
  var currentUser = "Unknown";

  void initState() {
    super.initState();
    gravatarPic = widget.gravatarLink;
  }
//  _MyProfilePageState() {
//    gravatarPic = widget.gravatarLink;
//  }




  String gravatarPic = " ";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dataRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(51, 51, 51, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(gravatarPic),
                radius: 80,
              ),
              onPressed: () {
                gravatarPic = md5
                    .convert(utf8.encode(
                        "Stephen.tayag@gmail.com ".trim().toLowerCase()))
                    .toString();
                setState(() {
                  gravatarPic = "https://www.gravatar.com/avatar/" +
                      gravatarPic +
                      "?s=500";
                  print(gravatarPic);
                });
                print("Expand icon");
                expandImageDialog(context);
              },
              iconSize: 120,
            ),
            Text(widget.username.toString(), style: GoogleFonts.mukta(color: Colors.white, fontSize: 20), ),
          ],
        ),
      ),
    );
  }

  expandImageDialog(BuildContext context) {
    return showDialog(

        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Color.fromARGB(51, 51, 51, 0),
            content: Card(

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: NetworkImage(gravatarPic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
