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
  var listUsers = [];

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(51, 51, 51, 0),
        title: Text("Search Users"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                listUsers = [];
                dataRef.child("Users").once().then((ds) {
                  ds.value.forEach((k, v) {
                    listUsers.add(k);
                    print(k);
                  });

                  print(listUsers.length.toString());
                  print(listUsers.length);
                  showSearch(context: context, delegate: DataSearch(listUsers));
                }).catchError((e) {
                  print("None available for " + " --- " + e.toString());
                });
              }),
        ],
      ),
      drawer: Drawer(),
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
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "Ranked",
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      numberAlbums.toString(),
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
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
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Songs",
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      "Ranked",
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      numberSongs.toString(),
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
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
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      numberFollowing.toString(),
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Followers",
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      numberFollowers.toString(),
                      style:
                          GoogleFonts.mukta(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child:
                      Text("+ albums", style: GoogleFonts.mukta(fontSize: 14)),
                  onPressed: () {
                    setState(() {
                      numberAlbums++;
                    });
                  },
                ),
                RaisedButton(
                  child:
                      Text("+ songs", style: GoogleFonts.mukta(fontSize: 14)),
                  onPressed: () {
                    setState(() {
                      numberSongs++;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("+ following",
                      style: GoogleFonts.mukta(fontSize: 14)),
                  onPressed: () {
                    setState(() {
                      numberFollowing++;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("+ followers",
                      style: GoogleFonts.mukta(fontSize: 14)),
                  onPressed: () {
                    setState(() {
                      numberFollowers++;
                    });
                  },
                ),
              ],
            ),
            RaisedButton(
              child: Text("Search.", style: GoogleFonts.mukta(fontSize: 14)),
              onPressed: () {
                setState(() {
                  print("a");

                });
              },
            ),
            IconButton(
                icon: Icon(Icons.search, color: Colors.white,),
                onPressed: () {
                  listUsers = [];
                  dataRef.child("Users").once().then((ds) {
                    ds.value.forEach((k, v) {
                      listUsers.add(k);
                      print(k);
                    });

                    print(listUsers.length.toString());
                    print(listUsers.length);
                    showSearch(context: context, delegate: DataSearch(listUsers));
                  }).catchError((e) {
                    print("None available for " + " --- " + e.toString());
                  });
                }),

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

class DataSearch extends SearchDelegate<String> {


  List listUsers;
  final recentList = ["sltayag"];
  String result = "";

  DataSearch(this.listUsers);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark();
  }



  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of app bar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on selection
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something

    //need to ignore case sensitive
    //should print out full username
    List<bool> _selections = List.generate(3, (_) => false);
    final suggestionList = query.isEmpty
        ? recentList
        : listUsers.where((p) => p.startsWith(query.toLowerCase())).toList();
    return Container(

        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

//            ToggleButtons(   // only for stateful widget
//              children: <Widget>[
//                Icon(Icons.ac_unit),
//                Icon(Icons.call),
//                Icon(Icons.cake),
//              ],
//              onPressed: (int index) {
//                setState(() {
//                  isSelected[index] = !isSelected[index];
//                });
//              },
//              isSelected: isSelected,
//            ),




            ToggleButtons(
              children: <Widget>[
              Text("Albums"),
              Text("Songs"),
              Text("Users"),

            ],
              isSelected: _selections,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
              print(suggestionList[index].toString());
              query = suggestionList[index].toString();
              recentList.insert(0, query);
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          ),
          itemCount: suggestionList.length,
        ),
      ],
    ));
  }
}
