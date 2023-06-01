import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tesla Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TeslaHome(),
    );
  }
}

class TeslaHome extends StatelessWidget {
  const TeslaHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
