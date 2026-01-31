import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/attendance_day_details_model.dart';
import '../Model/attendance_monthly_model.dart';

class AttendanceRepositoryReview {
  /// ================= MONTHLY REVIEW (GET) =================
  Future<MonthlyReviewResponse> fetchMonthlyReview() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.monthlyReview,
      );

      print("✅ Monthly Review Response: ${res.data}");

      return MonthlyReviewResponse.fromJson(res.data);
    } on DioException catch (e) {
      final msg = _handleDioError(e, "Failed to load monthly review");
      throw Exception(msg);
    } catch (e, st) {
      print("❌ UNKNOWN ERROR IN fetchMonthlyReview => $e");
      print(st);
      throw Exception("Something went wrong");
    }
  }

  /// ================= ATTENDANCE BY DATE (POST) =================
  Future<AttendanceDayDetail> fetchAttendanceByDate({
    required int date,
    required int month,
    required int year,
  }) async {
    try {
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.monthlyReview,
        data: {
          "date": date,
          "month": month,
          "year": year,
        },
      );

      print("✅ Attendance By Date Response: ${res.data}");

      return AttendanceDayDetail.fromJson(res.data);
    } on DioException catch (e) {
      final msg = _handleDioError(e, "Failed to load attendance");
      throw Exception(msg);
    } catch (e, st) {
      print("❌ UNKNOWN ERROR IN fetchAttendanceByDate => $e");
      print(st);
      throw Exception("Something went wrong");
    }
  }

  /// ================= COMMON DIO ERROR HANDLER =================
  String _handleDioError(DioException e, String fallback) {
    print("❌ DIO ERROR");
    print("Message: ${e.message}");
    print("StatusCode: ${e.response?.statusCode}");
    print("Response: ${e.response?.data}");
    print("Headers: ${e.response?.headers}");

    return e.response?.data?["error"] ??
        e.response?.data?["message"] ??
        fallback;
  }
}
