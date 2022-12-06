import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User user = User(id: "0",email: "unregistered", name: "unregistered",address: "na",phone: "0123456789",regdate: "0");
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) =>  MainScreen(user: user))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("MYPASAR",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              CircularProgressIndicator(),
              Text("Version 0.1b")
            ]),
      ),
    );
  }
}
