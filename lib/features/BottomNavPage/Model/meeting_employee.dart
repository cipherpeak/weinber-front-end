class MeetingEmployee {
  final int id;
  final String name;
  final String? profilePic;
  final String role;
  final String employeeType;

  MeetingEmployee({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.role,
    required this.employeeType,
  });

  factory MeetingEmployee.fromJson(Map<String, dynamic> json) {
    return MeetingEmployee(
      id: int.parse(json["id"].toString()),
      name: json["employee_name"] ?? "No name",
      profilePic: json["profile_pic"],
      role: json["role"] ?? "",
      employeeType: json["employee_type"] ?? "",
    );
  }
}
