import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypasarv2/views/screens/loginscreen.dart';
import 'package:mypasarv2/views/screens/mainscreen.dart';
import 'package:mypasarv2/views/screens/newproductscreen.dart';
import 'package:mypasarv2/views/screens/registrationscreen.dart';

import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'profilescreen.dart';

class SellerScreen extends StatefulWidget {
  final User user;
  const SellerScreen({super.key, required this.user});

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
            IconButton(onPressed: _loginForm, icon: const Icon(Icons.login)),
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: const Text("New Product"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("My Order"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _gotoNewProduct();
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ]),
          body: const Center(child: Text("Seller")),
          drawer: MainMenuWidget(user: widget.user)),
    );
  }

  void _registrationForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _gotoNewProduct() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account with us",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const NewProductScreen()));
  }
}
