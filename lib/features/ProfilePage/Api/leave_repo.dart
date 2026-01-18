import 'package:dio/dio.dart';
import 'package:weinber/core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/leave_detail_model.dart';
import '../Model/leave_response_model.dart';

class LeaveRepository {
  Future<LeaveResponse> fetchLeaves() async {
    try {
      final res = await DioClient.dio.get(ApiEndpoints.leaveList);
      return LeaveResponse.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load leave data");
    }
  }
  /// ✅ Fetch leave details by ID
  Future<LeaveDetail> fetchLeaveDetails(int leaveId) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.leaveDetails}$leaveId/",
      );

      final parsed = LeaveDetailResponse.fromJson(res.data);
      return parsed.data;

    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Failed to load leave details",
      );
    }
  }

}
