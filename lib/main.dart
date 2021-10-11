import 'package:flutter/material.dart';
import 'package:simple_todo/Pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //supportedLocales: [Locale('en', 'US')],
        home: HomePage()
    );
  }
}
