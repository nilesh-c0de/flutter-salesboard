import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/ExpenseResponse.dart';
import 'package:salesboardapp/pages/add_expense.dart';

import '../api_service.dart';

class ShowExpenses extends StatefulWidget {
  const ShowExpenses({super.key});

  @override
  State<ShowExpenses> createState() => _ShowExpensesState();
}

class _ShowExpensesState extends State<ShowExpenses> {

  ApiService apiService = ApiService();

  late Future<List<ExpenseResponse>> tourPlanList;

  @override
  void initState() {
    super.initState();

    tourPlanList = apiService.fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpense()),
        );
      },
        child: const Icon(Icons.add),),
      body: FutureBuilder<List<ExpenseResponse>>(
        future: tourPlanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found.', style: TextStyle(
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
                        title: Text("${visit.allow_name} - ${visit.allow_amt}".toUpperCase(), style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,

                        ),),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.allow_date}",
                                style: TextStyle(
                                  fontSize: 18
                                ),),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(child: Text("${visit.user_name}", style:
                                  TextStyle(fontSize: 18),),),
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
