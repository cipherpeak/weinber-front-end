import 'dart:convert';

class HomeResponse {
  final String name;
  final String role;
  final String employeeType;
  final int notificationCount;
  final bool ongoingTask;
  final List<OngoingTask> ongoingTasks;
  final String statusOfCheck;
  final CheckInOut checkInOutTime;
  final int totalTasksToday;
  final List<Task> tasks;
  final List<Announcement> announcements;

  HomeResponse({
    required this.name,
    required this.role,
    required this.employeeType,
    required this.notificationCount,
    required this.ongoingTask,
    required this.ongoingTasks,
    required this.statusOfCheck,
    required this.checkInOutTime,
    required this.totalTasksToday,
    required this.tasks,
    required this.announcements,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      employeeType: json["employee_type"] ?? "",
      notificationCount: json["notification_count"] ?? 0,
      ongoingTask: json["ongoing_task"] ?? false,
      ongoingTasks: (json["ongoing_tasks"] as List? ?? [])
          .map((e) => OngoingTask.fromJson(e))
          .toList(),
      statusOfCheck: json["status_of_check"] ?? "",
      checkInOutTime: CheckInOut.fromJson(json["check_in_out_time"]),
      totalTasksToday: json["total_no_of_tasks_today"] ?? 0,
      tasks: (json["tasks"] as List? ?? [])
          .map((e) => Task.fromJson(e))
          .toList(),
      announcements: (json["company_announcement_details"] as List? ?? [])
          .map((e) => Announcement.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "employee_type": employeeType,
    "notification_count": notificationCount,
    "ongoing_task": ongoingTask,
    "ongoing_tasks": ongoingTasks.map((e) => e.toJson()).toList(),
    "status_of_check": statusOfCheck,
    "check_in_out_time": checkInOutTime.toJson(),
    "total_no_of_tasks_today": totalTasksToday,
    "tasks": tasks.map((e) => e.toJson()).toList(),
    "company_announcement_details":
    announcements.map((e) => e.toJson()).toList(),
  };

  static HomeResponse fromRawJson(String str) =>
      HomeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class OngoingTask {
  final String heading;
  final String status;
  final String address;
  final String taskAssignTime;
  final int percentageCompleted;

  OngoingTask({
    required this.heading,
    required this.status,
    required this.address,
    required this.taskAssignTime,
    required this.percentageCompleted,
  });

  factory OngoingTask.fromJson(Map<String, dynamic> json) => OngoingTask(
    heading: json["heading"] ?? "",
    status: json["status"] ?? "",
    address: json["address"] ?? "",
    taskAssignTime: json["task_assign_time"] ?? "",
    percentageCompleted: json["percentage_completed"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "status": status,
    "address": address,
    "task_assign_time": taskAssignTime,
    "percentage_completed": percentageCompleted,
  };
}

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

  Map<String, dynamic> toJson() => {
    "type_of_task": type,
    "heading": heading,
    "address_or_sub_details": details,
    "time_of_task": time,
  };
}

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
    id: json["id"],
    heading: json["heading"],
    description: json["description"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "description": description,
    "date": date,
  };
}

class CheckInOut {
  final CheckTime checkIn;
  final CheckTime checkOut;

  CheckInOut({
    required this.checkIn,
    required this.checkOut,
  });

  factory CheckInOut.fromJson(Map<String, dynamic> json) => CheckInOut(
    checkIn: CheckTime.fromJson(json["check_in"]),
    checkOut: CheckTime.fromJson(json["check_out"]),
  );

  Map<String, dynamic> toJson() => {
    "check_in": checkIn.toJson(),
    "check_out": checkOut.toJson(),
  };
}

class CheckTime {
  final String? time;
  final String? timeZone;
  final String? location;

  CheckTime({this.time, this.timeZone, this.location});

  factory CheckTime.fromJson(Map<String, dynamic> json) => CheckTime(
    time: json["time"],
    timeZone: json["time_zone"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "time_zone": timeZone,
    "location": location,
  };
}
