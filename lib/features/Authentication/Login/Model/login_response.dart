class LoginResponse {
  final bool success;
  final String message;
  final String access;
  final String refresh;
  final Employee employee;

  LoginResponse({
    required this.success,
    required this.message,
    required this.access,
    required this.refresh,
    required this.employee,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      access: json["access"] ?? "",
      refresh: json["refresh"] ?? "",
      employee: Employee.fromJson(json["employee"]),
    );
  }
}

class Employee {
  final String employeeId;
  final String employeeType;
  final String profilePic;
  final String appIcon;

  Employee({
    required this.employeeId,
    required this.employeeType,
    required this.profilePic,
    required this.appIcon,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json["employeeId"] ?? "",
      employeeType: json["employee_type"] ?? "",
      profilePic: json["profile_pic"] ?? "",
      appIcon: json["app_icon"] ?? "",
    );
  }
}
