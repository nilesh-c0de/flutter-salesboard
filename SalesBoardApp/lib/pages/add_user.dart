import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/api_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter full name"
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: contactController,
                  decoration: InputDecoration(
                      labelText: "Enter contact"
                  ),
                ),
                TextFormField(
                  controller: unameController,
                  decoration: InputDecoration(
                      labelText: "Enter user name"
                  ),
                ),
                TextFormField(
                  controller: passController,
                  decoration: InputDecoration(
                      labelText: "Enter password"
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {
                    _addUser();
                  }, child: Text("Submit")),
                )
              ],
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

    if(name.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if(contact.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if(uname.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    if(pass.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your name!");
      return;
    }

    Common? x = await apiService.addUser(name, contact, uname, pass);
    if(x != null) {
      if(x.success) {
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
