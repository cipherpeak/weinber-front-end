import 'package:weinber/core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
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
}
