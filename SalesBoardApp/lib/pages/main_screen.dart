import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/main.dart';
import 'package:salesboardapp/pages/add_expense.dart';
import 'package:salesboardapp/pages/add_farmer_screen.dart';
import 'package:salesboardapp/pages/add_tour_plan.dart';
import 'package:salesboardapp/pages/add_visit.dart';
import 'package:salesboardapp/pages/profile_screen.dart';
import 'package:salesboardapp/pages/dashboard_screen.dart';

import 'favorite_screen.dart';
import 'mydropdown.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = [
    const DashboardScreen(),
    const FavoriteScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpense()),
        );
      },
      child: const Icon(Icons.add),),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: "Dashboard",
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorite",
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Profile",
                backgroundColor: Colors.green)
          ]),
    );
  }
}
