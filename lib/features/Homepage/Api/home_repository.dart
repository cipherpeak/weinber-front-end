import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_endpoints.dart';
import '../Database/home_local_storage.dart';
import '../Model/homepage_response.dart';


class HomeRepository {
  final HomeLocalStorage local;

  HomeRepository(this.local);

  Future<HomeResponse> fetchHomeData(String token) async {
    final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.home}");

    try {
      final res = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        await local.saveHomeData(res.body);
        return HomeResponse.fromRawJson(res.body);
      }

      throw Exception("Failed to load home data");
    } catch (_) {
      // Offline → return cached
      final cache = local.getHomeData();
      if (cache != null) {
        return HomeResponse.fromRawJson(cache);
      }
      rethrow;
    }
  }
}
