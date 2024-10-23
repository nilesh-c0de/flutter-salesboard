import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/TourItem.dart';

import '../api_service.dart';

class TourPlanDetails extends StatefulWidget {

  final String tpId;
  final String mId;
  final String uId;

  const TourPlanDetails({super.key, required this.tpId, required this.mId, required this.uId});

  @override
  State<TourPlanDetails> createState() => _TourPlanDetailsState();
}

class _TourPlanDetailsState extends State<TourPlanDetails> {

  ApiService apiService = ApiService();

  late Future<List<TourItem>> tourPlanList;

  @override
  void initState() {
    super.initState();

    tourPlanList = apiService.fetchTours(widget.tpId, widget.mId, widget.uId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Visits')),
      body: FutureBuilder<List<TourItem>>(
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
                      // onTap: (){
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => TourPlanDetails(tpId: visit.tp_id, mId: visit.month_id, uId: visit.user_name)),
                      //   );
                      // },
                      child: ListTile(
                        title: Text("${visit.tour_date}", style: TextStyle(
                            color: Colors.indigoAccent.shade200
                        ),),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.area_name}"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.route_name}"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.target_call}"),),
                              ),
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
