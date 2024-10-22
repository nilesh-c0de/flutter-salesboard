import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/models/Route.dart';

import '../models/Area.dart';
import '../models/Customer.dart';
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
  late Future<List<Customer>> custList;

  List<Area> areaList = [];
  List<MyRoute> routeList = [];
  Area? selectedArea;
  MyRoute? selectedRoute;

  @override
  void initState() {
    super.initState();

    custList = Future.value([]);

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
    print("selected area - $area");

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
                      hint: Text('Select Area'),
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
                        ? Text("No routes present!")
                        : DropdownButton<MyRoute>(
                            isExpanded: true,
                            hint: Text('Select Route'),
                            value: selectedRoute,
                            onChanged: (MyRoute? value) {
                              setter(() {
                                selectedRoute = value;
                                print("route - ${selectedRoute?.routeName}");
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle selection logic here
                // You can use selectedArea and selectedRoute as needed
                Navigator.of(context).pop();
                _fetchCust(selectedRoute?.routeId ?? "0");
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmers"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        var aId = selectedArea?.areaId ?? "0";
        var rId = selectedRoute?.routeId ?? "0";
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFarmerScreen(areaId: aId, routeId: rId)),
        );
      },
        child: const Icon(Icons.add),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<List<Customer>>(
              future: custList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No records found.'));
                }
                final farmerData = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: farmerData.length,
                    itemBuilder: (context, index) {
                      final farmer = farmerData[index];

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
                                        builder: (context) => const AddCart()),
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
                                        builder: (context) => AddVisit(itemId: farmer.custId)),
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
                                title: Text("${farmer.custShopName}"),
                                subtitle: Text("${farmer.custMobNo}")),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.black12,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: _showAreaRouteDialog,
                child: Text(
                  'Route - ${selectedRoute?.routeName}',
                  style: TextStyle(
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
    );
  }

  _fetchCust(String routeId) {
    print("selected route - $routeId");
    custList = apiService.fetchCustomers(routeId);
    setState(() {});
  }
}
