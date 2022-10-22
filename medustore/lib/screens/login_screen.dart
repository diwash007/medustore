import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medustore/theme/theme_constants.dart';
import 'package:medustore/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  dynamic values;
  String errorString = "";
  bool isloggedIn = false;
  String loginEmail = "";

  @override
  void initState() {
    super.initState();
    getLocalStorageData();
  }

  void getLocalStorageData() async {
    values = await SharedPreferences.getInstance();
    var email = values.getString('email');
    var password = values.getString('password');
    if (email != null && password != null) {
      login(email, password);
    }
  }

  void createCart() async {
    var prefs = await SharedPreferences.getInstance();
    var cartId = prefs.getString('cart');
    if (cartId!.isNotEmpty) return;
    try {
      var response = await http.post(
        Uri.parse('$apiBaseUrl/store/carts'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        print("Cart created");
        await prefs.setString('cart', json.decode(response.body)["cart"]["id"]);
      } else {
        print("cart was not created");
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      var response = await http.post(Uri.parse('$apiBaseUrl/store/auth'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"email": email, "password": password}));
      if (response.statusCode == 200) {
        setState(() {
          isloggedIn = true;
        });

        var cookie = Cookie.fromSetCookieValue(response.headers["set-cookie"]!);
        await values.setString('cookie', cookie.value);
        await values.setString('email', email);
        await values.setString('password', password);
        setState(() {
          loginEmail = values.getString('email');
        });
        createCart();
      } else {
        print("oops");
        if (response.statusCode == 401) {
          setState(() {
            errorString = "Email and Password do not match";
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login to Medustore"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: medusaGradient,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: isloggedIn
                ? Text("Logged in as ${loginEmail}")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                        child: const Icon(
                          Icons.account_circle,
                          color: secondaryColor,
                          size: 70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(90.0),
                                  ),
                                  labelText: 'Email',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailValid) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(90.0),
                                  ),
                                  labelText: 'Password',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),
                              errorString.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        errorString,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: primaryColor),
                            child: const Text('Log In'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login(_emailController.text.toString(),
                                    _passwordController.text.toString());
                              }
                            },
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/register',
                          );
                        },
                        child: Text(
                          'Create a new account?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
