

import 'package:hive/hive.dart';

class AuthLocalStorage {
  static const String authBoxName = "authBox";

  static const String accessKey = "accessToken";
  static const String refreshKey = "refreshToken";
  static const String employeeIdKey = "employeeId";
  static const String employeeTypeKey = "employeeType";
  static const String profilePicKey = "profilePic";
  static const String appIconKey = "appIcon";

  late Box box;

  Future<void> init() async {
    box = await Hive.openBox(authBoxName);
  }

  Future<void> saveLoginData({
    required String access,
    required String refresh,
    required String employeeId,
    required String employeeType,
    required String profilePic,
    required String appIcon,
  }) async {
    await box.put(accessKey, access);
    await box.put(refreshKey, refresh);
    await box.put(employeeIdKey, employeeId);
    await box.put(employeeTypeKey, employeeType);
    await box.put(profilePicKey, profilePic);
    await box.put(appIconKey, appIcon);
  }

  String? getAccessToken() => box.get(accessKey);

  Future<void> clear() async => box.clear();
}
