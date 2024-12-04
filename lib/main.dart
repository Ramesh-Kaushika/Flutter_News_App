import 'package:flutter/material.dart';
import 'package:news_app/view_models/news_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'News App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: HomeScreen(),
    )
  }
}
