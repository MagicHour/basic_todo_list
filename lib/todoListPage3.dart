import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoPageLookup extends StatelessWidget{
  final String lookupString;

  TodoPageLookup(this.lookupString);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Searching up $lookupString")),
      body: WikiSearch(lookupString)
    );
  }
}

class WikiSearch extends StatefulWidget {
  final String lookupString;
  WikiSearch(this.lookupString);

  @override
  _WikiSearchState createState() => _WikiSearchState();
}
// https://en.wikipedia.org/w/api.php?action=query&format=json&titles=Great_Intelligence&prop=extracts&exintro&explaintext
class _WikiSearchState extends State<WikiSearch> {
  String searchResult;
  Future lookupRequest;

  Future<String> getSummary(Map<String, dynamic> map) async{
    Map<String, dynamic> pages = map["query"]["pages"];
    String pageId = pages.keys.first;
    if(pageId == "-1") return null;
    return pages[pageId]["extract"];
  }

  @override
  void initState() {
    super.initState();
    if(widget.lookupString == "Load"){
      lookupRequest = Future.delayed(Duration(seconds: 4),
              () async {
            String url = "https://en.wikipedia.org/w/api.php?action=query&format=json&titles=${widget.lookupString.replaceAll(" ", "_")}&prop=extracts&exlimit=max&explaintext";
            print("Querying: "+url);
            var res;
            try {
              res = await http.get(url);
            }catch(err){
              print(err.toString());
              return null;
            }
            String summary = await getSummary(jsonDecode(res.body));
            if(summary == null) summary = "NO PAGE FOUND!";
            setState(() => this.searchResult = summary);
          });
    }
    else {
      lookupRequest = Future(
              () async {
            String url = "https://en.wikipedia.org/w/api.php?action=query&format=json&titles=${widget.lookupString.replaceAll(" ", "_")}&prop=extracts&exlimit=max&explaintext";
            print("Querying: "+url);
            var res;
            try {
              res = await http.get(url);
            }catch(err){
              print(err.toString());
              return null;
            }
            String summary = await getSummary(jsonDecode(res.body));
            if(summary == null) summary = "NO PAGE FOUND!";
            setState(() => this.searchResult = summary);
          });
    }
  }

  _WikiSearchState();

  @override
  Widget build(BuildContext context) {
    return searchResult == null ? SpinKitWave(color: Colors.white) : SingleChildScrollView(padding: EdgeInsets.all(16.0), child: Text(searchResult));
  }
}
