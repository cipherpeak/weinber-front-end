import 'package:hive/hive.dart';

class HomeLocalStorage {
  static const String boxName = "homeBox";
  late Box box;

  Future<void> init() async {
    box = await Hive.openBox(boxName);
  }

  Future<void> saveHomeData(String rawJson) async {
    await box.put("home_response", rawJson);
  }

  String? getHomeData() => box.get("home_response");

  Future<void> clear() async => box.clear();
}
