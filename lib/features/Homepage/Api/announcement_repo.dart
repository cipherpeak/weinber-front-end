import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';
import '../Model/announcement_model.dart';

class AnnouncementRepository {
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.companyAnnouncements,
      );

      debugPrint("✅ ANNOUNCEMENTS STATUS: ${res.statusCode}");
      debugPrint("✅ ANNOUNCEMENTS RESPONSE: ${res.data}");

      final list = res.data["announcements"] as List? ?? [];

      return list
          .map((e) => AnnouncementModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint("❌ ANNOUNCEMENT DIO ERROR");
      debugPrint("Message: ${e.message}");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("Response: ${e.response?.data}");

      throw Exception(
        e.response?.data?["error"] ??
            e.response?.data?["message"] ??
            "Failed to load announcements",
      );
    } catch (e, st) {
      debugPrint("❌ ANNOUNCEMENT UNKNOWN ERROR: $e");
      debugPrintStack(stackTrace: st);

      throw Exception("Something went wrong while loading announcements");
    }
  }
}
