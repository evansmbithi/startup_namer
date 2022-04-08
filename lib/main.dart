// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // sound null safety - non nullable objects work with sdk: ">=2.12.0"

  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Namer App',
    //   home: Scaffold(
    //     // Scaffold implements the basic Material Design visual layout.
    //     appBar: AppBar(
    //       title: const Text('Namer App'),
    //     ),
    //     // body: Center(
    //     //   child: Text(wordPair.asPascalCase),
    //     // ),
    //     body: const Center(
    //       child: RandomWords(),
    //     ),
    //   ),

    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namer App',
      theme: ThemeData(
        // theme controls the look and feel of your app.
        // The default theme is dependent on the physical device or emulator
        // Configuring the ThemeData class easily changes the app's theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          // The Colors class in the Material library provides many color constants that you can play with.
        ),
      ),
      home: const RandomWords(),
    );
  }
}

// stateful widge
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  _RandomWordsState createState() => _RandomWordsState(); // Creates a State class
}

// State class
class _RandomWordsState extends State<RandomWords> {
  // Most of the app’s logic resides here—
  // it maintains the state for the RandomWords widget
  // generate and display a list of word pairings

  void _pushSaved() {
    // this function is called when the list icon is tapped
    Navigator.of(context).push(
      // pushes the route to the Navigator's stack
      // That action changes the screen to display the new route.
      // Context is an element that allows a widget to figure out where the widget is. mediaQuery.ofContext
      MaterialPageRoute<void>(
        builder: (context) {
          //The content for the new page is built in MaterialPageRoute's builder property in an anonymous function.
          final tiles = _saved.map(
            //generate the ListTile
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty // The divided variable holds the final rows converted to a list by the convenience function, toList().
              ? ListTile.divideTiles(
                  // divideTiles() method adds horizontal spacing between each ListTile.
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          // The builder property returns a Scaffold containing the app bar for the new route named SavedSuggestions.
          // The body of the new route consists of a ListView containing the ListTiles rows. Each row is separated by a divider.
          // The Navigator adds a "Back" button to the app bar without explicitly implementing Navigator.pop.
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  final _suggestions = <WordPair>[]; // for saving suggested word pairings.
  // Set is preferred to List because Set does not allow duplicates
  final _saved = <WordPair>{}; // The _saved set stores the favorited word pairings
  final _biggerFont = const TextStyle(fontSize: 18.0); // for making the font size larger.
  @override

  // a widget is a blue print or recipe for what that part of the UI should be.
  Widget build(BuildContext context) {
    //_buildRow function
    // every widget build method takes in a "BuildContext"
    // The BuildContext has an Element type (createElement) that keeps track of where a specific widget is along with what its parent and children are.
    // The element return maintains the info needed at run time for this widget, in this part of the app.

    // final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);
    // use the ListView.builder, rather than directly calling the word generation library.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namer App'), // The title that appears on the Top bar
        actions: [
          IconButton(
              icon: const Icon(Icons.list), // List icon
              onPressed: _pushSaved, // on icon clicked, a new route containing the saved favorites is pushed to the navigator
              tooltip: 'Saved suggestions'),
        ], // takes an array of widgets. child takes a single widget
      ),

      // As the user scrolls the list (displayed in a ListView widget) grows infinitely.
      // ListView’s builder factory constructor allows you to build a list view lazily, on demand.
      body: ListView.builder(
        // This method builds the ListView that displays the suggested word pairing.
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // itemBuilder is a factory builder and callback function specified as an anonymous function.
          // Two parameters are passed to the function—the BuildContext, and the row iterator, i.
          // The iterator begins at 0 and increments each time the function is called.
          // It increments twice for every suggested word pairing: once for the ListTile, and once for the Divider.
          // This model allows the suggested list to continue growing as the user scrolls.
          if (i.isOdd) return const Divider(); // Add a one-pixel-high divider widget before each row in the ListView.

          final index = i ~/ 2; // divide i by 2 and returns an integer result. For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
            // If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
          }

          final alreadySaved = _saved.contains(_suggestions[index]); // ensures that a word pairing has not already been added to favorites

          return ListTile(
            // The ListView.builder widget creates a ListTile once per word pair.
            // This function displays each new pair in a ListTile, which allows you to make the rows more attractive in the next step.
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              // add heart-shaped icons
              alreadySaved ? Icons.favorite : Icons.favorite_border, // if saved used filled shape else use bordered heart-shape
              color: alreadySaved ? Colors.red : null, // if saved add red color to the filled shape else leave it as is
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              // makes the icon tappable, toggling its favorited state
              // When a tile has been tapped, the function calls setState() to notify the framework that state has changed.
              setState(() {
                // calling setState() triggers a call to the build() method for the State object, resulting in an update to the UI.
                if (alreadySaved) {
                  // If a word entry has already been added to favorites, tapping it again removes it from favorites.
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }
}
