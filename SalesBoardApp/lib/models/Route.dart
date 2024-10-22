class MyRoute {

  final String routeId;
  final String routeName;

  MyRoute({
    required this.routeId,
    required this.routeName,
  });

  factory MyRoute.fromJson(Map<String, dynamic> json) {
    return MyRoute(
      routeId: json['route_id'],
      routeName: json['route_name'],
    );
  }

}