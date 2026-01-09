class ProfileResponse {
  final String employeeId;
  final String employeeName;
  final String profilePic;
  final String employeeType;

  ProfileResponse({
    required this.employeeId,
    required this.employeeName,
    required this.profilePic,
    required this.employeeType,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      employeeId: json["employeeId"] ?? "",
      employeeName: json["employee_name"] ?? "",
      profilePic: json["profile_pic"] ?? "",
      employeeType: json["employee_type"] ?? "",
    );
  }
}
