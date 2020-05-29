import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';

import 'dart:convert';


class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key key, this.title, this.username}) : super(key: key);

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
  String gravatarPic = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dataRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromARGB(51, 51, 51, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Username: " + widget.username.toString()),
            RaisedButton(
              child: Text("Picture"),
              onPressed: (){
                gravatarPic = md5.convert(utf8.encode("Stephen.tayag@gmail.com ".trim().toLowerCase())).toString();
                setState(() {
                  gravatarPic = "https://www.gravatar.com/avatar/" + gravatarPic + "?s=500";
                  print(gravatarPic);
                });



              },
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                    gravatarPic),
                radius: 80,

              ),
              onPressed: (){
                print("Expand icon");
              },
              iconSize: 160,

            ),

          ],
        ),
      ),
    );
  }
}
