import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';

import '../api_service.dart';
import '../models/Attendance.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  ApiService apiService = ApiService();
  late Future<List<Attendance>> aList;

  @override
  void initState() {
    super.initState();

    aList = apiService.fetchAttendance();
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
      appBar: AppBar(centerTitle: false,title: const Text('View Attendance')),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Attendance>>(
                future: aList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No visits found.'));
                  }

                  final attList = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      itemCount: attList.length,
                      itemBuilder: (context, index) {
                        final att = attList[index];
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "${att.aDate}",
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    child: Text(
                                      "In    -  ${att.aInTime}".toUpperCase(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                  child: Container(
                                    child: Text(
                                      "Out -  ${att.aOutTime}".toUpperCase(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
