import 'package:flutter/material.dart';
import 'package:rider/assets/theme.dart';
import 'package:rider/pages/home/home.dart';
import 'package:rider/repo/assignment_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sixt Together',
      theme: themeData,
      home: HomePage(),
    );
  }
}
