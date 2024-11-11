import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;

    if (screenWidth <= 768) {
      setState(() {
        isMobileDevice = true;
      });
    }

    return Scaffold(
      appBar: AppBar(centerTitle: false,title: const Text('Targets')),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          Expanded(
            child: FutureBuilder<List<TargetResponse>>(
              future: targetList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
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
                                style: const TextStyle(fontSize: 18, color: Colors.indigo),
                              ),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("Month - ${visit.month}", style: const TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("Year - ${visit.year}", style: const TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("Quarter - ${visit.quarter}", style: const TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(visit.user_name, style: const TextStyle(fontSize: 16)),
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
          ),
        ],
      ),
    );
  }
}
