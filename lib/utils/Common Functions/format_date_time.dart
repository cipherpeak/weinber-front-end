import 'package:flutter/material.dart';

String formatDateTime(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime).toLocal();
    return "${dateTime.day.toString().padLeft(2, '0')} "
        "${_monthName(dateTime.month)} "
        "${dateTime.year} • "
        "${_formatTime(dateTime)}";
  } catch (e) {
    return isoTime;
  }
}

String _monthName(int month) {
  const months = [
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];
  return months[month - 1];
}

String _formatTime(DateTime time) {
  int hour = time.hour > 12 ? time.hour - 12 : time.hour;
  String period = time.hour >= 12 ? "PM" : "AM";
  return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
}


String formatApiTime(String? time) {
  if (time == null || time.isEmpty) return "--:--";

  try {
    final parts = time.split(":");
    if (parts.length < 2) return time;

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    final isPM = hour >= 12;
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;

    final minStr = minute.toString().padLeft(2, '0');

    return "$displayHour:$minStr ${isPM ? "PM" : "AM"}";
  } catch (e) {
    return time; // fallback if something unexpected comes
  }
}

