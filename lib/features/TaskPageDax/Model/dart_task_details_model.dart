class DaxTaskDetails {
  final int id;
  final String serviceTitle;
  final List<DaxSubService> services;
  final String detailingSite;
  final String remarks;
  final String chassisNo;
  final String vehicleModel;
  final String? invoiceImage;

  DaxTaskDetails({
    required this.id,
    required this.serviceTitle,
    required this.services,
    required this.detailingSite,
    required this.remarks,
    required this.chassisNo,
    required this.vehicleModel,
    this.invoiceImage,
  });

  factory DaxTaskDetails.fromJson(Map<String, dynamic> json) {
    return DaxTaskDetails(
      id: json["id"],
      serviceTitle: json["service_title"],
      services: (json["services"] as List)
          .map((e) => DaxSubService.fromJson(e))
          .toList(),
      detailingSite: json["detailing_site"],
      remarks: json["remarks"] ?? "",
      chassisNo: json["chassis_no"] ?? "",
      vehicleModel: json["vehicle_model"] ?? "",
      invoiceImage: json["invoice_pr_image"],
    );
  }
}

class DaxSubService {
  final int id;
  final String serviceName;
  final String detail;
  final bool completed;

  DaxSubService({
    required this.id,
    required this.serviceName,
    required this.detail,
    required this.completed,
  });

  factory DaxSubService.fromJson(Map<String, dynamic> json) {
    return DaxSubService(
      id: json["id"],
      serviceName: json["service_name"],
      detail: json["detail"] ?? "",
      completed: json["completed"] ?? false,
    );
  }
}
