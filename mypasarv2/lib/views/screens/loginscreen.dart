import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mypasarv2/views/screens/buyerscreen.dart';
import 'package:mypasarv2/views/screens/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../serverconfig.dart';
import '../../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  late double screenHeight, screenWidth, cardwitdh;
  var pathAsset = "assets/images/login.jpg";
  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwitdh = screenWidth;
    } else {
      cardwitdh = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        width: screenWidth,
        child: Column(
      children: [
        SizedBox(
            height: screenHeight / 2.8,
            width: screenWidth,
            child: Image.asset(
              pathAsset,
              fit: BoxFit.fill,
            )),
        const SizedBox(
          height: 10,
        ),
        Card(
            elevation: 8,
            margin: const EdgeInsets.all(8),
            child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "enter a valid email"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.email),
                           )),
                    TextFormField(
                        controller: _passEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.password),
                         
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                              saveremovepref(value);
                            });
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: null,
                            child: const Text('Remember Me',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 115,
                          height: 50,
                          elevation: 10,
                          onPressed: _loginUser,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ]),
                ))),
        GestureDetector(
          onTap: _goLogin,
          child: const Text(
            "No account? Create One",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: _goHome,
          child: const Text("Go back Home", style: TextStyle(fontSize: 18)),
        )
      ],
        ),
      )),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    http.post(Uri.parse("${ServerConfig.SERVER}/php/login_user.php"),
        body: {"email": email, "password": pass}).then((response) {
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        User user = User.fromJson(jsonResponse['data']);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => BuyerScreen(user: user)));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  void _goHome() {
    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        regdate: "0",
        credit: '0');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => BuyerScreen(
                  user: user,
                )));
  }

  void _goLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}
