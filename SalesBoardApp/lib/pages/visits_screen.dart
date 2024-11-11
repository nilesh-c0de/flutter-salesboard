import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:salesboardapp/api_service.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;

    if (screenWidth <= 768) {
      setState(() {
        isMobileDevice = true;
      });
    }

    return Scaffold(
      appBar: AppBar(centerTitle: false,title: const Text('Visits')),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          Expanded(
            child: FutureBuilder<List<Visit>>(
              future: userVisitList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No visits found.'));
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
                            title: Text(
                              visit.storeName.toUpperCase(),
                              style: const TextStyle(color: Colors.indigo, fontSize: 18),
                            ),
                            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "${visit.ownerName} (${visit.contact})",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: Text(
                                  "Note - ${visit.note}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: Text(
                                  "Date - ${visit.followupDate}",
                                  style: const TextStyle(
                                    fontSize: 18,
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
        ],
      ),
    );
  }
}
