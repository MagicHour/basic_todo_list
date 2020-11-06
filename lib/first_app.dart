// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class FirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pair = WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: RandomizedWord(),

        ),
      ),
    );
  }
}

class RandomizedWord extends StatefulWidget {
  @override
  _RandomizedWordState createState() => _RandomizedWordState();
}

class _RandomizedWordState extends State<RandomizedWord> {
  final _suggestions = List<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _favourites = Set<WordPair>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Greetings"),
            actions: [
              IconButton(icon: Icon(Icons.fact_check_rounded), onPressed: _pushSaved),
              IconButton(icon: Icon(Icons.autorenew), onPressed: _refresh)
            ]
        ),
        body: _buildSuggestion()
    );
  }

  // New list fresh
  void _refresh() {
    setState(() {
      _suggestions.clear();
      _favourites.clear();
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
                title: Text("Favourites page")
            ),
            body: ListView(children: _favourites.map((pair) {
              return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
            }).toList()
            ),
          );
        })
    );
  }

  Widget _buildRow(WordPair pair){
    final saved = _favourites.contains(pair);

    // If we press on an item
    Function itemPress = () {
      setState(() {
        if(saved){
          _favourites.remove(pair);
        } else {
          _favourites.add(pair);
        }
      });
    };

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
          saved ? Icons.fact_check_outlined : Icons.fact_check,
          color: saved ? Colors.amber : Colors.red
      ),
      onTap: itemPress
    );
  }

  // Called when ever we scroll for each new item in the list
  // When we want to load a specific part of the list
  Widget _buildSuggestion(){
    return ListView.builder(padding: EdgeInsets.all(4.0), itemBuilder: (BuildContext context, int i) {
      if(i % 2 == 1) return Divider(thickness: 1, color: Colors.grey);

      final idx = i ~/ 2;

      //grow
      if(idx >= _suggestions.length){
        _suggestions.addAll(generateWordPairs().take(idx - _suggestions.length+10));
      }

      //return what we have
      return _buildRow(_suggestions[idx]);


    });
  }
}
