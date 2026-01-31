import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/meeting_employee.dart';
import '../Model/meeting_list_model.dart';

class MeetingRepository {

  // ================= COMMON ERROR HANDLER =================
  Exception _handleDioError(DioException e, String fallback) {
    debugPrint("❌ DIO ERROR");
    debugPrint("StatusCode: ${e.response?.statusCode}");
    debugPrint("Response: ${e.response?.data}");

    final msg = e.response?.data?["error"] ??
        e.response?.data?["message"] ??
        fallback;

    return Exception(msg);
  }

  // ================= FETCH MEETINGS =================
  Future<List<MeetingModel>> fetchMeetings() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.meetingList,
      );

      debugPrint("✅ MEETINGS RESPONSE => ${res.data}");

      final list = res.data["meetings"] as List? ?? [];

      return list.map((e) => MeetingModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, "Failed to load meetings");
    } catch (e, s) {
      debugPrint("❌ UNKNOWN ERROR => $e");
      debugPrintStack(stackTrace: s);
      throw Exception("Something went wrong");
    }
  }

  // ================= FETCH EMPLOYEES =================
  Future<List<MeetingEmployee>> fetchEmployees() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.employeeListForMeeting,
      );

      debugPrint("✅ EMPLOYEES RESPONSE => ${res.data}");

      final list = res.data["employees"] as List? ?? [];

      return list.map((e) => MeetingEmployee.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, "Failed to load employees");
    } catch (e, s) {
      debugPrint("❌ UNKNOWN ERROR => $e");
      debugPrintStack(stackTrace: s);
      throw Exception("Something went wrong");
    }
  }

  // ================= CREATE MEETING =================
  Future<void> createMeeting({
    required String title,
    required String date,
    required String time,
    required String location,
    required List<int> attendees,
  }) async {
    try {
      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.createMeeting,
        data: {
          "title": title,
          "date": date,
          "time": time,
          "location": location,
          "attendees": attendees,
        },
      );

      debugPrint("✅ CREATE MEETING RESPONSE => ${res.data}");
    } on DioException catch (e) {
      throw _handleDioError(e, "Failed to create meeting");
    } catch (e, s) {
      debugPrint("❌ UNKNOWN ERROR => $e");
      debugPrintStack(stackTrace: s);
      throw Exception("Something went wrong");
    }
  }
}
