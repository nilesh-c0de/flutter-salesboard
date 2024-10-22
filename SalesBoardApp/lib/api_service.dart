import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:salesboardapp/api_constants.dart';
import 'package:salesboardapp/models/Attendance.dart';
import 'package:salesboardapp/models/Customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/Area.dart';
import 'models/Route.dart';
import 'models/Visit.dart';

class ApiService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final body = {
      'username': username,
      'userpass': password,
    };

    final response = await http.post(Uri.parse(ApiConstants.loginEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(json.decode(response.body)['data']);
      }
      return json.decode(
          response.body)['data']; // Adjust according to your response structure
    } else {
      throw Exception(
          'Failed to log in: ${json.decode(response.body)['error']['message']}');
    }
  }

  Future<List<Visit>> fetchUserVisits() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'userId': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.visitsEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((visit) => Visit.fromJson(visit)).toList();
      } else {
        throw Exception('Failed to load visits');
      }
    } else {
      throw Exception('Failed to load visits');
    }
  }

  Future<void> uploadImage(String filePath, String reading) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.markAttendanceEndPoint), // Your upload URL
    );

    request.files.add(await http.MultipartFile.fromPath(
      'image', // The field name your server expects
      filePath,
    ));

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? "0";

    request.fields['user_id'] = userId;
    request.fields['reading'] = reading;
    request.fields['event'] = "in";

    request.fields['start_lat'] = "200";
    request.fields['start_lng'] = "200";
    request.fields['address'] = "200";

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> addFarmer(String areaId, String routeId, String type, String farmer, String contact,
      String village, String otherInfo, String note) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');


    final body = {
      'isDealer': type,
      'name': farmer,
      'mobile': contact,
      'village': village,
      'other_info': otherInfo,
      'notes': note,
      'added_by': userId,
      'area': areaId,
      'route': routeId,
      'state': "1",
    };

    final response = await http.post(Uri.parse(ApiConstants.addFarmerEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> addDealer(
      String isDealer,
      String company,
      String owner,
      String mobile,
      String keeper,
      String keeperMobile,
      String gst,
      String pan) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    var area = "-1";
    var route = "-1";
    var state = "-1";

    final body = {
      'isDealer': isDealer,
      'shop_name': company,
      'name': owner,
      'mobile': mobile,
      'key_person': keeper,
      'mobile_second': keeperMobile,
      'gst': gst,
      'pan': pan,
      'added_by': userId,
      'area': area,
      'route': route,
      'state': state,
    };

    final response = await http.post(Uri.parse(ApiConstants.addFarmerEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> addVisit(String note, String date, String custId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // final custId = "0";

    final body = {
      'cust_id': custId,
      'comment': note,
      'next_visit': date,
      'user_id': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.addVisitEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<List<Attendance>> fetchAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'user_id': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.attendanceEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        final List<dynamic> jsonData = jsonResponse['result'];
        return jsonData.map((att) => Attendance.fromJson(att)).toList();
      } else {
        throw Exception('Failed to load visits');
      }
    } else {
      throw Exception('Failed to load visits');
    }
  }

  Future<List<Area>> fetchAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // Replace with your API endpoint
    final response = await http.get(Uri.parse(
        'http://salesboard.in/solufinephp/new/get_user_area.php?userId=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['areas']);
      if (jsonResponse['success'] == true) {
        final List<dynamic> jsonData = jsonResponse['areas'];
        return jsonData.map((att) => Area.fromJson(att)).toList();
      } else {
        throw Exception('Failed to load visits');
      }
    } else {
      throw Exception('Failed to load areas');
    }
  }

  Future<List<MyRoute>> fetchRoutes(String area) async {
    // Replace with your API endpoint
    final response = await http.get(Uri.parse(
        'http://salesboard.in/solufinephp/new/get_area_route.php?areaId=$area'));

    if (kDebugMode) {
      print(area);
    }
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['routes']);
      if (jsonResponse['success'] == true) {
        final List<dynamic> jsonData = jsonResponse['routes'];
        return jsonData.map((att) => MyRoute.fromJson(att)).toList();
      } else {
        return [];
        throw Exception('Failed to load visits');
      }
    } else {
      throw Exception('Failed to load routes');
    }
  }

  Future<List<Customer>> fetchCustomers(String? routeId) async {
    final body1 = {'route': routeId};

    final response = await http.post(
        Uri.parse(ApiConstants.storeEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body1);

    if (response.statusCode == 200) {
      print(response.body);
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => Customer.fromJson(visit)).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }

  Future<void> addTourPlan(String areaId, String routeId, String date, String calls) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'area': areaId,
      'route': routeId,
      'date': date,
      'calls': calls,
      'user_id': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.addTourPlanEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }
}
