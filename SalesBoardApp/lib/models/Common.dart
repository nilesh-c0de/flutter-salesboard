class Common {
  bool success;
  String message;

  Common({
    required this.success,
    required this.message
  });

  factory Common.fromJson(Map<String, dynamic> json) {
    return Common(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }
}