class DaxStartDetails {
  final String serviceTitle;
  final String detailingSite;
  final DateTime createdAt;
  final List<DaxServiceCheck> services;

  DaxStartDetails({
    required this.serviceTitle,
    required this.detailingSite,
    required this.createdAt,
    required this.services,
  });

  factory DaxStartDetails.fromJson(Map<String, dynamic> json) {
    return DaxStartDetails(
      serviceTitle: json["service_title"],
      detailingSite: json["detailing_site"],
      createdAt: DateTime.parse(json["created_at"]),
      services: (json["services"] as List)
          .map((e) => DaxServiceCheck.fromJson(e))
          .toList(),
    );
  }
}

class DaxServiceCheck {
  final int id;
  final String name;
  final String detail;
  bool completed;

  DaxServiceCheck({
    required this.id,
    required this.name,
    required this.detail,
    required this.completed,
  });

  factory DaxServiceCheck.fromJson(Map<String, dynamic> json) {
    return DaxServiceCheck(
      id: json["id"],
      name: json["service_name"],
      detail: json["detail"] ?? "",
      completed: json["completed"] ?? false,
    );
  }
}

