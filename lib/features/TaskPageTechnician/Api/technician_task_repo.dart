import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../../TaskPageOffice/Model/technician_task_details_model.dart';
import '../Model/technician_start_details_model.dart';
import '../Model/technician_task_model.dart';

class TechnicianTaskRepository {
  Future<List<TechnicianTaskModel>> fetchTechnicianTasks() async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/mechanic/",
      );

      final List list = res.data["tasks"];

      return list.map((e) => TechnicianTaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ?? "Failed to load technician tasks",
      );
    }
  }

  Future<TechnicianTaskDetails> fetchTechnicianTaskDetails(int id) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/mechanic/$id/",
      );

      return TechnicianTaskDetails.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load technician task details");
    }
  }

  // ▶ START TASK
  Future<void> startTechnicianTask(int id) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/mechanic/$id/start/",
      );
    } catch (e) {
      throw Exception("Failed to start task");
    }
  }

  // ▶ STARTED TASK DETAILS
  Future<TechnicianTaskStartDetails> fetchStartedTaskDetails(int id) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/mechanic/$id/start-details/",
      );

      return TechnicianTaskStartDetails.fromJson(res.data);
    } catch (e) {
      throw Exception("Failed to load started task");
    }
  }



  Future<void> createTechnicianTask({
    required String siteNumber,
    required String bayNumber,
    required String machineType,
    required String machineSerialNumber,
    required String jobDescription,
    required String sparePartDetails,
    required int partNumber,
    required String item,
    required int quantity,
  }) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/mechanic/create/",
        data: {
          "Site_number": siteNumber,
          "bay_number": bayNumber,
          "Machine_type": machineType,
          "Machine_serial_number": machineSerialNumber,
          "job_description": jobDescription,
          "spare_part_details": sparePartDetails,
          "part_number": partNumber,
          "item": item,
          "quantity": quantity,
        },
      );
    } catch (e) {
      throw Exception("Failed to create technician task");
    }
  }

  Future<void> endTechnicianTask({
    required int taskId,
    required String notes,
    required File image,
  }) async {
    try {
      final fileName = image.path.split('/').last;

      final formData = FormData.fromMap({
        "notes": notes,
        "image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/mechanic/$taskId/complete/",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      throw Exception("Failed to complete technician task");
    }
  }


}
