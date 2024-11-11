import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/bar_chart.dart';
import 'package:salesboardapp/models/Sales.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApiService apiService = ApiService();
  String loginStatus = "";
  List<SalesResult> sales = [];

  @override
  void initState() {
    super.initState();
    fetchLoginStatusFirstTime();
  }

  fetchLoginStatusFirstTime() async {
    loginStatus = await apiService.fetchLoginStatus();
    Sales? data = await apiService.dashboardData();
    if (data != null) {
      sales = data.result;
    }
    setState(() {});
  }

  fetchLoginStatus(bool isDayIn, bool isMobileDevice) async {
    log("this is in function $isDayIn");

    loginStatus = await apiService.fetchLoginStatus();
    log("this is status $loginStatus");
    if (isDayIn) {
      if (loginStatus == "out") {
        Fluttertoast.showToast(msg: "Your day is complete!");
        return;
      } else if (loginStatus == "in") {
        Fluttertoast.showToast(msg: "Attendance already marked!");
      } else {
        if (mounted) {
          if (isMobileDevice) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MarkAttendance(
                    isDayIn: true,
                  )));
        }
      }
    } else {
      if (loginStatus == "out") {
        Fluttertoast.showToast(msg: "Your day is complete!");
        return;
      } else if (loginStatus == "in") {
        if (mounted) {
          if (isMobileDevice) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MarkAttendance(
                    isDayIn: false,
                  )));
        }
      } else {
        Fluttertoast.showToast(msg: "Please mark attendance!");
        return;
      }
    }
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
      key: _drawerKey,
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Salesboard"),
        titleTextStyle: const TextStyle(fontSize: 20),
        leadingWidth: !isMobileDevice ? 0 : null,
        leading: !isMobileDevice
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _drawerKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu)),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.notifications),
        //   ),
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.help))
        // ],
        // iconTheme: IconThemeData(
        //   color: Colors.black
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
              Expanded(
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
                    if (!isMobileDevice)
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextButton(
                                      onPressed: () {
                                        fetchLoginStatus(true, isMobileDevice);
                                      },
                                      child: const Text(
                                        "Day In",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                    )),
                                    const VerticalDivider(
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                        child: TextButton(
                                      onPressed: () {
                                        fetchLoginStatus(false, isMobileDevice);
                                      },
                                      child: const Text(
                                        "Day Out",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                dashboardOptionUi(context, "assets/icon_shop.png", "Customer", const FarmerScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_visit.png", "Visits", const VisitsScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_order.png", "Orders", const OrdersScreen(), screenWidth, isMobileDevice),
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
                                dashboardOptionUi(context, "assets/icon_tour.png", "Tours", const ViewTourPlan(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_report.png", "Brochures", const ViewBrochuresScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_menu5.png", "Attendance", const AttendanceScreen(), screenWidth, isMobileDevice),
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
                                dashboardOptionUi(context, "assets/icon_target.png", "Target", const TargetScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_menu4.png", "Leaves", const ViewLeaveScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_stock.png", "Probables", const ViewProbScreen(), screenWidth, isMobileDevice),
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
                                dashboardOptionUi(context, "assets/merchandise.png", "Merchandise", const ShowMerchandise(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_dispatch.png", "Dispatches", const ViewLeaveScreen(), screenWidth, isMobileDevice),
                                dashboardOptionUi(context, "assets/icon_expense.png", "Expenses", const ShowExpenses(), screenWidth, isMobileDevice),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5),
                      child: Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        width: screenWidth,
                        height: isMobileDevice ? (screenWidth / 1.1) : (screenWidth / 1.7),
                        child: sales.isNotEmpty
                            ? Card(
                                child: BarChartPage(sales: sales),
                              )
                            : const Center(
                                child: Text("No Any Sales Data"),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: isMobileDevice
          ? Drawer(
              width: screenWidth / 1.5,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                      InkWell(
                        onTap: () {
                          fetchLoginStatus(true, isMobileDevice);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(children: [
                            Icon(Icons.login),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Day In",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black, fontSize: 16.0),
                            ),
                          ]),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(children: [
                            Icon(Icons.account_circle_outlined),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Profile",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black, fontSize: 16.0),
                            ),
                          ]),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          fetchLoginStatus(false, isMobileDevice);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Day Out",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.black, fontSize: 16.0),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget dashboardOptionUi(BuildContext context, String iconName, String title, Widget navigationPage, double screenWidth, bool isMobileDevice) {
    return SizedBox(
      width: screenWidth / (isMobileDevice ? 4 : 4.8),
      child: InkWell(
        child: Column(
          children: [
            Image.asset(iconName, width: 40, height: 40),
            const SizedBox(
              height: 8,
            ),
            Text(title)
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigationPage),
          );
        },
      ),
    );
  }
}
