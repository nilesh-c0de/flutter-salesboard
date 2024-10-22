class Customer {

  final String custId;
  final String custShopName;
  final String custName;
  final String custMobNo;

  Customer({
    required this.custId,
    required this.custShopName,
    required this.custName,
    required this.custMobNo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custId: json['custId'],
      custShopName: json['custShopName'],
      custName: json['custName'],
      custMobNo: json['custMobNo'],
    );
  }
}
