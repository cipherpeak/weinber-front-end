import 'package:hive/hive.dart';

class AuthLocalStorage {
  AuthLocalStorage._privateConstructor();
  static final AuthLocalStorage instance = AuthLocalStorage._privateConstructor();

  static const String authBoxName = "authBox";

  static const String accessKey = "accessToken";
  static const String refreshKey = "refreshToken";
  static const String employeeIdKey = "employeeId";
  static const String employeeTypeKey = "employeeType";
  static const String profilePicKey = "profilePic";
  static const String appIconKey = "appIcon";
  static const String companyKey = "company";     // ✅ NEW
  static const String roleKey = "role";           // ✅ NEW

  static const String savedEmployeeIdKey = "savedEmployeeId";
  static const String savedPasswordKey = "savedPassword";

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
    required String? appIcon,
    required String company,
    required String role,
  }) async {
    await box.put(accessKey, access);
    await box.put(refreshKey, refresh);
    await box.put(employeeIdKey, employeeId);
    await box.put(employeeTypeKey, employeeType);
    await box.put(profilePicKey, profilePic);
    await box.put(appIconKey, appIcon);
    await box.put(companyKey, company);
    await box.put(roleKey, role);
  }

  Future<void> saveCredentials(String id, String pass) async {
    await box.put(savedEmployeeIdKey, id);
    await box.put(savedPasswordKey, pass);
  }

  String? getAccessToken() => box.get(accessKey);
  String? getRefreshToken() => box.get(refreshKey);

  String? getEmployeeId() => box.get(employeeIdKey);
  String? getEmployeeType() => box.get(employeeTypeKey);
  String? getProfilePic() => box.get(profilePicKey);
  String? getAppIcon() => box.get(appIconKey);
  String? getCompany() => box.get(companyKey);   // ✅
  String? getRole() => box.get(roleKey);         // ✅

  String? getSavedEmployeeId() => box.get(savedEmployeeIdKey);
  String? getSavedPassword() => box.get(savedPasswordKey);

  Future<void> clear() async => box.clear();
}
