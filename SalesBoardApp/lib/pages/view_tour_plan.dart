import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/tour_response.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('User Visits')),
      body: FutureBuilder<List<TourResponse>>(
        future: tourPlanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No visits found.'));
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
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TourPlanDetails(tpId: visit.tp_id, mId: visit.month_id, uId: visit.user_name)),
                        );
                      },
                      child: ListTile(
                        title: Text("${visit.month}", style: TextStyle(
                            color: Colors.indigoAccent.shade200
                        ),),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.user_name}"),),
                              ),
                            ]
                        ),
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
