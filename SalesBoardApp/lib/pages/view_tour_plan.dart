import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:salesboardapp/models/tour_response.dart';
import 'package:salesboardapp/pages/add_tour_plan.dart';
import 'package:salesboardapp/pages/tour_plan_details.dart';

import '../api_service.dart';

class ViewTourPlan extends StatefulWidget {
  const ViewTourPlan({super.key});

  @override
  State<ViewTourPlan> createState() => _ViewTourPlanState();
}

class _ViewTourPlanState extends State<ViewTourPlan> {
  ApiService apiService = ApiService();

  late Future<List<TourResponse>> tourPlanList;

  @override
  void initState() {
    super.initState();

    tourPlanList = apiService.fetchTourPlans();
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
      appBar: AppBar(centerTitle: false,title: const Text("Monthly Tour Plan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTourPlan()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          Expanded(
            child: FutureBuilder<List<TourResponse>>(
              future: tourPlanList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tours found.'));
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TourPlanDetails(tpId: visit.tp_id, mId: visit.month_id, uId: visit.user_name)),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                visit.month.toUpperCase(),
                                style: const TextStyle(color: Colors.indigo, fontSize: 18),
                              ),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    visit.user_name,
                                    style: const TextStyle(fontSize: 18),
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
          ),
        ],
      ),
    );
  }
}
