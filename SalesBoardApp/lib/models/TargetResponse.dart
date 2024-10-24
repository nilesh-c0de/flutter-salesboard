class TargetResponse {

  final String user_id;
  final String user_name;
  final String target;
  final String month;
  final String year;
  final String quarter;

  TargetResponse({
    required this.user_id,
    required this.user_name,
    required this.target,
    required this.month,
    required this.year,
    required this.quarter,
  });

  factory TargetResponse.fromJson(Map<String, dynamic> json) {
    return TargetResponse(
      user_id: json['user_id'],
      user_name: json['user_name'],
      target: json['target'],
      month: json['month'],
      year: json['year'],
      quarter: json['quarter'],
    );
  }
}