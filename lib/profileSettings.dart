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
  bool textChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(51, 51, 51, 0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 300, top: 25),
              child: Text("Profile", style: GoogleFonts.mukta(color: Colors.grey, fontSize: 16), ),
            ),

            Container(

              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child:  Container(
                color: Colors.grey,
                padding: EdgeInsets.only(left: 15, right: 15),
              child:

              _editTitleTextField(),
              ),
            ),

            _saveText(),

            RaisedButton(

              child: Text("Save", style: GoogleFonts.mukta(color: Colors.white, fontSize: 16),),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProfilePage(username: username, gravatarPic: gravatarPic,)));
              },
            ),

//            ExpandableNotifier(
//              // <-- Provides ExpandableController to its children
//
//              child: Column(
//                children: [
//                  Expandable(
//                    // <-- Driven by ExpandableController from ExpandableNotifier
//                    collapsed: ExpandableButton(
//                      // <-- Expands when tapped on the cover photo
//                      child: Text(
//                        "Press here",
//                        softWrap: true,
//                        maxLines: 2,
//                        overflow: TextOverflow.ellipsis,
//                        style: GoogleFonts.mukta(
//                            color: Colors.white, fontSize: 14),
//                      ),
//                    ),
//                    expanded: Column(children: [
//                      ExpandableButton(
//                        // <-- Collapses when tapped on
//                        child: _editTitleTextField(),
//                      ),
//                    ]),
//                  ),
//                ],
//              ),
//            ),




          ],
        ),

      ),
    );
  }

  Widget _saveText(){
    if (textChanged){

      return Text("Save?", style: GoogleFonts.mukta(color: Colors.white, fontSize: 16),);
    }
    else{

      return SizedBox.shrink();
    }

  }



  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(

        child: TextField(
          onChanged: (newValue){
            setState(() {
              textChanged = true;
            });
          },


          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
              textChanged = false;
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
