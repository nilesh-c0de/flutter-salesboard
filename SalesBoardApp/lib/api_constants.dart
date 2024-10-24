class ApiConstants {
  // base url
  static const String baseUrl = 'http://salesboard.in/solufinephp/new/';

  // login
  static const String loginEndPoint = '$baseUrl/login_new.php';

  // attendanceStatus
  static const String attendanceStatus = '$baseUrl/sale_call_count.php';

  // mark attendance
  static const String markAttendanceEndPoint =
      '$baseUrl/new_mark_attendance.php';

  // stores
  static const String storeEndPoint = '$baseUrl/view_store.php';

  // visits
  static const String visitsEndPoint = '$baseUrl/visits_new.php';

  // attendance
  static const String attendanceEndPoint = '$baseUrl/attendance.php';

  static const String addFarmerEndPoint = '$baseUrl/add_store_new.php';
  static const String addVisitEndPoint = '$baseUrl/visit/add_visit.php';
  static const String getBrochureEndPoint = '$baseUrl/brochures.php';
  static const String getProbEndPoint = '$baseUrl/probs/get_prob.php';
  static const String getProbTypeEndPoint = '$baseUrl/probs/prob_type.php';
  static const String addProbEndPoint = '$baseUrl/probs/add_prob.php';
  static const String addLeaveEndPoint = '$baseUrl/user_profile/save_leave.php';
  static const String getLeaveEndPoint = '$baseUrl/leave/get_leaves.php';

  // add tour plans
  static const String addTourPlanEndPoint = '$baseUrl/tour/add_tour.php';
  static const String viewTourPlanEndPoint = '$baseUrl/tour/tours.php';
  static const String tourPlanInDetailsEndPoint =
      '$baseUrl/tour/view_tour_plan.php.php';
  static const String expenseTypesEndPoint =
      '$baseUrl/expense/expenses_type.php';
}
