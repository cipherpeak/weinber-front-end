import 'package:hive/hive.dart';

class BreakLocalStorage {
  static const String _boxName = "breakBox";

  static const String _kBreakType = "breakType";
  static const String _kStartTime = "startTime";
  static const String _kAllowedMinutes = "allowedMinutes";


  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> saveBreak({
    required String breakType,
    required DateTime startTime,
    required int allowedMinutes,
  }) async {
    await _box.put(_kBreakType, breakType);
    await _box.put(_kStartTime, startTime.toUtc().toIso8601String());
    await _box.put(_kAllowedMinutes, allowedMinutes);
  }

  static bool hasBreak() {
    if (!Hive.isBoxOpen(_boxName)) return false;
    return _box.containsKey(_kStartTime);
  }

  static DateTime? getStartTime() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final v = _box.get(_kStartTime);
    return v == null ? null : DateTime.parse(v);
  }

  static int getAllowedMinutes() {
    if (!Hive.isBoxOpen(_boxName)) return 0;
    return _box.get(_kAllowedMinutes, defaultValue: 0);
  }

  static String getBreakType() {
    if (!Hive.isBoxOpen(_boxName)) return "";
    return _box.get(_kBreakType, defaultValue: "");
  }

  /// ✅ Clears only break-related data
  static Future<void> clear() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    await _box.delete(_kBreakType);
    await _box.delete(_kStartTime);
    await _box.delete(_kAllowedMinutes);
  }
}
