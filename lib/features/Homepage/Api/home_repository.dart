import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Database/home_local_storage.dart';
import '../Model/homepage_response.dart';

class HomeRepository {
  final HomeLocalStorage local;

  HomeRepository(this.local);

  Future<HomeResponse> fetchHomeData() async {
    try {
      final response = await DioClient.dio.get(ApiEndpoints.home);

      final jsonString = jsonEncode(response.data);

      // Save JSON string to cache
      await local.saveHomeData(jsonString);

      // Convert map to string → then parse model
      return HomeResponse.fromRawJson(jsonString);
    }

    catch (e) {
      final cache = local.getHomeData();

      if (cache != null) {
        return HomeResponse.fromRawJson(cache);
      }

      rethrow;
    }
  }
}
