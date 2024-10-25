import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/models/CartResponse.dart';

class ShowCart extends StatefulWidget {
  final String itemId;

  const ShowCart({super.key, required this.itemId});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  ApiService apiService = ApiService();
  List<CartResult> cartList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    CartResponse? response =
        await apiService.fetchCartItems(widget.itemId, "0");
    if (response != null) {
      setState(() {
        cartList = response.result;
      });

      print("product name - ${cartList[0].productId}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Items"),
      ),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) {
          final item = cartList[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                title: Text(item.productName, style: TextStyle(
                    fontSize: 18
                ),),
                subtitle: Text(
                  'Quantity: ${item.orderQty}, Weight: ${item.orderWeight}',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  '${item.prodRate}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
