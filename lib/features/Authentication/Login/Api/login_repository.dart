import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';
import '../Model/login_response.dart';

class AuthRepository {
  Future<LoginResponse> login({
    required String employeeId,
    required String password,
  }) async {
    try {
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
        data: {
          "employeeId": employeeId,
          "password": password,
        },
      );

      print("✅ LOGIN SUCCESS => ${res.data}");

      return LoginResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("❌ LOGIN DIO ERROR");
      print("Status: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");

      final msg = e.response?.data?["error"] ??
          e.response?.data?["message"] ??
          "Login failed";

      throw Exception(msg);
    } catch (e, st) {
      print("❌ UNKNOWN LOGIN ERROR => $e");
      print(st);
      throw Exception("Something went wrong");
    }
  }
}
