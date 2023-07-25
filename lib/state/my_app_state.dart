import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  MyAppState() {
    loadFavorites();
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteStrings = prefs.getStringList('favorites') ?? [];
    favorites =
        favoriteStrings.map((wordPair) => WordPair(wordPair, ' ')).toList();
    notifyListeners();
  }

  void generateWordPair() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite(WordPair wordPair) async {
    if (favorites.contains(wordPair)) {
      favorites.remove(wordPair);
    } else {
      favorites.add(wordPair);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites',
        favorites.map((wordPair) => wordPair.asLowerCase).toList());
  }
}
