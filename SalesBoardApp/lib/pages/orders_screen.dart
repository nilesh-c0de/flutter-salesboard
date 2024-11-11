import 'package:flutter/material.dart';
import 'package:salesboardapp/TabSideBar.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/models/Order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  ApiService apiService = ApiService();

  List<OrderResult> orderList = [];

  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    getResponse();
  }

  getResponse() async {
    Order? response = await apiService.fetchUserOrders();
    if (response != null) {
      if (response.success == true) {
        orderList = response.result;
      }
    }
    isDataLoading = false;
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
        title: const Text("Orders"),
      ),
      body: Row(
        children: [
          if (!isMobileDevice) SizedBox(width: screenWidth / 3.5, child: drawerUi(context)),
          if (isDataLoading) const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!isDataLoading)
            Expanded(
              child: orderList.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          final order = orderList[index];
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  order.shopName.toUpperCase(),
                                  style: const TextStyle(color: Colors.indigo, fontSize: 18),
                                ),
                                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "${order.ownerName} (${order.phoneNumber})",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                    child: Text(
                                      order.orderDate,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                  //   child: Text(
                                  //     "Date - ${order.followupDate}",
                                  //     style: const TextStyle(
                                  //       fontSize: 18,
                                  //     ),
                                  //   ),
                                  // ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                  )
                  : const Center(child: Text("No Record Found")),
            ),
        ],
      ),
    );
  }
}
