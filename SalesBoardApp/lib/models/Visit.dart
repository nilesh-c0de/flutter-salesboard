class Visit {
  final String visitId;
  final String note;
  final String followupDate;
  final String storeName;
  final String ownerName;
  final String contact;
  final String user;

  Visit({
    required this.visitId,
    required this.note,
    required this.followupDate,
    required this.storeName,
    required this.ownerName,
    required this.contact,
    required this.user,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      visitId: json['visitId'],
      note: json['note'],
      followupDate: json['followupDate'],
      storeName: json['storeName'],
      ownerName: json['ownerName'],
      contact: json['contact'],
      user: json['user'],
    );
  }
}
