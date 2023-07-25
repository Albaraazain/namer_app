import 'package:flutter/material.dart';
import 'package:namer_app/state/my_app_state.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/views/widgets/big_card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentWordState = appState.current;

    IconData iconFavourite = Icons.favorite_border;
    if (appState.favorites.contains(currentWordState)) {
      iconFavourite = Icons.favorite;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(currentWordState: currentWordState),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite(currentWordState);
                  },
                  icon: Icon(iconFavourite),
                  label: Text('Like')),
              SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {
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
