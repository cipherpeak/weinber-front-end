class TechnicianTaskStartDetails {
  final String taskId;
  final String machineInfo;
  final String bayNumber;
  final String startedAt;
  final String status;

  TechnicianTaskStartDetails({
    required this.taskId,
    required this.machineInfo,
    required this.bayNumber,
    required this.startedAt,
    required this.status,
  });

  factory TechnicianTaskStartDetails.fromJson(Map<String, dynamic> json) {
    return TechnicianTaskStartDetails(
      taskId: json["task_id"].toString(),
      machineInfo: json["machine_info"] ?? "",
      bayNumber: json["bay_number"] ?? "",
      startedAt: json["started_at"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
