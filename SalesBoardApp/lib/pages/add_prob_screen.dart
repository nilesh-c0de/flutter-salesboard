import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';

class AddProbScreen extends StatefulWidget {
  const AddProbScreen({super.key});

  @override
  State<AddProbScreen> createState() => _AddProbScreenState();
}

class _AddProbScreenState extends State<AddProbScreen> {
  GlobalKey<FormState> addKey = GlobalKey<FormState>();
  final TextEditingController shopControl = TextEditingController();
  final TextEditingController ownerControl = TextEditingController();
  final TextEditingController mobileControl = TextEditingController();
  final TextEditingController emailControl = TextEditingController();
  Probs selectedType = Probs(probId: "0", probName: "Select Prob");
  String address =
      "RMG4+8PW, Dindi Ves, Miraj, Sangli Miraj Kupwad, Maharashtra 416410, India";
  String latitude = "16.8258321";
  String longitude = "74.656684";
  List<Probs> listProb = [];

  @override
  void initState() {
    super.initState();
    getTypes();
  }

  Future<void> getTypes() async {
    final response =
        await http.get(Uri.parse(ApiConstants.getProbTypeEndPoint));

    if (200 == response.statusCode) {
      try {
        var loginJson = json.decode(response.body);
        ProbTypeData visits = ProbTypeData.fromJson(loginJson);

        if (visits.success ?? false) {
          setState(() {
            listProb = visits.probs ?? [];
            selectedType = listProb.first;
          });
        } else {
          Fluttertoast.showToast(msg: visits.message ?? "Network Problem");
        }
      } catch (ex) {
        Fluttertoast.showToast(msg: ex.toString());
      }
    } else {
      Fluttertoast.showToast(msg: "Server Problem");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Probables"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: addKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1, // Border width
                      ),
                      // Optional: you can specify the border radius
                      borderRadius: BorderRadius.circular(3), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: DropdownButton<Probs>(
                        isExpanded: true,
                        hint: const Text('Select Type'),
                        value: selectedType,
                        onChanged: (Probs? value) {
                          setState(() {
                            selectedType = value ?? listProb.first;
                          });
                        },
                        items: listProb.map((Probs area) {
                          return DropdownMenuItem<Probs>(
                            value: area,
                            child: Text(area.probName ?? ""),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.toString().trim().isEmpty) {
                        return "Please Enter Shop Name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter Shop Name",
                        border: OutlineInputBorder(),
                        labelText: "Shop Name",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                    textInputAction: TextInputAction.next,
                    controller: shopControl,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.toString().trim().isEmpty) {
                        return "Please Enter Owner Name";
                      }
                      return null;
                    },
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: "Enter Owner Name",
                        border: OutlineInputBorder(),
                        labelText: "Owner Name",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                    textInputAction: TextInputAction.next,
                    controller: ownerControl,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.toString().trim().isEmpty) {
                        return "Please Enter Mobile Number";
                      }
                      return null;
                    },
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: "Enter Mobile Number",
                        border: OutlineInputBorder(),
                        labelText: "Mobile Number",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                    textInputAction: TextInputAction.next,
                    controller: mobileControl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.toString().trim().isEmpty) {
                        return "Please Enter Email Id";
                      }
                      return null;
                    },
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: "Enter Email Id",
                        border: OutlineInputBorder(),
                        labelText: "Email Id",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                    textInputAction: TextInputAction.next,
                    controller: emailControl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    address,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (address.isNotEmpty &&
                            addKey.currentState!.validate()) {
                          addProb();
                        } else {
                          Fluttertoast.showToast(msg: "Enter All Details");
                        }
                      },
                      child: const Text("Submit")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addProb() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final response =
        await http.post(Uri.parse(ApiConstants.addProbEndPoint), body: {
      "user": userId,
      "lat": latitude.trim(),
      "lng": longitude.trim(),
      "address": address.trim(),
      "shop": shopControl.text.toString().trim(),
      "owner": ownerControl.text.toString().trim(),
      "email": emailControl.text.toString().trim(),
      "mobile": mobileControl.text.toString().trim(),
      "type": selectedType.probId,
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
}

class ProbTypeData {
  bool? success;
  String? message;
  List<Probs>? probs;

  ProbTypeData({this.success, this.message, this.probs});

  ProbTypeData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['probs'] != null) {
      probs = <Probs>[];
      json['probs'].forEach((v) {
        probs!.add(Probs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (probs != null) {
      data['probs'] = probs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Probs {
  String? probId;
  String? probName;

  Probs({this.probId, this.probName});

  Probs.fromJson(Map<String, dynamic> json) {
    probId = json['prob_id'];
    probName = json['prob_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prob_id'] = probId;
    data['prob_name'] = probName;
    return data;
  }
}
