import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../api_constants.dart';

class ViewBrochuresScreen extends StatefulWidget {
  const ViewBrochuresScreen({super.key});

  @override
  State<ViewBrochuresScreen> createState() => _ViewBrochuresScreenState();
}

class _ViewBrochuresScreenState extends State<ViewBrochuresScreen> {
  List<Brochures> list = [];
  bool noData = false;

  @override
  void initState() {
    super.initState();
    getBrochure();
  }

  Future<void> getBrochure() async {
    final response =
        await http.get(Uri.parse(ApiConstants.getBrochureEndPoint));

    if (200 == response.statusCode) {
      try {
        var loginJson = json.decode(response.body);
        BrochureData visits = BrochureData.fromJson(loginJson);

        if (visits.success ?? false) {
          setState(() {
            list = visits.brochures ?? [];
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
          title: const Text("Brochures"),
        ),
        body: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Brochures item = list.elementAt(index);
                  return Card(
                    child: ListTile(
                      title: Text(" ${item.note}"),
                      trailing: IconButton(
                          onPressed: () {
                            _launchUrl(item.file ?? "https://www.google.com");
                          },
                          icon: const Icon(Icons.remove_red_eye)),
                    ),
                  );
                })
            : Center(
                child: noData
                    ? Text(
                        "No Brochures Found",
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    : const CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      Fluttertoast.showToast(msg: "Could not launch $url");
    }
  }
}

class BrochureData {
  bool? success;
  String? message;
  List<Brochures>? brochures;

  BrochureData({this.success, this.message, this.brochures});

  BrochureData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['brochures'] != null) {
      brochures = <Brochures>[];
      json['brochures'].forEach((v) {
        brochures!.add(Brochures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (brochures != null) {
      data['brochures'] = brochures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brochures {
  String? id;
  String? file;
  String? note;

  Brochures({this.id, this.file, this.note});

  Brochures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['note'] = note;
    return data;
  }
}
