import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkIn,
        data: {
          "location": location,
          "check_date": checkDate,
          "check_time": checkTime,
          "time_zone": timeZone,
        },
      );

      debugPrint("✅ CHECK-IN STATUS: ${res.statusCode}");
      debugPrint("✅ CHECK-IN RESPONSE: ${res.data}");

    } on DioException catch (e) {
      debugPrint("❌ CHECK-IN DIO ERROR");
      debugPrint("Message: ${e.message}");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("Response: ${e.response?.data}");

      throw Exception(
        e.response?.data?["error"] ??
            e.response?.data?["message"] ??
            "Check-in failed",
      );
    } catch (e, st) {
      debugPrint("❌ CHECK-IN UNKNOWN ERROR: $e");
      debugPrintStack(stackTrace: st);
      throw Exception("Something went wrong during check-in");
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
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.checkOut,
        data: {
          "location": location,
          "check_date": checkDate,
          "check_time": checkTime,
          "time_zone": timeZone,
          "reason": reason,
        },
      );

      debugPrint("✅ CHECK-OUT STATUS: ${res.statusCode}");
      debugPrint("✅ CHECK-OUT RESPONSE: ${res.data}");

    } on DioException catch (e) {
      debugPrint("❌ CHECK-OUT DIO ERROR");
      debugPrint("Message: ${e.message}");
      debugPrint("StatusCode: ${e.response?.statusCode}");
      debugPrint("Response: ${e.response?.data}");

      throw Exception(
        e.response?.data?["error"] ??
            e.response?.data?["message"] ??
            "Check-out failed",
      );
    } catch (e, st) {
      debugPrint("❌ CHECK-OUT UNKNOWN ERROR: $e");
      debugPrintStack(stackTrace: st);
      throw Exception("Something went wrong during check-out");
    }
  }
}
