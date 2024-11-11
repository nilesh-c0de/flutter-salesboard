import 'package:flutter/material.dart';
import 'package:salesboardapp/pages/splash_screen.dart';


bool isCloseApp = false;
void main() {

  runApp(MaterialApp(
    title: 'Simple List App',
    theme: ThemeData(primarySwatch: Colors.green, useMaterial3: false),
    home: const SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}




