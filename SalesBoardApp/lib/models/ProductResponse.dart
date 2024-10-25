class ProductResponse {
  bool success;
  String message;
  List<ProductItem> result;

  ProductResponse({
    required this.success,
    required this.message,
    required this.result,
});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {

    // Check if 'result' exists and is a list, then map it to List<ProductItem>
    var resultJson = json['result'] as List<dynamic>? ?? [];
    List<ProductItem> products = resultJson
        .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return ProductResponse(
      success: json['success'],
      message: json['message'],
      result: products
    );
  }
}


class ProductItem {
  String productId;
  String productName;

  ProductItem({
    required this.productId,
    required this.productName,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: json['product_id'],
      productName: json['product_name'],
    );
  }
}