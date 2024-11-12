import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:salesboardapp/api_constants.dart';
import 'package:salesboardapp/models/Attendance.dart';
import 'package:salesboardapp/models/CartResponse.dart';
import 'package:salesboardapp/models/Customer.dart';
import 'package:salesboardapp/models/Order.dart';
import 'package:salesboardapp/models/ProductResponse.dart';
import 'package:salesboardapp/models/Sales.dart';
import 'package:salesboardapp/models/TargetResponse.dart';
import 'package:salesboardapp/models/TourItem.dart';
import 'package:salesboardapp/models/tour_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/Area.dart';
import 'models/Common.dart';
import 'models/CustomerResponse.dart';
import 'models/ExpenseResponse.dart';
import 'models/ExpenseType.dart';
import 'models/MerchExpenseResponse.dart';
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

  Future<Order?> fetchUserOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userType = prefs.getString('type');

    String type = "";

    if (userType == '2') {
      type = "SH";
    } else if (userType == '3') {
      type = "ASM";
    } else if (userType == '4' || userType == '5') {
      type = "SO";
    } else {
      type = "";
    }

    final body = {
      'user_id': userId,
      'event': type,
    };

    log("this is body $body");
    log("this is url ${ApiConstants.ordersEndPoint}");

    final response = await http.post(Uri.parse(ApiConstants.ordersEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Common?> uploadImage(String filePath, String reading, String lat,
      String lng, String address, bool isDayIn) async {
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

    print("event - $isDayIn");
    request.fields['user_id'] = userId;
    request.fields['reading'] = reading;
    request.fields['event'] = isDayIn == true ? "in" : "out";

    request.fields['start_lat'] = lat;
    request.fields['start_lng'] = lng;
    request.fields['address'] = address;

    var response = await request.send();
    if (response.statusCode == 200) {
      final jsonResponse = await http.Response.fromStream(response);
      final Map<String, dynamic> jsonData = json.decode(jsonResponse.body);

      if (jsonData['success'] == true) {
        print('Image uploaded successfully1!');
        Common obj =
            Common(success: jsonData['success'], message: jsonData['message']);
        return obj;
      } else {
        print('Failed to upload image. - ${jsonData['message']}');
        Common obj =
            Common(success: jsonData['success'], message: jsonData['message']);
        return obj;
      }
    }
    return null;

    // } else {
    //   print('Failed to upload image. Status code: ${response.statusCode}');
    //   return false;
    // }
  }

  Future<bool> addFarmer(
      String areaId,
      String routeId,
      String type,
      String farmer,
      String contact,
      String village,
      String otherInfo,
      String note,
      String lat,
      String lng) async {
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
      "lat": lat,
      "lng": lng
    };

    final response = await http.post(Uri.parse(ApiConstants.addFarmerEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return false;
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
      String pan,
      String area,
      String route,
      void Function(String resp) addCallBack) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    var state = "2";

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
      addCallBack(response.body);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      Fluttertoast.showToast(
          msg: 'Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<bool> addVisit(
      String note, String date, String custId, String lat, String lng) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // final custId = "0";

    final body = {
      'cust_id': custId,
      'comment': note,
      'next_visit': date,
      'user_id': userId,
      "lat": lat,
      "lng": lng
    };

    final response = await http.post(Uri.parse(ApiConstants.addVisitEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return false;
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

  Future<CustomerResponse?> fetchCustomers(String? routeId) async {
    final body1 = {'route': routeId};

    final response = await http.post(Uri.parse(ApiConstants.storeEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body1);

    if (response.statusCode == 200) {
      return CustomerResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<void> addTourPlan(
      String areaId, String routeId, String date, String calls) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'area': areaId,
      'route': routeId,
      'date': date,
      'calls': calls,
      'user_id': userId,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.addTourPlanEndPoint),
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

  Future<List<TourResponse>> fetchTourPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final event = prefs.getString('type');

    print(userId);
    print(event);

    final body = {
      'user_id': userId,
      'event': event,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.viewTourPlanEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => TourResponse.fromJson(visit)).toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<TourItem>> fetchTours(String tpId, String mId, String uId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    print(uId);
    print(tpId);
    print(mId);

    final body = {
      'user_id': userId,
      'tp_id': tpId,
      'month': mId,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.tourPlanInDetailsEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => TourItem.fromJson(visit)).toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<ExpenseType>> fetchExpenseTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'user_id': userId,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.expenseTypesEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => ExpenseType.fromJson(visit)).toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<void> addExpense(String imagePath, String date, String amount,
      String note, String typeId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.addExpenseEndPoint), // Your upload URL
    );

    request.files.add(await http.MultipartFile.fromPath(
      'image', // The field name your server expects
      imagePath,
    ));

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? "0";

    request.fields['user_id'] = userId;
    request.fields['date'] = date;
    request.fields['expense'] = amount;
    request.fields['type'] = typeId;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<List<ExpenseResponse>> fetchExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'user_id': userId,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.showExpensesEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => ExpenseResponse.fromJson(visit)).toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<MerchExpenseResponse>> fetchMerchandise() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final event = prefs.getString('type');

    final body = {
      'user_id': userId,
      'event': event,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.merchExpensesEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData
          .map((visit) => MerchExpenseResponse.fromJson(visit))
          .toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<TargetResponse>> fetchTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final event = prefs.getString('type');

    final body = {
      'user_id': userId,
      'event': event,
    };

    final response = await http.post(Uri.parse(ApiConstants.targetsEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['result'];
      return jsonData.map((visit) => TargetResponse.fromJson(visit)).toList();
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<String> fetchLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'user_id': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.attendanceStatus),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        String x = jsonResponse['status'];
        return x;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<ProductResponse?> fetchProducts() async {
    final response = await http.get(
        Uri.parse('http://salesboard.in/solufinephp/new/fetch_products.php'));

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(json.decode(response.body));
    } else {
      return null;
      // throw Exception('Failed to load areas');
    }
  }

  Future<CartResponse?> addToCart(String quantity, String pId, String custId,
      String cat, String dId, String isDist) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // print("quantity - $quantity");
    // print("pId - $pId");
    // print("custId - $custId");
    // print("cat - $cat");
    // print("dId - $dId");
    // print("isDist - $isDist");

    final body = {
      'added_by': userId,
      'quantity': quantity,
      'prod_id': pId,
      'cust_id': custId,
      'category': cat,
      'dist_id': dId,
      'isDist': isDist,
    };

    final response = await http.post(Uri.parse(ApiConstants.addToCartEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      return CartResponse.fromJson(json.decode(response.body));
    } else {
      return null;
      // throw Exception('Failed to load areas');
    }
  }

  Future<CartResponse?> fetchCartItems(String custId, String isDist) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // print("quantity - $quantity");
    // print("pId - $pId");
    // print("custId - $custId");
    // print("cat - $cat");
    // print("dId - $dId");
    // print("isDist - $isDist");

    final body = {
      'user_id': userId,
      'cust_id': custId,
      'is_dist': isDist,
    };

    final response = await http.post(Uri.parse(ApiConstants.cartItemsEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      return CartResponse.fromJson(json.decode(response.body));
    } else {
      return null;
      // throw Exception('Failed to load areas');
    }
  }

  Future<Common?> addUser(
      String name, String contact, String uname, String pass) async {
    final body = {
      'name': name,
      'contact': contact,
      'uname': uname,
      'pass': pass,
    };

    final response = await http.post(Uri.parse(ApiConstants.addUserEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      return Common.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Common?> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final body = {
      'user_id': userId,
    };

    final response = await http.post(Uri.parse(ApiConstants.deleteUserEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body);

    if (response.statusCode == 200) {
      return Common.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<Sales?> dashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userType = prefs.getString('type');

    final body = {
      'user_id': userId,
      'user_type': userType,
    };

    final response =
        await http.post(Uri.parse(ApiConstants.dashboardUserEndPoint),
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: body);

    log("url ${ApiConstants.dashboardUserEndPoint}");
    log("data $body");

    if (response.statusCode == 200) {
      return Sales.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
