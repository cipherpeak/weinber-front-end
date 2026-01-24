import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/meeting_employee.dart';
import '../Model/meeting_list_model.dart';

class MeetingRepository {

  /// 📋 GET MEETINGS
  Future<List<MeetingModel>> fetchMeetings() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.meetingList,
      );

      final list = res.data["meetings"] as List? ?? [];
      return list.map((e) => MeetingModel.fromJson(e)).toList();

    } on DioException catch (e) {
      debugPrint("❌ MEETING ERROR => ${e.response?.data}");
      throw Exception("Failed to load meetings");
    }
  }

  /// 👥 GET EMPLOYEES
  Future<List<MeetingEmployee>> fetchEmployees() async {
    try {
      final res = await DioClient.dio.get(

        ApiEndpoints.baseUrl+ApiEndpoints.employeeListForMeeting,
      );

      final list = res.data["employees"] as List? ?? [];

      return list.map((e) => MeetingEmployee.fromJson(e)).toList();

    } on DioException catch (e) {
      debugPrint("❌ EMPLOYEE ERROR => ${e.response?.data}");
      throw Exception("Failed to load employees");
    }
  }

  /// 📅 CREATE MEETING
  Future<void> createMeeting({
    required String title,
    required String date,
    required String time,
    required String location,
    required List<int> attendees,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.baseUrl+ApiEndpoints.createMeeting,
        data: {
          "title": title,
          "date": date,
          "time": time,
          "location": location,
          "attendees": attendees,
        },
      );
    } on DioException catch (e) {
      debugPrint("❌ CREATE MEETING ERROR => ${e.response?.data}");
      throw Exception(e.response?.data["message"] ?? "Failed to create meeting");
    }
  }
}
