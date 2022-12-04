import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPasar',
      theme: ThemeData(
        textTheme:
            GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme.apply()),
        primarySwatch: Colors.cyan,
      ),
      home: const SplashScreen(),
    );
  }
}
