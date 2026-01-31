import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications({
    required int date,
    required int month,
    required int year,
  }) async {
    try {
      final res = await DioClient.dio.request(
        ApiEndpoints.baseUrl + ApiEndpoints.notification,
        data: {
          "date": date,
          "month": month,
          "year": year,
        },
        options: Options(method: 'GET'),
      );

      debugPrint("✅ STATUS: ${res.statusCode}");
      debugPrint("✅ RESPONSE: ${res.data}");

      final list = res.data["data"] as List? ?? [];

      return list.map((e) => NotificationItem.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint("❌ DIO ERROR: ${e.response?.data}");
      throw Exception(
        e.response?.data?["error"] ??
            e.response?.data?["message"] ??
            "Failed to load notifications",
      );
    }
  }

}
