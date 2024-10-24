import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Visit.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {

  ApiService apiService = ApiService();

  late Future<List<Visit>> userVisitList;

  @override
  void initState() {
    super.initState();

    userVisitList = apiService.fetchUserVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visits')),
      body: FutureBuilder<List<Visit>>(
        future: userVisitList,
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
                    child: ListTile(
                      title: Text("${visit.storeName}", style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(child: Text("${visit.ownerName} (${visit.contact})", style:
                              TextStyle(
                                fontSize: 14
                              ),),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Container(child: Text("Note - ${visit.note}", style:
                              TextStyle(
                                fontSize: 14,
                                color: Colors.black
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
