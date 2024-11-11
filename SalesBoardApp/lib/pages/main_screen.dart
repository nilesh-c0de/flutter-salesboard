import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/main.dart';
import 'package:salesboardapp/pages/profile_screen.dart';
import 'package:salesboardapp/pages/dashboard_screen.dart';
import 'package:salesboardapp/pages/visits_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  DateTime? currentBackPressTime;

  onPopInvoked(BuildContext context, bool didPop) {
    log("on pop up we are here ");
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press Again to Exit",
      );
      return false;
    }

    return true;
  }

  final screens = [const DashboardScreen(), const VisitsScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isCloseApp,
      onPopInvoked: (value) {
        setState(() {
          isCloseApp = onPopInvoked(context, value);
          if (isCloseApp) {
            exit(0);
          }
        });
      },
      child: Scaffold(
        body: screens[currentIndex],
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => AddCart()),
        //   );
        // },
        // child: const Icon(Icons.add),),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 25,
            elevation: 20,
            onTap: (index) => setState(() {
                  currentIndex = index;
                }),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard", backgroundColor: Colors.green),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: "Visits", backgroundColor: Colors.green),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile", backgroundColor: Colors.green)
            ]),
      ),
    );
  }
}
