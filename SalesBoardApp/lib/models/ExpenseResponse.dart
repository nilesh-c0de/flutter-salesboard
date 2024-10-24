class ExpenseResponse {

  final String allow_amt;
  final String allow_date;
  final String allow_name;
  final String spe_id;
  final String user_id;
  final String user_name;
  final String image;

  ExpenseResponse({
    required this.allow_amt,
    required this.allow_date,
    required this.allow_name,
    required this.spe_id,
    required this.user_id,
    required this.user_name,
    required this.image,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      allow_amt: json['allow_amt'],
      allow_date: json['allow_date'],
      allow_name: json['allow_name'],
      spe_id: json['spe_id'],
      user_id: json['user_id'],
      user_name: json['user_name'],
      image: json['image'],
    );
  }
}