import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/attendance_day_details_model.dart';
import '../Model/attendance_monthly_model.dart';


class AttendanceRepositoryReview {

  ///  Monthly review (GET)
  Future<MonthlyReviewResponse> fetchMonthlyReview() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.monthlyReview,

      );

      return MonthlyReviewResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Failed to load monthly review");
    }
  }

  ///  Attendance by date (POST)
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

      return AttendanceDayDetail.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Failed to load attendance");
    }
  }
}
