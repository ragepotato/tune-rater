import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'package:expandable/expandable.dart';
import 'dart:convert';
import 'myprofile.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title, this.username, this.gravatarPic})
      : super(key: key);

  String gravatarPic;
  String title;
  String username;

  @override
  _SettingsPageState createState() => _SettingsPageState(username, gravatarPic);
}

class _SettingsPageState extends State<SettingsPage> {
  var username = "Unknown";
  String gravatarPic = " ";

  var listUsers = [];



  _SettingsPageState(this.username, this.gravatarPic);

//  _MyProfilePageState({this.gravatarPic, this.username});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dataRef = FirebaseDatabase.instance.reference();

  Future<String> fetchBio() async {
    String bioPro = "";

    await dataRef.child("Users/" + username.toString() + "/bio").once().then((ds) {
      bioPro = ds.value.toString();

    }).catchError((e) {
      print("None available for " + " --- " + e.toString());
    });
    return bioPro;
  }

  @override
  void initState() {
    fetchBio().then((value) {
      setState(() {
        initialText = value;
        _editingController = TextEditingController(text: initialText);
      });
    });

    super.initState();

  }





  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "yo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(51, 51, 51, 0),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: _editTitleTextField(),
            ),
            RaisedButton(

              child: Text("Save", style: GoogleFonts.mukta(color: Colors.white, fontSize: 16),),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProfilePage(username: username, gravatarPic: gravatarPic,)));
              },
            ),
          ],
        ),

      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
              FirebaseDatabase.instance.reference().child("Users/" + username).update(
                {

                  "bio" : newValue,
                }
              ).then((value){
                print("Saved: " + newValue);
              }).catchError((error){
                print("Error: " + error.toString());
              });

            });
          },
          autofocus: true,
          controller: _editingController,
          style: GoogleFonts.mukta(color: Colors.white, fontSize: 16),
          maxLines: null,

          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.go,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
          print(initialText);
        });
      },
      child: Text(
        initialText,
        style: GoogleFonts.mukta(color: Colors.white, fontSize: 16),
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
