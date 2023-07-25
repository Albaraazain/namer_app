import 'package:english_words/english_words.dart'; // This is a package that generates random words
import 'package:flutter/material.dart'; // We need this for the widgets. if this wasnt there we would have to create our own widgets
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

// This is the main widget of the app that we are going to run and display
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      // This is the app that we are going to run
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // This is the home page of the app that we are going to display
        // We are going to display the home page as a stateless widget that we are going to create below
        home: MyHomePage(),
      ),
    );
  }
}

// This is the state of the app that we want to change and notify the widgets about the change in state
class MyAppState extends ChangeNotifier {
  // This is the current word pair that we want to display
  var current = WordPair.random();

  // favorite word list
  var favorites = <WordPair>[];

  MyAppState() {
    loadFavorites();
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteStrings = prefs.getStringList('favorites') ?? [];
    favorites = favoriteStrings
        .map((wordPair) => WordPair(wordPair, ' '))
        .toList(); // convert the list of strings to list of word pairs
    notifyListeners();
  }

  // This is the function that we are going to call when we want to change the current word pair
  void generateWordPair() {
    current = WordPair.random();
    notifyListeners(); // This is the function that notifies the widgets about the change in state
    // we still need to call this function in the widget that we want to notify about the change in state
  }

  // toggle the favourite state
  void toggleFavorite(WordPair wordPair) async {
    if (favorites.contains(wordPair)) {
      favorites.remove(wordPair);
    } else {
      favorites.add(wordPair);
    }
    notifyListeners();

    // Save the favorites to shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites',
        favorites.map((wordPair) => wordPair.asLowerCase).toList());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page = GeneratorPage();
    // case statement to choose which page will be displayed based on the index
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        print("selected index is 0");
        break;
      case 1:
        print("selected index is 1");
        page = FavoritePage();
        break;
      default:
        print('index not valid');
    }

    // This is the widget tree that we are going to display
    // A scafold is a widget that provides a default app bar, title, and a body property that holds the widget tree for the home page
    return SafeArea(
      child: Scaffold(
        body: Row(children: [
          NavigationRail(
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('First'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('Second'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          )
        ]),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentWordState = appState.current;

    // Change the icon based on the favourite state
    IconData iconFavourite = Icons.favorite_border;
    if (appState.favorites.contains(currentWordState)) {
      iconFavourite = Icons.favorite;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(currentWordState: currentWordState),
          // we want to leave some space between the big card and the button
          SizedBox(height: 10),
          Row(
            //fix size to minimum
            mainAxisSize: MainAxisSize.min,
            children: [
              // Button with icon and text to favorite the current word pair
              ElevatedButton.icon(
                  onPressed: () {
                    // toggle the favourite state
                    appState.toggleFavorite(currentWordState);
                  },
                  // if favourite selected then change icon to filled
                  icon: Icon(iconFavourite),
                  label: Text('Like')),
              SizedBox(width: 20),
              // This is the button that we are going to use to change the current word pair
              ElevatedButton(
                  onPressed: () {
                    // This is the function that we are going to call when we want to change the current word pair
                    appState.generateWordPair();
                  },
                  child: Text('New Idea')),
            ],
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.currentWordState,
  });

  final WordPair currentWordState;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // We want this text to be medium sized
          child: Text(
            currentWordState.asLowerCase,
            // We want this text to be white in color so we are going to use the color scheme of the theme and use the onPrimary color of the color scheme to get the white color of the theme that we are using
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ));
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: favorites.isEmpty
          ? Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('You have '
                      '${appState.favorites.length} favorites:'),
                ),
                for (var pair in appState.favorites)
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text(pair.asLowerCase),
                    onTap: () {
                      appState.toggleFavorite(pair);
                    },
                  ),
              ],
            ),
    );
  }
}
