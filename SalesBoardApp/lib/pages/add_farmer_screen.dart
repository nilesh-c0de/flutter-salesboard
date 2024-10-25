import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/pages/add_dealer_screen.dart';

import 'mark_attendance.dart';

class AddFarmerScreen extends StatefulWidget {

  final String areaId;
  final String routeId;
  const AddFarmerScreen({super.key, required this.areaId, required this.routeId});

  @override
  State<AddFarmerScreen> createState() => _AddFarmerScreenState();
}

class _AddFarmerScreenState extends State<AddFarmerScreen> {

  final ApiService apiService = ApiService();
  final TextEditingController _farmerController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Farmer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _farmerController,
                    decoration: const InputDecoration(
                        hintText: "Farmer", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _contactController,
                    decoration: const InputDecoration(
                        hintText: "Contact", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _districtController,
                    decoration: const InputDecoration(
                        hintText: "District", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _villageController,
                    decoration: const InputDecoration(
                        hintText: "City/Village", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _otherInfoController,
                    decoration: const InputDecoration(
                        hintText: "Other Information", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _noteController,
                    decoration: const InputDecoration(
                        hintText: "Note", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(onPressed: () {
                      _addFarmer();
                    }, child: Text("SUBMIT")),
                  ),
                  SizedBox(height: 10,),
        
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 8),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDealerScreen(areaId: widget.areaId, routeId: widget.routeId,)),
                  );
                }, child: Text("ADD DEALER")),
              ),
            )
          ]
        ),
      ),
    );
  }

  Future<void> _addFarmer() async {
    String farmer = _farmerController.text;
    String contact = _contactController.text;
    String village = _villageController.text;
    String otherInfo = _otherInfoController.text;
    String note = _noteController.text;

    LocationService service = LocationService();
    Position? position = await service.getCurrentLocation();
    String lat = 0.0.toString();
    String lng = 0.0.toString();

    if (position != null) {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      print('Current location: ${position.latitude}, ${position.longitude}');
    }

    if(farmer.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter farmer!");
      return;
    }

    var x = await apiService.addFarmer(
      widget.areaId,
      widget.routeId,
      "0",
      farmer,
      contact,
      village,
      otherInfo,
      note,
      lat,
      lng
    );

    if(x) {
      Fluttertoast.showToast(msg: "Farmer added!");
      if (mounted) Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "Failed to add farmer!");
    }
  }
}


