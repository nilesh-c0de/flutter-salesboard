class CustomerResponse {

  final bool success;
  final String message;
  final List<CustomerItem> result;

  CustomerResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      success: json['success'],
      message: json['message'],
      result: (json['result'] as List).map((item) => CustomerItem.fromJson(item)).toList(),
    );
  }

}

class CustomerItem {
  final String custId;
  final String custShopName;
  final String custName;
  final String custMobNo;

  CustomerItem({
    required this.custId,
    required this.custShopName,
    required this.custName,
    required this.custMobNo,
  });

  factory CustomerItem.fromJson(Map<String, dynamic> json) {
    return CustomerItem(
      custId: json['custId'],
      custShopName: json['custShopName'],
      custName: json['custName'],
      custMobNo: json['custMobNo'],
    );
  }
}