import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? selectedAreaId;
  final List<Map<String, String>> areas = [
    {'area_id': '1', 'area_name': 'Area 1'},
    {'area_id': '2', 'area_name': 'Area 2'},
    {'area_id': '3', 'area_name': 'Area 3'},
  ];

  @override
  void initState() {
    super.initState();
    selectedAreaId = areas[0]['area_id']; // Default to the first area
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dropdown Example')),
      body: Center(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedAreaId,
          onChanged: (value) {
            setState(() {
              selectedAreaId = value;
              print("Selected ID: $selectedAreaId");
            });
          },
          items: areas.map((area) {
            return DropdownMenuItem<String>(
              value: area['area_id'],
              child: Text(area['area_name']!),
            );
          }).toList(),
        ),
      ),
    );
  }
}

