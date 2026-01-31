class DaxTaskModel {
  final int id;
  final String detailingSite;
  final String serviceName;
  final String status;

  DaxTaskModel({
    required this.id,
    required this.detailingSite,
    required this.serviceName,
    required this.status,
  });

  factory DaxTaskModel.fromJson(Map<String, dynamic> json) {
    return DaxTaskModel(
      id: json["id"],
      detailingSite: json["detailing_site"],
      serviceName: json["service_name"] ?? "Service",
      status: json["status"] ?? "not_started",
    );
  }
}
