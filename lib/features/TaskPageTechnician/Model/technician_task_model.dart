class TechnicianTaskModel {
  final int id;
  final String machineType;
  final String siteNumber;
  final String bayNumber;
  final String? heading;
  final String status;

  TechnicianTaskModel({
    required this.id,
    required this.machineType,
    required this.siteNumber,
    required this.bayNumber,
    required this.heading,
    required this.status,
  });

  factory TechnicianTaskModel.fromJson(Map<String, dynamic> json) {
    return TechnicianTaskModel(
      id: json["id"] ?? 0,
      machineType: json["Machine_type"] ?? "",
      siteNumber: json["Site_number"] ?? "",
      bayNumber: json["bay_number"] ?? "",
      heading: json["heading"],
      status: json["status"] ?? "",
    );
  }
}
