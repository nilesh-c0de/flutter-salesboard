import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesboardapp/api_service.dart';
import 'package:salesboardapp/models/CartResponse.dart';
import 'package:salesboardapp/models/ProductResponse.dart';
import 'package:salesboardapp/pages/show_cart.dart';

class AddCart extends StatefulWidget {
  final String itemId;

  const AddCart({super.key, required this.itemId});

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  ApiService apiService = ApiService();
  List<String> typeList = ["Retail", "Wholesale"];
  String? selectedType;
  List<ProductItem> productList = [];
  ProductItem? selectedProduct = null;
  final TextEditingController noteController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    ProductResponse? response = await apiService.fetchProducts();
    if (response != null) {
      setState(() {
        productList = response.result;
      });

      print("product name - ${productList[0].productName}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add to cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(5),
                  //   borderSide: BorderSide(width: 1, color: Colors.grey)
                  // )
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 1, color: Colors.grey)
                    )

                ),
                hint: Text('Select Type'),
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue != null) selectedType = newValue;
                    print(selectedType);
                  });
                },
                items: typeList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    // enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    //     borderSide: BorderSide(width: 1, color: Colors.grey)
                    // ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 1, color: Colors.grey)
                    )
                ),
                hint: Text('Select a Product'),
                value: selectedProduct,
                onChanged: (ProductItem? newValue) {
                  setState(() {
                    selectedProduct = newValue;
                  });
                },
                items: productList
                    .map<DropdownMenuItem<ProductItem>>((ProductItem product) {
                  return DropdownMenuItem<ProductItem>(
                    value: product,
                    child: Text(product.productName),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: noteController,
              decoration: const InputDecoration(
                  hintText: "Quantity", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),

            _isLoading == true ?
                CircularProgressIndicator() :
            SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () {

                      setState(() {
                        _isLoading = true;
                      });
                      _addToCart();
                    },
                    child: Text("Submit"))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowCart(
                            itemId: widget.itemId,
                          )));
                    },
                    child: Text("SHOW CART")))
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    String type = "";
    if (selectedType == "Retail") {
      type = "R";
    } else if (selectedType == "Wholesale") {
      type = "W";
    }

    String pId = "0";
    final selectedProduct = this.selectedProduct;
    if(selectedProduct != null) {
      pId = selectedProduct.productId;
    }

    await Future.delayed(Duration(seconds: 3));

    String quantity = noteController.text;
    CartResponse? response = await apiService.addToCart(
        quantity, pId, widget.itemId, type, "0", "0");

    if(response != null) {
      if(response.success) {

        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: response.message);
        if (mounted) Navigator.pop(context, true);
      }
    }
  }
}
