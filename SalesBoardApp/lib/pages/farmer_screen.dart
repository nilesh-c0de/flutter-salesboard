import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/models/Route.dart';
import 'package:salesboardapp/pages/add_dealer_screen.dart';

import '../models/Area.dart';
import '../models/Customer.dart';
import '../models/CustomerResponse.dart';
import 'add_cart.dart';
import 'add_farmer_screen.dart';
import 'add_visit.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  ApiService apiService = ApiService();
  List<CustomerItem> custList = [];

  bool isAddOptionShow = false;

  List<Area> areaList = [];
  List<MyRoute> routeList = [];
  Area? selectedArea;
  MyRoute? selectedRoute;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // custList = Future.value([]);

    _loadAreas();
    // custList = apiService.fetchCustomers("1");
    // print(custList);
  }

  Future<void> _loadAreas() async {
    areaList = [];
    selectedArea = null;
    areaList = await apiService.fetchAreas();
    // print("area list- $areaList");
    // setState(() {
    //   if(areaList.isNotEmpty) {
    //     loadRoutes(areaList[1].areaId);
    //   }
    // });
  }

  Future<void> loadRoutes(String area, StateSetter setter) async {
    log("selected area - $area");

    routeList = [];
    selectedRoute = null;
    routeList = await apiService.fetchRoutes(area);
    // print("route list- $routeList");
    // setState(() {
    //   selectedRoute = null; // Reset selected route
    // });
    setter(() {});
  }

  void _showAreaRouteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Area and Route - ${routeList.length}'),
          content: SizedBox(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setter) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<Area>(
                      isExpanded: true,
                      hint: const Text('Select Area'),
                      value: selectedArea,
                      onChanged: (Area? value) {
                        setter(() {
                          selectedArea = value;
                          if (value != null) {
                            loadRoutes(value.areaId,
                                setter); // Load routes based on selected area ID
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
                    routeList.isEmpty
                        ? const Text("No routes present!")
                        : DropdownButton<MyRoute>(
                            isExpanded: true,
                            hint: const Text('Select Route'),
                            value: selectedRoute,
                            onChanged: (MyRoute? value) {
                              setter(() {
                                selectedRoute = value;
                                log("route - ${selectedRoute?.routeName}");
                                // _fetchCust(value?.routeId ?? "0");
                              });
                            },
                            items: routeList.isNotEmpty
                                ? routeList.map((MyRoute route) {
                                    return DropdownMenuItem<MyRoute>(
                                      value: route,
                                      child: Text(route
                                          .routeName), // Display the route name
                                    );
                                  }).toList()
                                : List.empty()),
                    // Text("${routeList.length}")
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle selection logic here
                // You can use selectedArea and selectedRoute as needed
                setState(() {
                  _isLoading = true;
                });
                Navigator.of(context).pop();
                _fetchCust(selectedRoute?.routeId ?? "0");
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobileDevice = false;

    log("this is screen width $screenWidth");

    if (screenWidth <= 768) {
      setState(() {
        isMobileDevice = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Farmers"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAddOptionShow)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                heroTag: "af",
                onPressed: () {
                  var aId = selectedArea?.areaId ?? "0";
                  var rId = selectedRoute?.routeId ?? "0";

                  if(aId == "0" || rId == "0") {
                    Fluttertoast.showToast(msg: "Please select route!");
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddFarmerScreen(areaId: aId, routeId: rId)),
                  ).then((value) => value != null
                      ? _fetchCust(selectedRoute?.routeId ?? "0")
                      : false);
                },
                label: const Text("Add Farmer"),
              ),
            ),
          if (isAddOptionShow)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                heroTag: "ad",
                onPressed: () {
                  var aId = selectedArea?.areaId ?? "0";
                  var rId = selectedRoute?.routeId ?? "0";
                  if(aId == "0" || rId == "0") {
                    Fluttertoast.showToast(msg: "Please select route!");
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddDealerScreen(areaId: aId, routeId: rId)),
                  ).then((value) => value != null
                      ? _fetchCust(selectedRoute?.routeId ?? "0")
                      : false);
                },
                label: const Text("Add Dealer"),
              ),
            ),
          FloatingActionButton(
            heroTag: "a",
            onPressed: () {
              setState(() {
                isAddOptionShow = !isAddOptionShow;
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (!isMobileDevice)
              SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : custList.isEmpty
                            ? Center(
                                child: Text("No customers found!"),
                              )
                            : ListView.builder(
                                itemCount: custList.length,
                                itemBuilder: (context, index) {
                                  final cust = custList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (BuildContext context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCart(
                                                          itemId: cust.custId,
                                                        )),
                                              );
                                            },
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            icon: Icons.add_shopping_cart,
                                            label: 'Order',
                                          ),
                                          SlidableAction(
                                            onPressed: (BuildContext context) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddVisit(
                                                            itemId:
                                                                cust.custId)),
                                              );
                                            },
                                            backgroundColor: Colors.deepOrange,
                                            foregroundColor: Colors.white,
                                            icon: Icons.handshake_outlined,
                                            label: 'Visit',
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        child: ListTile(
                                            title: Text(cust.custShopName),
                                            subtitle: Text(cust.custMobNo)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  )),
                  Container(
                    color: Colors.black12,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: _showAreaRouteDialog,
                        child: Text(
                          'Route - ${selectedRoute?.routeName}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fetchCust(String routeId) async {
    // log("selected route - $routeId");

    CustomerResponse? response = await apiService.fetchCustomers(routeId);

    if (response != null) {
      if (response.success) {
        custList = response.result;
      } else {
        custList = [];
      }
    } else {
      custList = [];
    }
    setState(() {
      // custList = [];
      _isLoading = false;
    });
  }
}
