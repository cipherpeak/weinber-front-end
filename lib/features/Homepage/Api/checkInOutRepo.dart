import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';

class AttendanceRepository {

  /// ✅ CHECK IN
  static Future<void> checkIn({
    required String location,
    required String checkDate,
    required String checkTime,
    required String timeZone,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkIn,
        data: {
          "location": location,
          "check_date": checkDate,
          "check_time": checkTime,
          "time_zone": timeZone,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Check-in failed");
    }
  }

  /// ✅ CHECK OUT
  static Future<void> checkOut({
    required String location,
    required String checkDate,
    required String checkTime,
    required String timeZone,
    required String reason,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkOut,
        data: {
          "location": location,
          "check_date": checkDate,
          "check_time": checkTime,
          "time_zone": timeZone,
          "reason": reason,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Check-out failed");
    }
  }
}
