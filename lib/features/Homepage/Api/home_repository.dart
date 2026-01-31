import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';
import '../Model/homepage_response.dart';

class HomeRepository {
  Future<HomeResponse> fetchHome() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.home,
      );

      print("✅ HOME API SUCCESS: ${res.data}");

      return HomeResponse.fromJson(res.data);
    } on DioException catch (e) {
      print("❌ DIO ERROR IN HOME API");
      print("Message: ${e.message}");
      print("Status Code: ${e.response?.statusCode}");
      print("Response Data: ${e.response?.data}");
      print("Headers: ${e.response?.headers}");

      // 👇 Extract proper backend message
      final errorMessage =
          e.response?.data?["error"] ??
              e.response?.data?["message"] ??
              "Failed to load home data";

      throw Exception(errorMessage);
    } catch (e, st) {
      print("❌ UNKNOWN HOME ERROR: $e");
      print("🧵 STACK TRACE => $st");
      throw Exception("Something went wrong");
    }
  }
}

