import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'myprofile.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  String signinError = "";
  var currentUser = "Unknown";
  var username = " ";
  var gravatarPic = " ";

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
//            Text(
//              'You have pushed the button this many times:', style: GoogleFonts.mukta(fontSize: 15.0, color: Colors.white),
//      ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("E-mail: ",
                        style: GoogleFonts.mukta(
                          color: Colors.white,
                          fontSize: 17,
                        )),
                    Container(
                      padding: EdgeInsets.only(right: 30),
                      width: 320,
                      child: TextFormField(
                        style: GoogleFonts.mukta(color: Colors.white),
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(51, 51, 51, 0),
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'E-mail',
                          labelStyle: new TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Password: ",
                        style: GoogleFonts.mukta(
                            fontSize: 17, color: Colors.white)),
                    Container(
                      padding: EdgeInsets.only(right: 30),
                      width: 320,
                      child: TextField(
                        style: GoogleFonts.mukta(color: Colors.white),
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(51, 51, 51, 0),
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: new TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        signinError,
                        style: GoogleFonts.mukta(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  //color: Color.fromARGB(51, 51, 51, 0),
                  child: Text(
                    "Sign-In",
                    style: GoogleFonts.mukta(color: Colors.white),
                  ),
                  onPressed: () {
                    print("Pressed1.");
                    _auth
                        .signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString())
                        .then((value) {
                      print("Successful! " + value.user.uid);

                      dataRef
                          .child("Emails/" + value.user.uid + "/username")
                          .once()
                          .then((ds) {
                        username = ds.value;
                        print("Emails/" + value.user.uid);

                        dataRef
                            .child("Users/" + username + "/gravatarLink")
                            .once()
                            .then((ds) {
                          gravatarPic = ds.value;
                          print("Username: " + username);
                          print("GravatarPic: " + gravatarPic);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProfilePage(username: username, gravatarPic: gravatarPic,)));



                        }).catchError((e) {
                          print("None available for " +
                              currentUser +
                              " --- " +
                              e.toString());
                        });
                      }).catchError((e) {
                        print("None available for " +
                            currentUser +
                            " --- " +
                            e.toString());
                      });







//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => MyProfilePage(
//                              username: username, gravatarPic: gravatarPic,
//                            ),
//                          ));
                    }).catchError((e) {
                      print("Failed to Login! " + e.toString());
                      setState(() {
                        signinError = "Incorrect username or password.";
//                        signinError =
//                            e.toString().replaceAll("PlatformException", "");
                      });
                    });
                  },
                ),
                FlatButton(
                  //color: Color.fromARGB(51, 51, 51, 0),
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: GoogleFonts.mukta(color: Colors.white),
                  ),
                  onPressed: () {
                    createAccountDialog(context).then((onValue) {
                      if (onValue == "Success") {
                        //  SnackBar movieBar =

//                        Scaffold.of(context).showSnackBar(SnackBar(
//                          content: new Text("Success! Account created."),
//                        ));

                      }

                      //
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> createAccountDialog(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    var userController = TextEditingController();
    String errorMessage = " ";
    var axisSize = MainAxisSize.min;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            //contentPadding: EdgeInsets.only(left: 5.0, bottom: 5.0,),
            //contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            backgroundColor: Colors.grey,
            //contentPadding: EdgeInsets.all(5.0),
            //title: Text("Create an account", style: GoogleFonts.ubuntu()),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(45),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      //padding: EdgeInsets.only(top: 25, right: 25),
                      child: Column(
                        mainAxisSize: axisSize,
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.only(right: 20),

                            child: TextField(
                              style: GoogleFonts.mukta(),
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'E-mail',
                              ),
                            ),
                          ),

                          Text(
                            "",
                          ),

                          Container(
                            child: TextField(
                              style: GoogleFonts.mukta(),
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),

                          Text(
                            "",
                          ),

                          Container(
                            child: TextField(
                              style: GoogleFonts.mukta(),
                              controller: userController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                              ),
                            ),
                          ),

                          Container(
                            //height: 10,
                            padding: EdgeInsets.all(5),
                            child: Text(errorMessage,
                                style: GoogleFonts.mukta(color: Colors.red)),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                  child: Text("Go Back",
                                      style: GoogleFonts.mukta()),
                                  onPressed: () {
                                    Navigator.of(context).pop("nah");
                                  }),
                              RaisedButton(
                                child: Text("Create Account",
                                    style: GoogleFonts.mukta()),
                                onPressed: () {
                                  final validCharacters =
                                      RegExp(r'^[a-zA-Z0-9_-]+$');

                                  print("Pressed2.");
                                  print(userController.text.toString());

//                                  if (!RegExp('/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/').hasMatch(
//                                      userController.text.toString())) {

                                  if (!validCharacters.hasMatch(
                                      userController.text.toString())) {
                                    setState(() {
                                      errorMessage =
                                          "Invalid username. Must not contain spaces or special characters.";
                                    });
                                    errorMessage =
                                        "Invalid username. Must not contain spaces or special characters.";
                                    print("Bad.");
                                  } else {
                                    print("here");
                                    dataRef
                                        .child("Users/" +
                                            userController.text.toString())
                                        .once()
                                        .then((ds) async {
                                      if (ds.value == null) {
                                        _auth
                                            .createUserWithEmailAndPassword(
                                                email: emailController.text
                                                    .toString(),
                                                password: passController.text
                                                    .toString())
                                            .then((value) {
                                          print("Successful! - " +
                                              value.user.uid.toString());
                                          print(userController.text.toString());
                                          print(
                                              emailController.text.toString());

//                                    dataRef.child("Users").orderByChild("username").equalTo(userController.text.toString()).once("value",snapshot => {
////                                    if (snapshot.exists()){
////
////                                    }
//                                    });

                                          dataRef
                                              .child("Users/" +
                                                  userController.text
                                                      .toString())
                                              .set({
                                            "email":
                                                emailController.text.toString(),
                                            "username":
                                                userController.text.toString(),
                                            "gravatarLink":
                                                "https://www.gravatar.com/avatar/" +
                                                    md5
                                                        .convert(utf8.encode(
                                                            "Stephen.tayag@gmail.com "
                                                                .trim()
                                                                .toLowerCase()))
                                                        .toString() +
                                                    "?s=500",
                                          }).then((res) {
                                            print("Added");
                                          }).catchError((e) {
                                            print("Failed due to " + e);
                                          });

                                          dataRef
                                              .child("Emails/" +
                                                  value.user.uid.toString())
                                              .set({
                                            "username":
                                                userController.text.toString(),
                                          }).then((res) {
                                            print("Added");
                                          }).catchError((e) {
                                            print("Failed due to " + e);
                                          });

                                          Navigator.of(context).pop("Success");
                                        }).catchError((e) {
                                          print("Failed to sign up! " +
                                              e.toString());
                                          setState(() {
                                            if (e.code ==
                                                'ERROR_EMAIL_ALREADY_IN_USE') {
                                              errorMessage =
                                                  "ERROR. E-mail is already in use.";
                                            }
                                            if (e.code ==
                                                'ERROR_INVALID_EMAIL') {
                                              errorMessage =
                                                  "ERROR. E-mail is invalid.";
                                            }
                                            if (e.code ==
                                                'ERROR_WEAK_PASSWORD') {
                                              errorMessage =
                                                  "ERROR. Password is not strong enough.";
                                            }

//                                      errorMessage = e
//                                          .toString()
//                                          .replaceAll("PlatformException", "");
//                                      print(errorMessage.replaceAll(
//                                          "PlatformException", ""));
                                            //axisSize = MainAxisSize.values(MainAxisSize.min);
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          errorMessage =
                                              "ERROR. Username already exists.";
                                        });
                                      }
                                    }).catchError((e) {
                                      print("Error. Already exists");
                                      Navigator.of(context).pop("Success");
                                    });
                                  }
                                },
                              ),
                            ],
                          ),

                          //getGenres(errorMessage),
                        ],
                      ),
                    );
                  }),
                ),
                Positioned(
                  right: 10.0,
                  top: 10.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 16.0,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
