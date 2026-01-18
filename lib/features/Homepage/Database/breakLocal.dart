import 'package:hive/hive.dart';

class BreakLocalStorage {
  static const String _boxName = "breakBox";

  // 🔹 Save break info
  static Future<void> saveBreak({
    required String breakType,
    required DateTime startTime,
    required int allowedMinutes,
  }) async {
    final box = Hive.box(_boxName);

    await box.put("breakType", breakType);
    await box.put("startTime", startTime.toIso8601String());
    await box.put("allowedMinutes", allowedMinutes);
  }


  static Future<void> extendLocalBreak(int extraMinutes) async {
    final box = Hive.box(_boxName);
    final current = box.get("allowedMinutes", defaultValue: 0);
    await box.put("allowedMinutes", current + extraMinutes);
  }

  // 🔹 Check if break exists
  static bool hasBreak() {
    final box = Hive.box(_boxName);
    return box.containsKey("startTime");
  }

  // 🔹 Getters
  static DateTime? getStartTime() {
    final box = Hive.box(_boxName);
    final value = box.get("startTime");
    if (value == null) return null;
    return DateTime.parse(value);
  }

  static int getAllowedMinutes() {
    final box = Hive.box(_boxName);
    return box.get("allowedMinutes", defaultValue: 0);
  }

  static String getBreakType() {
    final box = Hive.box(_boxName);
    return box.get("breakType", defaultValue: "");
  }

  // 🔹 Clear break (when ended)
  static Future<void> clear() async {
    final box = Hive.box(_boxName);
    await box.delete("breakType");
    await box.delete("startTime");
    await box.delete("allowedMinutes");
  }
}
