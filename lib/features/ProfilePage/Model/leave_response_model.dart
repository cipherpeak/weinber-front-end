class LeaveResponse {
  final int daysLeft;
  final int totalVacationDays;
  final int usedVacationDays;
  final int leaveTakenThisMonth;
  final int annualLeaveTaken;
  final List<LeaveItem> leaveRequests;
  final List<LeaveItem> leaveHistory;

  LeaveResponse({
    required this.daysLeft,
    required this.totalVacationDays,
    required this.usedVacationDays,
    required this.leaveTakenThisMonth,
    required this.annualLeaveTaken,
    required this.leaveRequests,
    required this.leaveHistory,
  });

  factory LeaveResponse.fromJson(Map<String, dynamic> json) {
    return LeaveResponse(
      daysLeft: json["days_left"] ?? 0,
      totalVacationDays: json["total_vacation_days"] ?? 0,
      usedVacationDays: json["used_vacation_days"] ?? 0,
      leaveTakenThisMonth: json["leave_taken_this_month"] ?? 0,
      annualLeaveTaken: json["annual_leave_taken"] ?? 0,
      leaveRequests: (json["leave_requests"] as List)
          .map((e) => LeaveItem.fromJson(e))
          .toList(),
      leaveHistory: (json["leave_history"] as List)
          .map((e) => LeaveItem.fromJson(e))
          .toList(),
    );
  }
}

class LeaveItem {
  final int id;
  final String category;
  final String startDate;
  final String status;
  final String reason;

  LeaveItem({
    required this.id,
    required this.category,
    required this.startDate,
    required this.status,
    required this.reason,
  });

  factory LeaveItem.fromJson(Map<String, dynamic> json) {
    return LeaveItem(
      id: json["id"],
      category: json["category"] ?? "",
      startDate: json["start_date"] ?? "",
      status: json["status"] ?? "",
      reason: json["reason"] ?? "",
    );
  }

}
