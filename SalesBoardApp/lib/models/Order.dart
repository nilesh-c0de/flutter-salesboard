class Order {
  final bool success;
  final String message;
  final List<OrderResult> result;

  Order({
    required this.success,
    required this.message,
    required this.result,
  });

  // Factory constructor to create an OrderResponse from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['result'] as List;
    List<OrderResult> resultList = list.map((i) => OrderResult.fromJson(i)).toList();

    return Order(
      success: json['success'],
      message: json['message'],
      result: resultList,
    );
  }

  // Method to convert OrderResponse to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'result': result.map((order) => order.toJson()).toList(),
    };
  }
}

class OrderResult {
  final String id;
  final String shopName;
  final String orderId;
  final String lat;
  final String long;
  final String userName;
  final String orderDate;
  final String ownerName;
  final String phoneNumber;

  OrderResult({
    required this.id,
    required this.shopName,
    required this.orderId,
    required this.lat,
    required this.long,
    required this.userName,
    required this.orderDate,
    required this.ownerName,
    required this.phoneNumber,
  });

  // Factory constructor to create an OrderResult from a JSON map
  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      id: json['id'],
      shopName: json['shop_name'],
      orderId: json['order_id'],
      lat: json['lat'],
      long: json['long'],
      userName: json['user_name'],
      orderDate: json['order_date'],
      ownerName: json['cust_name'],
      phoneNumber: json['phone_number'],
    );
  }

  // Method to convert OrderResult to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': shopName,
      'order_id': orderId,
      'lat': lat,
      'long': long,
      'user_name': userName,
      'order_date': orderDate,
      'cust_name': ownerName,
      'phone_number': phoneNumber,
    };
  }
}