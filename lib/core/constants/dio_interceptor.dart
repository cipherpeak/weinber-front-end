import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../features/Authentication/Login/Api/login_repository.dart';
import '../../features/Authentication/Login/Model/hive_login_model.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(_AuthInterceptor());
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = AuthLocalStorage.instance.getAccessToken();

    // Attach token to every request
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // ---------- TOKEN EXPIRED ----------
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      bool refreshed = await _refreshToken();

      if (refreshed) {
        final newToken = AuthLocalStorage.instance.getAccessToken();
        requestOptions.headers["Authorization"] = "Bearer $newToken";

        final cloneRequest = await DioClient.dio.fetch(requestOptions);
        return handler.resolve(cloneRequest);
      }

      // ---------- TRY AUTO LOGIN ----------
      bool autoLogged = await _autoLogin();

      if (autoLogged) {
        final newToken = AuthLocalStorage.instance.getAccessToken();
        requestOptions.headers["Authorization"] = "Bearer $newToken";

        final cloneRequest = await DioClient.dio.fetch(requestOptions);
        return handler.resolve(cloneRequest);
      }
    }

    return handler.next(err);
  }

  // ======================================================
  //                      REFRESH TOKEN
  // ======================================================
  Future<bool> _refreshToken() async {
    final refresh = AuthLocalStorage.instance.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final response = await Dio(
        BaseOptions(baseUrl: ApiEndpoints.baseUrl),
      ).post("/auth/refresh/", data: {"refresh": refresh});

      if (response.statusCode == 200) {
        final access = response.data["access"];
        final newRefresh = response.data["refresh"] ?? refresh;

        await AuthLocalStorage.instance.saveLoginData(
          access: access,
          refresh: newRefresh,
          employeeId: AuthLocalStorage.instance.getEmployeeId() ?? "",
          employeeType: AuthLocalStorage.instance.getEmployeeType() ?? "",
          profilePic: AuthLocalStorage.instance.getProfilePic() ?? "",
          appIcon: AuthLocalStorage.instance.getAppIcon(),
          company: AuthLocalStorage.instance.getCompany() ?? "",
          role: AuthLocalStorage.instance.getRole() ?? "",
        );

        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  // ======================================================
  //                     AUTO LOGIN RETRY
  // ======================================================
  Future<bool> _autoLogin() async {
    final savedId = AuthLocalStorage.instance.getSavedEmployeeId();
    final savedPass = AuthLocalStorage.instance.getSavedPassword();

    if (savedId == null || savedPass == null) return false;

    try {
      final authRepo = AuthRepository();
      final res = await authRepo.login(
        employeeId: savedId,
        password: savedPass,
      );

      await AuthLocalStorage.instance.saveLoginData(
        access: res.access,
        refresh: res.refresh,
        employeeId: res.employee.employeeId,
        employeeType: res.employee.employeeType,
        profilePic: res.employee.profilePic,
        appIcon: res.employee.appIcon,
        company: res.employee.company,
        role: res.employee.role,
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
