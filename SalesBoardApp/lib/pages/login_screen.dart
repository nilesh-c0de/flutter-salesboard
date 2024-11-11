import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/pages/add_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_constants.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService apiService = ApiService();
  bool _isLoading = false;

  checkLogin(String user, String pass) async {
    final body = {
      'username': user,
      'userpass': pass,
    };

    final response = await http.post(Uri.parse(ApiConstants.loginEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == "success") {
      Fluttertoast.showToast(msg: "Login successfully!");

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', jsonResponse['data']['userId']);
      prefs.setString('name', jsonResponse['data']['name']);
      prefs.setString('contact', jsonResponse['data']['contact']);
      prefs.setBool('isActive', jsonResponse['data']['is_active']);
      prefs.setString('type', jsonResponse['data']['type']);
      prefs.setBool('isLoggedIn', true);

      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false);
      }
    } else {
      Fluttertoast.showToast(msg: "Login failed!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleLogin(String username, String password) async {
    try {
      final userData = await apiService.login(username, password);

      // Store user information
      final userId = userData['userId'];
      final name = userData['name'];
      final contact = userData['contact'];
      final isActive = userData['is_active'];
      final type = userData['type'];

      final prefs = await SharedPreferences.getInstance();

      prefs.setString('userId', userId);
      prefs.setString('name', name);
      prefs.setString('contact', contact);
      prefs.setBool('isActive', isActive);
      prefs.setString('type', type);
      prefs.setBool('isLoggedIn', true);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;
    if (screenWidth >= 376 && screenWidth <= 768) {
      isMobileDevice = true;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Log In"),
          backgroundColor: Colors.green,
          leading: const SizedBox(),
          leadingWidth: 0.0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: !isMobileDevice ? (screenWidth / 1.2) : screenWidth,
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: "Username", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(hintText: "Password", border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      _isLoading == true
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () => {
                                  setState(() {
                                    _isLoading = true;
                                  }),
                                  checkLogin(_usernameController.text, _passwordController.text)
                                },
                                child: const Text("SUBMIT"),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: const Text("Don't Have Account? Sign Up!"),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AddUser()), (route) => true);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
