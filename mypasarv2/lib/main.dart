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
      debugShowCheckedModeBanner: false,
      title: 'MyPasar',
      theme: ThemeData(
        textTheme:
            GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme.apply()),
        primarySwatch: Colors.cyan,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark, 
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      home: const SplashScreen(),
    );
  }
}
