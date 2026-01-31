import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';
import '../Model/dart_task_details_model.dart';
import '../Model/dax_start_task_details_model.dart';
import '../Model/dax_task_model.dart';

class DaxTaskRepository {
  Future<void> createDaxTask(Map<String, dynamic> payload) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/dax/create/",
        data: payload,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["error"] ??
              e.response?.data["message"] ??
              "Failed to create task",
        );
      } else {
        throw Exception("Network error. Please try again.");
      }
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  Future<DaxTaskDetails> fetchDaxTaskDetails(int id) async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/dax/$id/",
      );

      return DaxTaskDetails.fromJson(res.data);

    } on DioException catch (e) {
      final msg =
          e.response?.data["error"] ??
              e.response?.data["message"] ??
              "Failed to load task details";
      throw Exception(msg);
    }
  }

  Future<void> completeEntireTask(int taskId, String notes) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/dax/$taskId/complete/",
        data: {
          "final_notes": notes, // if backend expects this
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ??
            e.response?.data["message"] ??
            "Failed to complete task",
      );
    }
  }


  Future<void> completeService(int serviceId) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/dax/service-type/$serviceId/complete/",
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ??
            e.response?.data["message"] ??
            "Failed to update service",
      );
    }
  }


  Future<DaxStartDetails> fetchStartDetails(int id) async {
    final res = await DioClient.dio.get(
      "${ApiEndpoints.baseUrl}/task/dax/$id/start-details/",
    );

    return DaxStartDetails.fromJson(res.data);
  }


  Future<void> startDaxTask(int id) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}/task/dax/$id/start/",
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["error"] ??
            e.response?.data["message"] ??
            "Failed to start task",
      );
    }
  }



  Future<List<DaxTaskModel>> fetchDaxTasks() async {
    try {
      final res = await DioClient.dio.get(
        "${ApiEndpoints.baseUrl}/task/dax/",
      );

      final List data = res.data is List
          ? res.data
          : res.data["tasks"] ?? [];

      return data.map((e) => DaxTaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null) {
        final data = e.response!.data;

        if (data is Map) {
          errorMessage =
              data["error"] ??
                  data["message"] ??
                  data["detail"] ??
                  "Server error (${e.response!.statusCode})";
        } else {
          errorMessage = "Server error (${e.response!.statusCode})";
        }
      } else {
        errorMessage = "Network error. Please check your internet.";
      }
      throw Exception(errorMessage);
    } catch (e) {
      print("❌ UNKNOWN ERROR: $e");
      throw Exception("Unexpected error occurred");
    }
  }



}
