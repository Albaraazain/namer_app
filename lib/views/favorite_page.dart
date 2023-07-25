import 'package:flutter/material.dart';
import 'package:namer_app/state/my_app_state.dart';
import 'package:provider/provider.dart';

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
