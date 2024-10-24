import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('View Attendance')),
      body: FutureBuilder<List<Attendance>>(
        future: aList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No visits found.'));
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
                        child: Text("${att.aDate}", style: TextStyle(
                            color: Colors.indigo,
                          fontSize: 18,
                        ),),
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(child: Text("In    -  ${att.aInTime}".toUpperCase(),
                              style: TextStyle(
                                fontSize: 18
                              ),),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Container(child: Text("Out -  ${att.aOutTime}".toUpperCase(), style:
                                TextStyle(
                                  fontSize: 18
                                ),),),
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
