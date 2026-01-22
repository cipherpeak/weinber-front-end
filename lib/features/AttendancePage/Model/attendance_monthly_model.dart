class MonthlyReviewResponse {
  final int monthlyProgressPercentage;
  final int totalDaysPresent;
  final int leaveTaken;
  final int tasksCompleted;
  final int pendingTasks;
  final String currentMonthName;
  final int currentYear;
  final String currentDate;
  final TodayAttendance todaysAttendance;

  MonthlyReviewResponse({
    required this.monthlyProgressPercentage,
    required this.totalDaysPresent,
    required this.leaveTaken,
    required this.tasksCompleted,
    required this.pendingTasks,
    required this.currentMonthName,
    required this.currentYear,
    required this.currentDate,
    required this.todaysAttendance,
  });

  factory MonthlyReviewResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyReviewResponse(
      monthlyProgressPercentage:
      int.tryParse(json["monthly_progress_percentage"].toString()) ?? 0,
      totalDaysPresent:
      int.tryParse(json["total_days_present"].toString()) ?? 0,
      leaveTaken: int.tryParse(json["leave_taken"].toString()) ?? 0,
      tasksCompleted:
      int.tryParse(json["tasks_completed"].toString()) ?? 0,
      pendingTasks: int.tryParse(json["pending_tasks"].toString()) ?? 0,
      currentMonthName: json["current_month_name"] ?? "",
      currentYear: int.tryParse(json["current_year"].toString()) ?? 0,
      currentDate: json["current_date"]?.toString() ?? "",
      todaysAttendance:
      TodayAttendance.fromJson(json["todays_attendance"] ?? {}),
    );
  }
}

class TodayAttendance {
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkoutReason;
  final String status;

  TodayAttendance({
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkoutReason,
    required this.status,
  });

  factory TodayAttendance.fromJson(Map<String, dynamic> json) {
    return TodayAttendance(
      checkInTime: json["check_in_time"],
      checkOutTime: json["check_out_time"],
      checkoutReason: json["checkout_reason"],
      status: json["status"] ?? "Unknown",
    );
  }
}
