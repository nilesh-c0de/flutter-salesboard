class Sales {
  final bool success;
  final String message;
  final List<SalesResult> result;

  Sales({
    required this.success,
    required this.message,
    required this.result,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      success: json['success'],
      message: json['message'],
      result: (json['result'] as List).map((item) => SalesResult.fromJson(item)).toList(),
    );
  }
}

class SalesResult {
  final String date;
  final String sales;

  SalesResult({
    required this.date,
    required this.sales,
  });

  factory SalesResult.fromJson(Map<String, dynamic> json) {
    return SalesResult(
      date: json['date'],
      sales: json['sales'],
    );
  }
}
