import 'package:flutter/material.dart';
import 'package:mypasarv2/views/screens/loginscreen.dart';
import 'package:mypasarv2/views/screens/mainscreen.dart';
import 'package:mypasarv2/views/screens/registrationscreen.dart';

import '../shared/mainmenu.dart';
import 'profilescreen.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(title: const Text("Seller"), actions: [
            IconButton(
                onPressed: _registrationForm,
                icon: const Icon(Icons.app_registration)),
                IconButton(
                onPressed: _loginForm,
                icon: const Icon(Icons.login))
          ]),
          body: const Center(child: Text("Seller")),
          drawer: const MainMenuWidget()),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _loginForm() {
     Navigator.push(context,
        MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
