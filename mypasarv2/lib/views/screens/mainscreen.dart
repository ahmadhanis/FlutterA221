import 'package:flutter/material.dart';
import '../shared/mainmenu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Buyer")),
          body: const Center(child: Text("Buyer")),
          drawer: const MainMenuWidget(),
        ));
  }
}
