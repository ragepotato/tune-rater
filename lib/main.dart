import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;




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
                    Text(
                      "E-mail: ",
                        style: GoogleFonts.mukta(color: Colors.white, fontSize: 17,)
                    ),
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
                            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
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
                    Text(
                      "Password: ",
                        style: GoogleFonts.mukta(fontSize: 17, color: Colors.white)
                    ),
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
                            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
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
                  child: Wrap(children: <Widget>[
                    Text(
                      signinError,
                      style: GoogleFonts.ubuntu(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),

                  ],),
                ),
                RaisedButton(
                  color: Color.fromARGB(51, 51, 51, 0),
                  child: Text("Sign-In", style: GoogleFonts.mukta(color: Colors.white),),
                  onPressed: () {
                    print("Pressed1.");
                    _auth
                        .signInWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString())
                        .then((value) {
                      print("Successful! " + value.user.uid);
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                MyHomePage(uid: value.user.uid)),
//                      );
                    }).catchError((e) {
                      print("Failed to Login! " + e.toString());
                      setState(() {
                        signinError = e
                            .toString()
                            .replaceAll("PlatformException", "");
                      });
                    });
                  },
                ),
                RaisedButton(
                  color: Color.fromARGB(51, 51, 51, 0),
                  child: Text("Don't have an account? Sign Up", style: GoogleFonts.mukta(color: Colors.white),),
                  onPressed: () {
                    createAccountDialog(context).then((onValue) {
                      if (onValue == "Success") {
                        //  SnackBar movieBar =

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: new Text("Success! Account created."),
                        ));
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
    String errorMessage = " ";
    var axisSize = MainAxisSize.min;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //contentPadding: EdgeInsets.all(5.0),
            title: Text("Create an account", style: GoogleFonts.ubuntu()),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: axisSize,
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.only(right: 20),

                          child: TextField(
                            style: GoogleFonts.ubuntu(),
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
                            style: GoogleFonts.ubuntu(),
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

                        Container(
                          //height: 10,
                          padding: EdgeInsets.all(5),
                          child: Text(errorMessage,
                              style: GoogleFonts.ubuntu(color: Colors.red)),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Go Back", style: GoogleFonts.ubuntu()),
                                onPressed: () {
                                  Navigator.of(context).pop("nah");
                                }),
                            RaisedButton(
                              child: Text("Create Account",
                                  style: GoogleFonts.ubuntu()),
                              onPressed: () {
                                print("Pressed2.");

                                _auth
                                    .createUserWithEmailAndPassword(
                                    email: emailController.text.toString(),
                                    password: passController.text.toString())
                                    .then((value) {
                                  print("Successful!");
                                  Navigator.of(context).pop("Success");
                                }).catchError((e) {
                                  print("Failed to sign up! " + e.toString());
                                  setState(() {
                                    errorMessage = e
                                        .toString()
                                        .replaceAll("PlatformException", "");
                                    print(errorMessage.replaceAll(
                                        "PlatformException", ""));
                                    //axisSize = MainAxisSize.values(MainAxisSize.min);
                                  });
                                });
                              },
                            ),
                          ],
                        ),

                        //getGenres(errorMessage),
                      ],
                    ),
                  );
                }),

            actions: <Widget>[],
          );
        });
  }



}
