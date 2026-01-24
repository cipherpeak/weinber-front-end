import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';

class BreakRepository {

  Future<void> startBreak({
    required String breakType,
    required String date,
    required String time,
    required String location,
    required int duration,
    String? customType,
  }) async {
    try {
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.startBreak,
        data: {
          "break_start_time": time,
          "break_type": breakType.toLowerCase(),
          "date": date,
          "custom_break_type": customType ?? "",
          "location": location,
          "duration": "$duration min",
        },
      );

      print("✅ BREAK START RESPONSE => ${res.data}");
    } on DioException catch (e) {
      print("❌ BREAK START FAILED");
      print("STATUS => ${e.response?.statusCode}");
      print("DATA => ${e.response?.data}");
      print("HEADERS => ${e.response?.headers}");
      rethrow;
    }
  }

  Future<void> endBreak({
    required String date,
    required String time,
    required String location,
    required String reason,
  }) async {
    final payload = {
      "location": location,
      "date": date,
      "break_end_time": time,
      "end_reason": reason,
    };

    debugPrint("🟡 END BREAK API PAYLOAD => $payload");

    try {
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.endBreak,
        data: payload,
      );

      debugPrint("🟢 END BREAK RESPONSE => ${res.data}");

    } on DioException catch (e) {
      debugPrint("🔴 END BREAK ERROR => ${e.response?.data}");

      final msg = e.response?.data["error"] ??
          e.response?.data["message"] ??
          "Failed to end break";

      throw Exception(msg);
    }
  }



  Future<void> extendBreak({
    required String date,
    required String location,
    required int extraMinutes,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.extendBreak,
        data: {
          "duration": "$extraMinutes min",
          "location": location,
          "date": date,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ?? "Failed to extend break",
      );
    }
  }
}
