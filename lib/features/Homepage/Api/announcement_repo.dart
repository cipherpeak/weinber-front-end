import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';
import '../Model/announcement_model.dart';

class AnnouncementRepository {
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.companyAnnouncements,
      );

      final list = res.data["announcements"] as List;

      return list.map((e) => AnnouncementModel.fromJson(e)).toList();
    } on DioException catch (e, st) {
      print("❌ ANNOUNCEMENT ERROR => $e");
      print("🧵 STACK TRACE => $st");
      throw Exception("Failed to load announcements");
    }
  }
}
