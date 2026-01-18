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

      return HomeResponse.fromJson(res.data);
    } catch (e, st) {
      print("❌ HOME API ERROR => $e");
      print("🧵 STACK TRACE => $st");
      rethrow;
    }
  }
}
