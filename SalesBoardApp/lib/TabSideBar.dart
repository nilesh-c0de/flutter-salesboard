import 'package:flutter/material.dart';
import 'package:salesboardapp/pages/attendance_screen.dart';
import 'package:salesboardapp/pages/farmer_screen.dart';
import 'package:salesboardapp/pages/orders_screen.dart';
import 'package:salesboardapp/pages/profile_screen.dart';
import 'package:salesboardapp/pages/show_expenses.dart';
import 'package:salesboardapp/pages/show_merchandise.dart';
import 'package:salesboardapp/pages/view_brochures_screen.dart';
import 'package:salesboardapp/pages/view_leave_screen.dart';
import 'package:salesboardapp/pages/view_probs_screen.dart';
import 'package:salesboardapp/pages/view_tour_plan.dart';
import 'package:salesboardapp/pages/visits_screen.dart';

Widget drawerUi(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Customers",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FarmerScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Visits",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VisitsScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Orders",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrdersScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Tours",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewTourPlan()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Brochures",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewBrochuresScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Attendance",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AttendanceScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Leaves",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewLeaveScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Probables",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewProbScreen()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Merchandise",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowMerchandise()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Expense",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShowExpenses()));
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          title: const Text(
            "Profile",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
          },
        ),
      ],
    ),
  );
}