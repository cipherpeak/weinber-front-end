class EmployeeInformationResponse {
  final String fullName;
  final String employeeId;
  final String employeeType;
  final String companyName;
  final String dateJoined;
  final String? companyLocation;

  EmployeeInformationResponse({
    required this.fullName,
    required this.employeeId,
    required this.employeeType,
    required this.companyName,
    required this.dateJoined,
    required this.companyLocation,
  });

  factory EmployeeInformationResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeInformationResponse(
      fullName: json["full_name"] ?? "",
      employeeId: json["employee_id"] ?? "",
      employeeType: json["employee_type"] ?? "",
      companyName: json["company_name"] ?? "",
      dateJoined: json["date_joined"] ?? "",
      companyLocation: json["company_location"],
    );
  }
}
