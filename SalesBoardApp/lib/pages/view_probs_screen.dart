import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/pages/add_prob_screen.dart';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class ViewProbScreen extends StatefulWidget {
  const ViewProbScreen({super.key});

  @override
  State<ViewProbScreen> createState() => _ViewProbScreenState();
}

class _ViewProbScreenState extends State<ViewProbScreen> {
  List<ProbData> list = [];
  bool noData = false;

  @override
  void initState() {
    super.initState();
    getProb();
  }

  Future<void> getProb() async {
    final response = await http.get(Uri.parse(ApiConstants.getProbEndPoint));

    if (200 == response.statusCode) {
      try {
        var loginJson = json.decode(response.body);
        Probs visits = Probs.fromJson(loginJson);

        if (visits.success ?? false) {
          setState(() {
            list = visits.probData ?? [];
          });
        } else {
          Fluttertoast.showToast(msg: visits.message ?? "Network Problem");
          setState(() {
            noData = true;
          });
        }
      } catch (ex) {
        setState(() {
          noData = true;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Server Problem");
      setState(() {
        noData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Probables"),
        ),
        body: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  ProbData item = list.elementAt(index);
                  return ListTile(
                    title: Text("Shop: ${item.shop}"),
                    subtitle: Text("Owner: ${item.owner}"
                        "\nEmail: ${item.email}"
                        "\nUser: ${item.user}"
                        "\nAddress: ${item.address}"),
                    onTap: () {
                      Fluttertoast.showToast(msg: "${item.address}");
                    },
                  );
                })
            : Center(
                child: noData
                    ? Text(
                        "No Record Found",
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    : const CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProbScreen()))
              .then((value) => value != null ? getProb() : false),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class Probs {
  bool? success;
  String? message;
  List<ProbData>? probData;

  Probs({this.success, this.message, this.probData});

  Probs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['prob_data'] != null) {
      probData = <ProbData>[];
      json['prob_data'].forEach((v) {
        probData!.add(ProbData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (probData != null) {
      data['prob_data'] = probData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProbData {
  String? probId;
  String? shop;
  String? owner;
  String? mobile;
  String? email;
  String? address;
  String? user;
  String? type;
  String? date;

  ProbData(
      {this.probId,
      this.shop,
      this.owner,
      this.mobile,
      this.email,
      this.address,
      this.user,
      this.type,
      this.date});

  ProbData.fromJson(Map<String, dynamic> json) {
    probId = json['prob_id'];
    shop = json['shop'];
    owner = json['owner'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    user = json['user'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prob_id'] = probId;
    data['shop'] = shop;
    data['owner'] = owner;
    data['mobile'] = mobile;
    data['email'] = email;
    data['address'] = address;
    data['user'] = user;
    data['type'] = type;
    data['date'] = date;
    return data;
  }
}