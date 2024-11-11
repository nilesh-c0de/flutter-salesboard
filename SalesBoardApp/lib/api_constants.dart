class ApiConstants {
  // base url
  static const String baseUrl = 'http://salesboard.in/solufinephp/new/';

  // login
  static const String loginEndPoint = '$baseUrl/login_new.php';

  // attendanceStatus
  static const String attendanceStatus = '$baseUrl/sale_call_count.php';

  // mark attendance
  static const String markAttendanceEndPoint = '$baseUrl/new_mark_attendance.php';

  // stores
  static const String storeEndPoint = '$baseUrl/view_store.php';

  // visits
  static const String visitsEndPoint = '$baseUrl/visits_new.php';

  // orders
  static const String ordersEndPoint = '$baseUrl/orders.php';

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

  static const String tourPlanInDetailsEndPoint = '$baseUrl/tour/view_tour_plan.php';
  static const String expenseTypesEndPoint = '$baseUrl/expense/expaddUserEndPointenses_type.php';

  static const String addExpenseEndPoint = '$baseUrl/expense/save_expenses.php';
  static const String showExpensesEndPoint = '$baseUrl/expense/expenses.php';
  static const String merchExpensesEndPoint = '$baseUrl/merchandise/merch_expense.php';
  static const String targetsEndPoint = '$baseUrl/targets.php';
  static const String addToCartEndPoint = '$baseUrl/cart_page/cart.php';
  static const String cartItemsEndPoint = '$baseUrl/cart_page/cart_items.php';
  static const String addUserEndPoint = '$baseUrl/add_new_user.php';


  static const String deleteUserEndPoint = '$baseUrl/delete_user.php';

  static const String dashboardUserEndPoint = '$baseUrl/dashboard.php';
}
