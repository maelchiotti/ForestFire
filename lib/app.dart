import 'package:flutter/material.dart';
import 'package:forest_fire/pages/forest_fire_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Forest Fire',
      home: ForestFirePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
