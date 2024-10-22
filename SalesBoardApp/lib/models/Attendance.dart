class Attendance {

  final String aId;
  final String aDate;
  final String aInTime;
  final String aOutTime;

  Attendance({
    required this.aId,
    required this.aDate,
    required this.aInTime,
    required this.aOutTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      aId: json['id'],
      aDate: json['date'],
      aInTime: json['start_time'],
      aOutTime: json['end_time'],
    );
  }
}