class EmployeeInformationResponse {
  final String fullName;
  final String employeeId;
  final String department;
  final String profession;
  final String branchLocation;
  final String companyName;
  final String dateOfJoining;
  final String reportingManager;

  EmployeeInformationResponse({
    required this.fullName,
    required this.employeeId,
    required this.department,
    required this.profession,
    required this.branchLocation,
    required this.companyName,
    required this.dateOfJoining,
    required this.reportingManager,
  });

  factory EmployeeInformationResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeInformationResponse(
      fullName: json["full_name"] ?? "",
      employeeId: json["employee_id"] ?? "",
      department: json["department"] ?? "",
      profession: json["profession"] ?? "",
      branchLocation: json["branch_location"] ?? "",
      companyName: json["company_name"] ?? "",
      dateOfJoining: json["date_of_joining"] ?? "",
      reportingManager: json["reporting_manager"] ?? "",
    );
  }
}
