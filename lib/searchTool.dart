import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_listview_json/entities/note.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> result = List<String>();
  List<String> resultForDisplay = List<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dataRef = FirebaseDatabase.instance.reference();
  String highlightedSearch = "";

  List<bool> isSelected = List.generate(3, (_) => false);

  Future<List<String>> fetchNotes() async {
    List<String> listUsers = [];
    await dataRef.child("Users").once().then((ds) {
      ds.value.forEach((k, v) {
        listUsers.add(k);
        print(k);
      });
      listUsers.sort((a, b) => a.toString().compareTo(b.toString()));
      print(listUsers.length.toString());
    }).catchError((e) {
      print("None available for " + " --- " + e.toString());
    });
    return listUsers;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        print("Value: " + value.length.toString());
        print("Here.");
        result.addAll(value);

        print("Result: " + result.length.toString());
        isSelected[0] = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(51, 51, 51, 0),

      body: SingleChildScrollView(

        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top: 100),
                child: ToggleButtons(

                  // only for stateful widget
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                      child: Text("Albums", style: GoogleFonts.mukta(fontSize: 16)),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                      child: Text("Songs", style: GoogleFonts.mukta(fontSize: 16)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                      child: Text("Users", style: GoogleFonts.mukta(fontSize: 16)),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                      for (int i = 0; i < isSelected.length; i++) {
                        if (i == index) {
                          isSelected[i] = true;
                        } else {
                          isSelected[i] = false;
                        }

                      }
                    });
                  },
                  isSelected: isSelected,
                  borderWidth: 1,
                  borderColor: Colors.grey,
                  fillColor: Colors.grey,
                  disabledColor: Colors.grey,
                  color: Colors.white,
                  selectedColor: Colors.white,

                ),

            ),

            ListView.builder(


              //scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {

                return index == 0 ? _searchBar()  :

                _listItem(index - 1);
                //return _listItem(index - 1);
              },
              itemCount: resultForDisplay.length + 1,
            ),
          ],
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(

      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      child: TextFormField(
        style: GoogleFonts.mukta(color: Colors.white),

        decoration:
        InputDecoration(

          filled: true,
          fillColor: Color.fromARGB(51, 51, 51, 0),
          enabledBorder: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: const BorderSide(
                color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Search...',
          labelStyle: new TextStyle(color: Colors.grey),
        ),

        onFieldSubmitted: (text) {
          var blankResult = [];
          text = text.toLowerCase();
          setState(() {
            print("Text length: " + text.length.toString());
            resultForDisplay = result.where((note) {

              //note.startsWith(text.toLowerCase())).toList();
              resultForDisplay = text.length == 0 ? blankResult : result;

              var noteTitle = note.toLowerCase();
              //resultForDisplay = result;
              highlightedSearch = text;
              return note.startsWith(text.toLowerCase());
              //return  noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Card(

      child: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            RichText(
//              text: TextSpan(
//                  text: resultForDisplay[index],
//                  style: TextStyle(
//                      color: Colors.black, fontWeight: FontWeight.bold),
//                  children: [
//                    TextSpan(
//                        text: resultForDisplay[index].substring(highlightedSearch),
//                        style: TextStyle(color: Colors.grey))
//                  ]),
//            ),
            ListTile(

              onTap: (){
                if (isSelected[0]){
                  print("Album.");
                }
                if (isSelected[1]){
                  print("Song.");
                }
                if (isSelected[2]){
                  print("User.");
                }
                print(resultForDisplay[index]);
              },
              title: SubstringHighlight(
                text: resultForDisplay[index],
                // search result string from database or something
                term: highlightedSearch,
                textStyle: TextStyle(
                  fontSize: 18, // non-highlight style
                  color: Colors.black,
                ),
                textStyleHighlight: TextStyle(
                  fontSize: 18, // highlight style
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                // user typed "et"
              ),
            ),


          ],
        ),
      ),
    );
  }
}
