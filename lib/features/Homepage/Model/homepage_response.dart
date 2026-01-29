import 'dart:convert';

import 'dart:convert';

class HomeResponse {
  final String? name;
  final int notificationCount;
  final bool ongoingTask;
  final List<OngoingTask> ongoingTasks;

  final BreakTimer? breakTimer;
  final BreakHistory? breakHistory;

  final String statusOfCheck;
  final CheckInOut checkInOutTime;
  final int totalTasksToday;
  final List<Task> tasks;
  final List<Announcement> announcements;

  HomeResponse({
    this.name,
    required this.notificationCount,
    required this.ongoingTask,
    required this.ongoingTasks,
    this.breakTimer,
    this.breakHistory,
    required this.statusOfCheck,
    required this.checkInOutTime,
    required this.totalTasksToday,
    required this.tasks,
    required this.announcements,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      name: json["name"],
      notificationCount: json["notification_count"] ?? 0,
      ongoingTask: json["ongoing_task"] ?? false,

      ongoingTasks: (json["ongoing_tasks"] as List? ?? [])
          .map((e) => OngoingTask.fromJson(e))
          .toList(),

      breakTimer: json["break_timer"] == null
          ? null
          : BreakTimer.fromJson(json["break_timer"]),

      breakHistory: json["break_history"] == null
          ? null
          : BreakHistory.fromJson(json["break_history"]),

      statusOfCheck: json["status_of_check"] ?? "out",

      checkInOutTime:
      CheckInOut.fromJson(json["check_in_out_time"] ?? {}),

      totalTasksToday: json["total_no_of_tasks_today"] ?? 0,

      tasks: (json["tasks"] as List? ?? [])
          .map((e) => Task.fromJson(e))
          .toList(),

      announcements:
      (json["company_announcement_details"] as List? ?? [])
          .map((e) => Announcement.fromJson(e))
          .toList(),
    );
  }

  static HomeResponse fromRawJson(String str) =>
      HomeResponse.fromJson(json.decode(str));
}

/* -------------------------------------------------------------------------- */
/*                                ONGOING TASK                                */
/* -------------------------------------------------------------------------- */

class BreakTimer {
  final int id;
  final String breakType;
  final String? customBreakType;
  final String duration; // "25 min"
  final String breakStartTime; // "00:20:00"
  final String? breakEndTime;
  final String date;
  final String location;

  BreakTimer({
    required this.id,
    required this.breakType,
    required this.customBreakType,
    required this.duration,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.date,
    required this.location,
  });

  factory BreakTimer.fromJson(Map<String, dynamic> json) => BreakTimer(
    id: json["id"],
    breakType: json["break_type"] ?? "",
    customBreakType: json["custom_break_type"],
    duration: json["duration"] ?? "0 min",
    breakStartTime: json["break_start_time"] ?? "00:00:00",
    breakEndTime: json["break_end_time"],
    date: json["date"] ?? "",
    location: json["location"] ?? "",
  );

  /// helper for timer
  int get durationInMinutes {
    final number = RegExp(r'\d+').stringMatch(duration);
    return int.tryParse(number ?? "0") ?? 0;
  }
}

class BreakHistory {
  final String totalTime;
  final int numberOfExtendedBreaks;
  final List<BreakHistoryItem> history;

  BreakHistory({
    required this.totalTime,
    required this.numberOfExtendedBreaks,
    required this.history,
  });

  factory BreakHistory.fromJson(Map<String, dynamic> json) => BreakHistory(
    totalTime: json["total_break_time"] ?? "0h 0m",
    numberOfExtendedBreaks: json["number_of_extended_breaks"] ?? 0,
    history: (json["history"] as List? ?? [])
        .map((e) => BreakHistoryItem.fromJson(e))
        .toList(),
  );
}

class BreakHistoryItem {
  final int id;
  final String breakType;
  final String? customBreakType;
  final String duration;
  final String breakStartTime;
  final String? breakEndTime;
  final String date;
  final String location;

  BreakHistoryItem({
    required this.id,
    required this.breakType,
    this.customBreakType,
    required this.duration,
    required this.breakStartTime,
    required this.breakEndTime,
    required this.date,
    required this.location,
  });

  factory BreakHistoryItem.fromJson(Map<String, dynamic> json) =>
      BreakHistoryItem(
        id: json["id"],
        breakType: json["break_type"] ?? "",
        customBreakType: json["custom_break_type"],
        duration: json["duration"] ?? "0 min",
        breakStartTime: json["break_start_time"] ?? "",
        breakEndTime: json["break_end_time"],
        date: json["date"] ?? "",
        location: json["location"] ?? "",
      );
}


class OngoingTask {
  final String heading;
  final String status;
  final String address;
  final String taskAssignTime;
  final int percentageCompleted;
  final String? maintenanceHeading;

  OngoingTask({
    required this.heading,
    required this.status,
    required this.address,
    required this.taskAssignTime,
    required this.percentageCompleted,
    this.maintenanceHeading,
  });

  factory OngoingTask.fromJson(Map<String, dynamic> json) => OngoingTask(
    heading: json["heading"] ?? "",
    status: json["status"] ?? "",
    address: json["address"] ?? "",
    taskAssignTime: json["task_assign_time"] ?? "",
    percentageCompleted: json["percentage_completed"] ?? 0,
    maintenanceHeading: json["maintenance_heading"] ?? '',
  );
}

/* -------------------------------------------------------------------------- */
/*                                   TASKS                                    */
/* -------------------------------------------------------------------------- */

class Task {
  final String type;
  final String heading;
  final String details;
  final String time;

  Task({
    required this.type,
    required this.heading,
    required this.details,
    required this.time,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    type: json["type_of_task"] ?? "",
    heading: json["heading"] ?? "",
    details: json["address_or_sub_details"] ?? "",
    time: json["time_of_task"] ?? "",
  );
}

/* -------------------------------------------------------------------------- */
/*                              ANNOUNCEMENTS                                 */
/* -------------------------------------------------------------------------- */

class Announcement {
  final int id;
  final String heading;
  final String description;
  final String date;

  Announcement({
    required this.id,
    required this.heading,
    required this.description,
    required this.date,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json["id"] ?? 0,
    heading: json["heading"] ?? "",
    description: json["description"] ?? "",
    date: json["date"] ?? "",
  );
}

/* -------------------------------------------------------------------------- */
/*                            CHECK IN / CHECK OUT                            */
/* -------------------------------------------------------------------------- */

class CheckInOut {
  final CheckTime checkIn;
  final CheckTime checkOut;

  CheckInOut({
    required this.checkIn,
    required this.checkOut,
  });

  factory CheckInOut.fromJson(Map<String, dynamic> json) => CheckInOut(
    checkIn: CheckTime.fromJson(json["check_in"] ?? {}),
    checkOut: CheckTime.fromJson(json["check_out"] ?? {}),
  );
}

class CheckTime {
  final String? time;
  final String? timeZone;
  final String? location;
  final String? reason;

  CheckTime({this.time, this.timeZone, this.location, this.reason});

  factory CheckTime.fromJson(Map<String, dynamic> json) => CheckTime(
    time: json["time"],
    timeZone: json["time_zone"],
    location: json["location"],
    reason: json["reason"],
  );
}

