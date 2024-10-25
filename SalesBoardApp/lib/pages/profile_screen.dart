import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("User Profile"),
        titleTextStyle: const TextStyle(fontSize: 20),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.teal[200]!)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/icon_user.png",
                  width: MediaQuery.of(context).size.width / 4,
                ),
                const Text(
                  "User Name (Area)",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {

                    logOut();

                  },
                  child: const Text("Log Out"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {

                    Fluttertoast.showToast(msg: "Account deleted!");
                    logOut();

                  },
                  child: const Text("Delete Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logOut() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // This clears all the preferences
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginScreen()));
  }
}
