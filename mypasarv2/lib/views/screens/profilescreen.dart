import 'package:flutter/material.dart';
import '../shared/mainmenu.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: const Center(child: Text("Profile")),
          drawer: const MainMenuWidget()),
    );
  }
}
