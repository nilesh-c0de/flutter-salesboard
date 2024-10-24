class ExpenseType {
  final String stateId;
  final String stateName;

  ExpenseType({
    required this.stateId, required this.stateName
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      stateId: json['state_id'],
      stateName: json['state_name'],
    );
  }
}