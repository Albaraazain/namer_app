import 'package:flutter/material.dart';
import 'package:namer_app/views/home/home_view.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/state/my_app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 34, 248, 255)),
        ),
        home: HomeView(),
      ),
    );
  }
}
