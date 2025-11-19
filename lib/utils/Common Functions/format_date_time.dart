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
