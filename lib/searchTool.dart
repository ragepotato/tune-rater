import 'dart:convert';

import 'package:flutter/material.dart';

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
        resultForDisplay = result;
        print("Result: " + result.length.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter listview with json'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ToggleButtons(
              // only for stateful widget
              children: <Widget>[
                Text("Albums"),
                Text("Songs"),
                Text("Users"),
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
            ),
            ListView.builder(
              //scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {

                return index == 0 ? _searchBar() : _listItem(index - 1);
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
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onSubmitted: (text) {
          text = text.toLowerCase();
          setState(() {
            resultForDisplay = result.where((note) {
              var noteTitle = note.toLowerCase();

              highlightedSearch = text;
              print(highlightedSearch);

              return noteTitle.contains(text);
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
            top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
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
