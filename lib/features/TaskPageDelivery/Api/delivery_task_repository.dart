import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/delivery_task_details_model.dart';
import '../Model/delivery_task_model.dart';
import '../Model/delivery_task_start_details_model.dart';

class DeliveryTaskRepository {
  Future<DeliveryTaskResponse> fetchDeliveryTasks() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + "/task/delivery/",
      );

      return DeliveryTaskResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ?? "Failed to load delivery tasks",
      );
    }
  }

  Future<DeliveryTaskDetails> fetchDeliveryTaskDetails(int id) async {
    try {
      print(id);
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/$id/delivery/",
      );

      return DeliveryTaskDetails.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load task details");
    }
  }

  Future<void> startDeliveryTask({required int taskId}) async {
    try {
      final url = "${ApiEndpoints.baseUrl}/task/$taskId/start/";

      debugPrint(" START TASK API => $url");

      final res = await DioClient.dio.post(url);

      debugPrint(" START TASK RESPONSE => ${res.data}");
    } on DioException catch (e) {
      debugPrint(" START TASK ERROR => ${e.response?.data}");
      throw Exception(e.response?.data["error"] ?? "Failed to start task");
    }
  }

  Future<DeliveryTaskStartDetails> fetchStartedTaskDetails(int taskId) async {
    try {
      final url =
          "${ApiEndpoints.baseUrl}/task/$taskId/start-details/";

      debugPrint(" START DETAILS API => $url");

      final res = await DioClient.dio.get(url);

      debugPrint(" START DETAILS RESPONSE => ${res.data}");

      return DeliveryTaskStartDetails.fromJson(res.data);

    } on DioException catch (e) {
      debugPrint(" START DETAILS ERROR => ${e.response?.data}");
      throw Exception(e.response?.data["error"] ?? "Failed to load started task");
    }
  }

  Future<void> endDeliveryTask({
    required int taskId,
    required String notes,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "notes": notes,
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      debugPrint("📦 END TASK => $taskId | notes: $notes | image: ${image.path}");

      final res = await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/$taskId/end/",
        data: formData,
      );

      debugPrint("✅ END TASK RESPONSE => ${res.data}");

    } on DioException catch (e) {
      // 🔥 This prints full backend error
      debugPrint("❌ END TASK DIO ERROR");
      debugPrint("STATUS => ${e.response?.statusCode}");
      debugPrint("DATA   => ${e.response?.data}");
      debugPrint("MSG    => ${e.message}");

      throw Exception(
        e.response?.data?["error"] ??
            e.response?.data?["message"] ??
            "Failed to end task",
      );

    } catch (e) {
      // 🔴 Any other unexpected error
      debugPrint("❌ END TASK UNKNOWN ERROR => $e");
      throw Exception("Something went wrong while ending task");
    }
  }



}

class DeliveryTaskResponse {
  final List<DeliveryTaskModel> todayTasks;
  final List<DeliveryTaskModel> pendingTasks;
  final List<DeliveryTaskModel> completedTasks;

  DeliveryTaskResponse({
    required this.todayTasks,
    required this.pendingTasks,
    required this.completedTasks,
  });

  factory DeliveryTaskResponse.fromJson(Map<String, dynamic> json) {
    List<DeliveryTaskModel> parseList(String key) {
      final list = json[key] as List? ?? [];
      return list
          .map((e) => DeliveryTaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DeliveryTaskResponse(
      todayTasks: parseList("today_tasks"),
      pendingTasks: parseList("pending_tasks"),
      completedTasks: parseList("completed_tasks"),
    );
  }
}
