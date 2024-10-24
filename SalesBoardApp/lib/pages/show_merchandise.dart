import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/MerchExpenseResponse.dart';
import 'package:salesboardapp/pages/add_merchandise.dart';

import '../api_service.dart';

class ShowMerchandise extends StatefulWidget {
  const ShowMerchandise({super.key});

  @override
  State<ShowMerchandise> createState() => _ShowMerchandiseState();
}

class _ShowMerchandiseState extends State<ShowMerchandise> {

  ApiService apiService = ApiService();

  late Future<List<MerchExpenseResponse>> merchandiseList;

  @override
  void initState() {
    super.initState();

    merchandiseList = apiService.fetchMerchandise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Merchandise')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddMerchandise()),
        );
      },
        child: const Icon(Icons.add),),
      body: FutureBuilder<List<MerchExpenseResponse>>(
        future: merchandiseList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Error: ${snapshot.error}'),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found!', style: TextStyle(
                fontSize: 20
            ),));
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => TourPlanDetails(tpId: visit.tp_id, mId: visit.month_id, uId: visit.user_name)),
                        // );
                      },
                      child: ListTile(
                        title: Text("${visit.march_name}", style: TextStyle(
                            color: Colors.indigoAccent.shade200
                        ),),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.shop_name}"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.quantity}"),),
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
