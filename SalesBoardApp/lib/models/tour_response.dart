class TourResponse {
  final String month;
  final String user_name;
  final String tp_id;
  final String user_id;
  final String month_id;

  TourResponse({
    required this.month,
    required this.user_name,
    required this.tp_id,
    required this.user_id,
    required this.month_id,
  });

  factory TourResponse.fromJson(Map<String, dynamic> json) {
    return TourResponse(
      month: json['month'],
      user_name: json['user_name'],
      tp_id: json['tp_id'],
      user_id: json['user_id'],
      month_id: json['month_id'],
    );
  }

}