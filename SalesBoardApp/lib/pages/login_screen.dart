import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salesboardapp/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Log In"),
          backgroundColor: Colors.green,
          leading: const SizedBox(),
          leadingWidth: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Salesboard",
                        style: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          hintText: "Username", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          hintText: "Password", border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          // foreground (text) color
                          backgroundColor: Colors.green, // background color
                        ),
                        onPressed: () => {
                          handleLogin(_usernameController.text,
                              _passwordController.text)
                        },
                        child: const Text("SUBMIT"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
