class Area {

  final String areaId;
  final String areaName;

  Area({
    required this.areaId,
    required this.areaName,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaId: json['area_id'],
      areaName: json['area_name'],
    );
  }

}