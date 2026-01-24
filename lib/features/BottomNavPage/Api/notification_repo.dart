import 'package:dio/dio.dart';
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
      final res = await DioClient.dio.get(

        ApiEndpoints.baseUrl + ApiEndpoints.notification,
        data: {
          "date": date,
          "month": month,
          "year": year,
        },
      );

      final list = res.data["data"] as List? ?? [];

      return list.map((e) => NotificationItem.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ?? "Failed to load notifications",
      );
    }
  }
}
