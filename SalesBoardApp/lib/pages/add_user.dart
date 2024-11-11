import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/pages/login_screen.dart';

import '../models/Common.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;
    if (screenWidth >= 376 && screenWidth <= 768) {
      isMobileDevice = true;
    }

    return Scaffold(
      appBar: AppBar(centerTitle: false,
        title: const Text("Add User"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth / (isMobileDevice ? 1.1 : 1.2),
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Enter full name", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: contactController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Enter contact", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: unameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Enter user name", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: passController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: "Enter password", border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            _addUser();
                          },
                          child: const Text("Submit")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: const Text("Already Have Account? Sign In!"),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addUser() async {
    String name = nameController.text.toString();
    String contact = contactController.text.toString();
    String uname = unameController.text.toString();
    String pass = passController.text.toString();

    if (name.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if (contact.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if (uname.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if (pass.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    Common? x = await apiService.addUser(name, contact, uname, pass);
    if (x != null) {
      if (x.success) {
        Fluttertoast.showToast(msg: x.message);
        if (mounted) Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: x.message);
      }
    } else {
      Fluttertoast.showToast(msg: "NULL");
    }
  }
}
