class TourItem {
  final String tp_id;
  final String area_id;
  final String route_id;
  final String area_name;
  final String route_name;
  final String tour_date;
  final String target_call;
  final String user_id;
  final String user_name;
  final String added_by;

  TourItem({
    required this.tp_id,
    required this.area_id,
    required this.route_id,
    required this.area_name,
    required this.route_name,
    required this.tour_date,
    required this.target_call,
    required this.user_id,
    required this.user_name,
    required this.added_by,
  });

  factory TourItem.fromJson(Map<String, dynamic> json) {
    return TourItem(
      tp_id: json['tp_id'],
      area_id: json['area_id'],
      route_id: json['route_id'],
      area_name: json['area_name'],
      route_name: json['route_name'],
      tour_date: json['tour_date'],
      target_call: json['target_call'],
      user_id: json['user_id'],
      user_name: json['user_name'],
      added_by: json['added_by'],
    );
  }

}