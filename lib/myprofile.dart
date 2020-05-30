import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';

import 'dart:convert';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key key, this.title, this.username, this.gravatarPic})
      : super(key: key);

  String gravatarPic;
  String title;
  String username;

  @override
  _MyProfilePageState createState() =>
      _MyProfilePageState(username, gravatarPic);
}

class _MyProfilePageState extends State<MyProfilePage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  String signinError = "";
  var username = "Unknown";
  String gravatarPic = " ";
  int numberAlbums = 0;
  int numberSongs = 0;
  int numberFollowing = 0;
  int numberFollowers = 0;

  _MyProfilePageState(this.username, this.gravatarPic);

  void initState() {
    super.initState();
  }

//  _MyProfilePageState({this.gravatarPic, this.username});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dataRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(51, 51, 51, 0),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Albums",
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        "Ranked",
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 18),
                      ),
                      Text(numberAlbums.toString(),
                        style: GoogleFonts.mukta(
                          color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: CircleAvatar(
                          backgroundImage: NetworkImage(gravatarPic),
                          radius: 80,
                        ),
                        onPressed: () {
                          gravatarPic = md5
                              .convert(utf8.encode("Stephen.tayag@gmail.com "
                                  .trim()
                                  .toLowerCase()))
                              .toString();
                          setState(() {
                            gravatarPic = "https://www.gravatar.com/avatar/" +
                                gravatarPic +
                                "?s=500";
                            print(gravatarPic);
                          });

                          expandImageDialog(context);
                        },
                        iconSize: 120,
                      ),
                      Text(
                        username.toString(),
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  Column(

                    children: <Widget>[
                      Text(
                        "Songs",
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        "Ranked",
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 18),
                      ),
                      Text(numberSongs.toString(),
                        style: GoogleFonts.mukta(
                            color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                Text(
                  "Following",
                  style: GoogleFonts.mukta(
                      color: Colors.white, fontSize: 18),
                ),
                Text(numberFollowing.toString(),
                  style: GoogleFonts.mukta(
                      color: Colors.white, fontSize: 18),
                ),
              ],),
              Column(
                children: <Widget>[
                  Text(
                    "Followers",
                    style: GoogleFonts.mukta(
                        color: Colors.white, fontSize: 18),
                  ),
                  Text(numberFollowers.toString(),
                    style: GoogleFonts.mukta(
                        color: Colors.white, fontSize: 18),
                  ),
                ],),
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text("+ albums",style: GoogleFonts.mukta(
                  fontSize: 14)),
                onPressed: (){
                  setState(() {
                    numberAlbums++;
                  });

                },
              ),
              RaisedButton(child: Text("+ songs",style: GoogleFonts.mukta(
                  fontSize: 14)),
                onPressed: (){
                  setState(() {
                    numberSongs++;
                  });

                },
              ),
              RaisedButton(child: Text("+ following",style: GoogleFonts.mukta(
                  fontSize: 14)),
                onPressed: (){
                  setState(() {
                    numberFollowing++;
                  });

                },
              ),
              RaisedButton(child: Text("+ followers",style: GoogleFonts.mukta(
                  fontSize: 14)),
                onPressed: (){
                  setState(() {
                    numberFollowers++;
                  });

                },
              ),
            ],
          )

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
