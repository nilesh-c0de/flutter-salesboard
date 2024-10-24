class MerchExpenseResponse {

  final String id;
  final String shop_name;
  final String march_name;
  final String quantity;
  final String price;
  final String added_by;

  MerchExpenseResponse({
    required this.id,
    required this.shop_name,
    required this.march_name,
    required this.quantity,
    required this.price,
    required this.added_by,
  });

  factory MerchExpenseResponse.fromJson(Map<String, dynamic> json) {
    return MerchExpenseResponse(
      id: json['id'],
      shop_name: json['shop_name'],
      march_name: json['march_name'],
      quantity: json['quantity'],
      price: json['price'],
      added_by: json['added_by'],
    );
  }
}