import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_constants.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> {
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController fromDateControl = TextEditingController();
  final TextEditingController toDateControl = TextEditingController();
  String toDate = "10-11-2023";
  String fromDate = "05-11-2024";
  final df = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    setState(() {
      toDate = df.format(DateTime.now().add(const Duration(days: 1)));
      fromDate = df.format(DateTime.now().add(const Duration(days: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;

    if (screenWidth <= 768) {
      setState(() {
        isMobileDevice = true;
      });
    }
    return Scaffold(
      appBar: AppBar(centerTitle: false,
        title: const Text("Add Leave"),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.toString().trim().isEmpty) {
                          return "Please Enter Reason";
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter Reason", border: OutlineInputBorder(), labelText: "Reason", focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))),
                      textInputAction: TextInputAction.next,
                      controller: nameControl,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.toString().trim().isEmpty) {
                          return "Please Select From Date";
                        }
                        return null;
                      },
                      onTap: () async {
                        final temp = await showDate(fromDate);
                        if (temp.isNotEmpty) {
                          fromDate = temp;
                          fromDateControl.text = fromDate;
                          setState(() {});
                        }
                      },
                      readOnly: true,
                      decoration:
                          const InputDecoration(hintText: "From Date", border: OutlineInputBorder(), labelText: "From Date", focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))),
                      textInputAction: TextInputAction.next,
                      controller: fromDateControl,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.toString().trim().isEmpty) {
                          return "Please Select To Date";
                        }
                        return null;
                      },
                      onTap: () async {
                        if (fromDateControl.text.isNotEmpty) {
                          final temp = await showDate(fromDate);
                          if (temp.isNotEmpty) {
                            toDate = temp;
                            toDateControl.text = toDate;
                            setState(() {});
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Select From Date");
                        }
                      },
                      readOnly: true,
                      decoration: const InputDecoration(hintText: "To Date", border: OutlineInputBorder(), labelText: "To Date", focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2))),
                      textInputAction: TextInputAction.next,
                      controller: toDateControl,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          onPressed: () {
                            if (toDateControl.text.isEmpty || fromDateControl.text.isEmpty || nameControl.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Fill All Details");
                            } else {
                              addLeave();
                            }
                          },
                          child: const Text("Submit")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addLeave() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final response = await http.post(Uri.parse(ApiConstants.addLeaveEndPoint), body: {
      "user_id": userId,
      "reason": nameControl.text.toString().trim(),
      "from": fromDateControl.text.toString().trim(),
      "to": toDateControl.text.toString().trim(),
    });
    log("response.statusCode: ---- ${response.statusCode}");

    if (200 == response.statusCode) {
      try {
        var loginJson = json.decode(response.body);
        Fluttertoast.showToast(msg: loginJson["message"]);
        if (loginJson["success"]) {
          log("Leave Added");
          if (mounted) Navigator.pop(context, true);
        }
      } catch (ex) {
        log("Ex is: ----- $ex");
      }
    } else {
      Fluttertoast.showToast(msg: "Server Problem");
    }
  }

  Future<String> showDate(String date) async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: df.parse(date), firstDate: df.parse(date), lastDate: DateTime(2035));

    if (pickedDate != null) {
      log(pickedDate.toString()); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = df.format(pickedDate);
      log(formattedDate); //formatted date output using intl package =>  10-03-2021
      return formattedDate;
    } else {
      log("Date is Null");
      return "";
    }
  }
}
