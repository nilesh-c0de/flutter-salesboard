import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/pages/attendance_screen.dart';
import 'package:salesboardapp/pages/farmer_screen.dart';
import 'package:salesboardapp/pages/orders_screen.dart';
import 'package:salesboardapp/pages/profile_screen.dart';
import 'package:salesboardapp/pages/mark_attendance.dart';
import 'package:salesboardapp/pages/view_brochures_screen.dart';
import 'package:salesboardapp/pages/show_expenses.dart';
import 'package:salesboardapp/pages/show_merchandise.dart';
import 'package:salesboardapp/pages/target_screen.dart';

import 'package:salesboardapp/pages/view_leave_screen.dart';
import 'package:salesboardapp/pages/view_probs_screen.dart';
import 'package:salesboardapp/pages/view_tour_plan.dart';
import 'package:salesboardapp/pages/visits_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  ApiService apiService = ApiService();
  String loginStatus = "";

  @override
  void initState() {
    super.initState();

    print("initstate");
    fetchLoginStatus();
  }

  fetchLoginStatus() async {
    loginStatus = await apiService.fetchLoginStatus();
    print("status - $loginStatus");
  }
  @override
  Widget build(BuildContext context) {
    print("inside build");
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Salesboard"),
        titleTextStyle: const TextStyle(fontSize: 20),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help))
        ],
        // iconTheme: IconThemeData(
        //   color: Colors.black
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              // const SizedBox(
              //   width: double.infinity,
              //   child: Padding(
              //     padding:
              //         EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 5),
              //     child: Card(
              //       child: Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Center(
              //           child: Text(
              //             "Target 30  |  Completed 20",
              //             style: TextStyle(
              //                 fontStyle: FontStyle.normal, fontSize: 16),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_shop.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Customer")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FarmerScreen()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_visit.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Visits")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VisitsScreen()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/icon_order.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Orders")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_tour.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Tours")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewTourPlan()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_report.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Brochures")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewBrochuresScreen()),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => ViewTourPlan()),
                                // );

                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_menu5.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Attendance")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AttendanceScreen()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_target.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Target")
                                ],
                              ),
                             onTap:() {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) =>
                                       const TargetScreen()));
                             },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_menu4.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Leaves")
                                ],
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewLeaveScreen())),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_stock.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Probables")
                                ],
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ViewProbScreen())),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 85,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/merchandise.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Merchandise")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowMerchandise()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Column(
                              children: [
                                Image.asset("assets/icon_dispatch.png",
                                    width: 40, height: 40),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text("Dispatches")
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Image.asset("assets/icon_expense.png",
                                      width: 40, height: 40),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Expenses")
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShowExpenses()),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.access_time),
                  title: const Text(
                    "Day In",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: () {
                    
                    if(loginStatus == "out") {
                      Fluttertoast.showToast(msg: "Your day is complete!");
                      return;
                    } else if(loginStatus == "in") {
                      Fluttertoast.showToast(msg: "Attendance already marked!");
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MarkAttendance(
                            isDayIn: true,
                          )));
                    }
                    // Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text(
                //     "Daily Update",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   ),
                //   onTap: () {},
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text(
                //     "Tour Plan",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   ),
                //   onTap: () {},
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text(
                //     "Brochures",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   ),
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const ViewBrochuresScreen())),
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text(
                //     "Probables",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   ),
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const ViewProbScreen())),
                // ),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text(
                //     "Apply Leave",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   ),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: const Text(
                    "Profile",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_alarms_rounded),
                  title: const Text(
                    "Day Out",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: () {

                    print("inside out - $loginStatus");
                    if(loginStatus == "out") {
                      Fluttertoast.showToast(msg: "Your day is complete!");
                      return;
                    } else if(loginStatus == "in") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MarkAttendance(
                            isDayIn: false,
                          )));

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>  MarkAttendance(
                      //       isDayIn: true,
                      //     )));
                    } else {
                      Fluttertoast.showToast(msg: "Please mark attendance!");
                      return;
                    }
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
