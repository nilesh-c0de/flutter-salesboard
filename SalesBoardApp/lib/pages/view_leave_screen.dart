import 'package:flutter/material.dart';

import '../api_service.dart';

class ViewLeaveScreen extends StatefulWidget {
  const ViewLeaveScreen({super.key});

  @override
  State<ViewLeaveScreen> createState() => _ViewLeaveScreenState();
}

class _ViewLeaveScreenState extends State<ViewLeaveScreen> {



  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Scaffold(
        body: Center(
          child: Text("Welcome to Leaves"),
        ),
      ),
    );
  }
}
