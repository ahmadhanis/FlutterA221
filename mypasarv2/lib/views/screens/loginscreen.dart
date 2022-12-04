import 'package:flutter/material.dart';
import 'package:mypasarv2/views/screens/mainscreen.dart';
import 'package:mypasarv2/views/screens/registrationscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(8),
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Form(
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
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ))),
                          TextFormField(
                              controller: _passEditingController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _passwordVisible,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.password),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                ),
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
                          GestureDetector(
                            onTap: _goLogin,
                            child: const Text(
                              "Dont have an account. Register now",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: _goHome,
                            child: const Text("Go back Home",
                                style: TextStyle(fontSize: 18)),
                          )
                        ]),
                      ))))),
    );
  }

  void _loginUser() {}

  void _goHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const MainScreen()));
  }

  void _goLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }
}
