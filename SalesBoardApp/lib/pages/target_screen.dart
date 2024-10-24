import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/TargetResponse.dart';

import '../api_service.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  ApiService apiService = ApiService();

  late Future<List<TargetResponse>> targetList;

  @override
  void initState() {
    super.initState();

    targetList = apiService.fetchTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Targets')),
      body: FutureBuilder<List<TargetResponse>>(
        future: targetList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'No records found.',
              style: TextStyle(fontSize: 20),
            ));
          }

          final visits = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final visit = visits[index];
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => TourPlanDetails(tpId: visit.tp_id, mId: visit.month_id, uId: visit.user_name)),
                        // );
                      },
                      child: ListTile(
                        title: Text(
                          // "Target - ${visit.target}",
                          // style: TextStyle(color: Colors.indigoAccent.shade200),
                          "Target - ${visit.target}".toUpperCase(),
                          style: TextStyle(fontSize: 18, color: Colors.indigo),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  child: Text("Month - ${visit.month}", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  child: Text("Year - ${visit.year}", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  child: Text("Quarter - ${visit.quarter}", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  child: Text("${visit.user_name}", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ]),
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
