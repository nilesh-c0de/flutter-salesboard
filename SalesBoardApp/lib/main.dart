import 'package:flutter/material.dart';
import 'package:salesboardapp/pages/dashboard_screen.dart';
import 'package:salesboardapp/pages/login_screen.dart';
import 'package:salesboardapp/pages/main_screen.dart';
import 'package:salesboardapp/pages/onboarding_screen.dart';
import 'package:salesboardapp/pages/splash_screen.dart';

void main() {

  runApp(MaterialApp(
    title: 'Simple List App',
    theme: ThemeData(primarySwatch: Colors.green, useMaterial3: false),
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}




