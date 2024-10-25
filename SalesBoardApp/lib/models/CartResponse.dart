class CartResponse {
  final bool success;
  final String message;
  final List<CartResult> result;

  CartResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'],
      message: json['message'],
      result: (json['result'] as List)
          .map((item) => CartResult.fromJson(item))
          .toList(),
    );
  }
}

class CartResult {
  final String orderDet;
  final String productId;
  final String productName;
  final String orderWeight;
  final String prodRate;
  final String orderQty;

  CartResult({
    required this.orderDet,
    required this.productId,
    required this.productName,
    required this.orderWeight,
    required this.prodRate,
    required this.orderQty,
  });

  factory CartResult.fromJson(Map<String, dynamic> json) {
    return CartResult(
      orderDet: json['order_det'],
      productId: json['product_id'],
      productName: json['product_name'],
      orderWeight: json['order_weight'],
      prodRate: json['prodRate'],
      orderQty: json['order_qty'],
    );
  }
}
