import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Common.dart';


class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can access the position.
    return await Geolocator.getCurrentPosition();
  }
}


class MarkAttendance extends StatefulWidget {
  final bool isDayIn;

  const MarkAttendance({super.key, required this.isDayIn});

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {

  final TextEditingController _readingController = TextEditingController();
  XFile? _image;
  String username = "";
  String lat = "";
  String lng = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    getUsername();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.isDayIn ? "Mark Day In" : "Mark Day Out"),
        titleTextStyle: const TextStyle(fontSize: 20),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.teal[200]!)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/icon_user.png",
                  width: MediaQuery.of(context).size.width / 4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  DateFormat("h:m a")
                      .format(DateTime.parse(DateTime.now().toString()))
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  DateFormat("EEEE, dd-MM-yyyy")
                      .format(DateTime.parse(DateTime.now().toString()))
                      .toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "$username (Area)",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _readingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "reading", border: OutlineInputBorder()),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                        backgroundColor: Colors.blue),
                    onPressed: () {
                      var reading = _readingController.text.toString();
                      if(reading.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter reading! - $reading", gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black12, textColor: Colors.black);
                        return;
                      }
                      _takePicture(reading);
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture(String reading) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    if(lat == "0.0" || lng == "0.0") {
      Fluttertoast.showToast(msg: "Wait.. Getting Location!");
    }

    ApiService apiService = ApiService();
    Common? result = await apiService.uploadImage(_image?.path ?? "", reading, lat.toString(), lng.toString(), widget.isDayIn);

    if(result != null) {
      var message = result.message;
      Fluttertoast.showToast(msg: message);
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> getUsername() async {

    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString("name") ?? "";
    setState(() {

    });

    print("username - $username");
    LocationService service = LocationService();
    Position? position = await service.getCurrentLocation();
    lat = 0.0.toString();
    lng = 0.0.toString();

    if (position != null) {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      print('Current location: ${position.latitude}, ${position.longitude}');
    }

    // setState(() {
    //
    // });
  }

}
