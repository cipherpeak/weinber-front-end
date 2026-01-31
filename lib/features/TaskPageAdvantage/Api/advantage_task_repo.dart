import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/advantage_task_details_model.dart';
import '../Model/advantage_task_model.dart';
import '../Model/advantage_task_start_details_model.dart';

class AdvantageTaskRepository {
  Future<void> createAdvantageTask({
    required String detailingSite,
    required String plu,
    required String category,
    required String subService,
    required String chassisNumber,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        "detailing_site": detailingSite,
        "plu": plu,
        "category": category,
        "sub_service": subService,
        "chassis_number": chassisNumber,
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/advantage/create/",
        data: formData,
      );
    } catch (e) {
      throw Exception("Failed to create task");
    }
  }

  // ▶ START TASK
  Future<void> startAdvantageTask(int taskId) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/advantage/$taskId/start/",
      );
    } catch (e) {
      throw Exception("Failed to start advantage task");
    }
  }

  Future<void> completeAdvantageTask(int taskId) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/advantage/$taskId/complete/",
      );
    } catch (e) {
      throw Exception("Failed to complete task");
    }
  }

  // ▶ FETCH STARTED TASK DETAILS
  Future<AdvantageTaskStartDetails> fetchAdvantageStartedTask(int taskId) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/advantage/$taskId/start-details/",
      );

      return AdvantageTaskStartDetails.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load started task details");
    }
  }

  Future<List<AdvantageTaskModel>> fetchAdvantageTasks() async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/advantage/",
      );

      final List list = res.data["tasks"];

      return list
          .map((e) => AdvantageTaskModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load advantage tasks");
    }
  }

  Future<AdvantageTaskDetails> fetchAdvantageTaskDetails(int taskId) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/advantage/$taskId/",
      );

      return AdvantageTaskDetails.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load advantage task details");
    }
  }
}
