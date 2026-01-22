class AttendanceDayDetail {
  final String status;
  final String date;
  final List<AttendanceHistory> history;

  AttendanceDayDetail({
    required this.status,
    required this.date,
    required this.history,
  });

  factory AttendanceDayDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDayDetail(
      status: json["status"] ?? "",
      date: json["date"] ?? "",
      history: (json["history"] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => AttendanceHistory.fromJson(e))
          .toList(),
    );
  }
}

class AttendanceHistory {
  final int id;
  final String type;
  final String time;
  final String? reason;
  final String location;

  AttendanceHistory({
    required this.id,
    required this.type,
    required this.time,
    required this.reason,
    required this.location,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceHistory(
      id: int.tryParse(json["id"].toString()) ?? 0,
      type: json["type"] ?? "",
      time: json["time"] ?? "",
      reason: json["reason"],
      location: json["location"] ?? "",
    );
  }
}
