class ReportedVehicleIssue {
  final int id;
  final String title;
  final String reportedDate;
  final String status;
  final String description;
  final String? image;

  ReportedVehicleIssue({
    required this.id,
    required this.title,
    required this.reportedDate,
    required this.status,
    required this.description,
    this.image,
  });

  factory ReportedVehicleIssue.fromJson(Map<String, dynamic> json) {
    return ReportedVehicleIssue(
      id: json["id"],
      title: json["title"] ?? "",
      reportedDate: json["reported_date"] ?? "",
      status: json["status"] ?? "",
      description: json["description"] ?? "",
      image: json["vehicle_issue_image"],
    );
  }
}
