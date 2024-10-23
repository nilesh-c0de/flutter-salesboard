import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:salesboardapp/api_constants.dart';
import 'package:salesboardapp/pages/add_leave_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service.dart';

class ViewLeaveScreen extends StatefulWidget {
  const ViewLeaveScreen({super.key});

  @override
  State<ViewLeaveScreen> createState() => _ViewLeaveScreenState();
}

class _ViewLeaveScreenState extends State<ViewLeaveScreen> {
  List<Leaves> list = [];
  bool noData = false;

  @override
  void initState() {
    super.initState();
    getLeave();
  }

  Future<void> getLeave() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final response = await http.post(Uri.parse(ApiConstants.getLeaveEndPoint),
        body: {"user_id": userId});

    if (200 == response.statusCode) {
      try {
        var loginJson = json.decode(response.body);
        LeaveData visits = LeaveData.fromJson(loginJson);

        if (visits.success ?? false) {
          setState(() {
            list = visits.leaves ?? [];
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
          title: const Text("Leaves"),
        ),
        body: list.isNotEmpty
            ? ListView.builder(
                itemCount: list.length,
                itemBuilder: (listContext, index) {
                  Leaves item = list.elementAt(index);
                  return ListTile(
                    title: Text("Name: ${item.name}"),
                    subtitle: Text("From: ${item.fromDate}"
                        "\nTo: ${item.toDate}"
                        "\nStatus: ${item.leaveStatus}"),
                    onTap: () {
                      Fluttertoast.showToast(msg: "${item.reason}");
                    },
                  );
                })
            : Center(
                child: noData
                    ? Text(
                        "No Leaves",
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddLeaveScreen()))
              .then((value) => value != null ? getLeave() : false),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class LeaveData {
  bool? success;
  String? message;
  List<Leaves>? leaves;

  LeaveData({this.success, this.message, this.leaves});

  LeaveData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (leaves != null) {
      data['leaves'] = leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  String? alsId;
  String? name;
  String? noDay;
  String? reason;
  String? fromDate;
  String? toDate;
  String? leaveUserId;
  String? leaveStatus;

  Leaves(
      {this.alsId,
      this.name,
      this.noDay,
      this.reason,
      this.fromDate,
      this.toDate,
      this.leaveUserId,
      this.leaveStatus});

  Leaves.fromJson(Map<String, dynamic> json) {
    alsId = json['als_id'];
    name = json['name'];
    noDay = json['no_day'];
    reason = json['reason'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    leaveUserId = json['leave_user_id'];
    leaveStatus = json['leave_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['als_id'] = alsId;
    data['name'] = name;
    data['no_day'] = noDay;
    data['reason'] = reason;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['leave_user_id'] = leaveUserId;
    data['leave_status'] = leaveStatus;
    return data;
  }
}
