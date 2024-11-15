import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';

import '../api_service.dart';
import '../models/Area.dart';
import '../models/Customer.dart';
import '../models/Route.dart';

class AddTourPlan extends StatefulWidget {
  const AddTourPlan({super.key});

  @override
  State<AddTourPlan> createState() => _AddTourPlanState();
}

class _AddTourPlanState extends State<AddTourPlan> {
  ApiService apiService = ApiService();
  List<Area> areaList = [];
  List<MyRoute> routeList = [];
  Area? area;
  MyRoute? route;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _loadAreas();
  }

  Future<void> _loadAreas() async {
    areaList = [];
    area = null;
    areaList = await apiService.fetchAreas();
    setState(() {
      if (areaList.isNotEmpty) {
        area = areaList[0];
      }
    });
  }

  Future<void> loadRoutes(String area) async {
    routeList = [];
    route = null;
    routeList = await apiService.fetchRoutes(area);
    setState(() {});
  }

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
        appBar: AppBar(centerTitle: false,
          title: const Text("Add Tour Plan"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Select Area",
                      style: TextStyle(color: Colors.grey),
                    ),
                    DropdownButtonFormField<Area>(
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 1, color: Colors.grey))),
                      isExpanded: true,
                      hint: const Text('Select Area '),
                      value: area,
                      onChanged: (Area? value) {
                        setState(() {
                          area = value;
                          if (value != null) {
                            loadRoutes(value.areaId); // Load routes based on selected area ID
                          }
                        });
                      },
                      items: areaList.map((Area area) {
                        return DropdownMenuItem<Area>(
                          value: area,
                          child: Text(area.areaName), // Display the area name
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Select Route",
                      style: TextStyle(color: Colors.grey),
                    ),
                    routeList.isEmpty
                        ? const Text("No routes present!")
                        : DropdownButtonFormField<MyRoute>(
                            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 1, color: Colors.grey))),
                            isExpanded: true,
                            hint: const Text('Select Route'),
                            value: route,
                            onChanged: (MyRoute? value) {
                              setState(() {
                                route = value;
                              });
                            },
                            items: routeList.isNotEmpty
                                ? routeList.map((MyRoute route) {
                                    return DropdownMenuItem<MyRoute>(
                                      value: route,
                                      child: Text(route.routeName), // Display the route name
                                    );
                                  }).toList()
                                : List.empty()),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Select Date",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: selectedDate == null ? 'No date selected!' : 'Selected date: ${selectedDate!.toLocal()}'.split(' ')[2],
                            hintText: "Follow Up Date",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Sale Calls",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: noteController,
                      decoration: const InputDecoration(hintText: "e.g. 30", border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              _addTourPlan();
                            },
                            child: const Text("Submit")))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _addTourPlan() {
    var date = selectedDate.toString().split(' ')[0];

    apiService.addTourPlan(area?.areaId ?? "0", route?.routeId ?? "0", date, noteController.text);
  }
}
