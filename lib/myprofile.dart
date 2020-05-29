import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';




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
          ],
        ),
      ),
    );
  }
}
