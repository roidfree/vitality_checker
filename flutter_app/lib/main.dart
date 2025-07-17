import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CheckInApp());
}

class CheckInApp extends StatelessWidget {
  const CheckInApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-In App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
