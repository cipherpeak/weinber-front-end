import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/delivery_task_details_model.dart';
import '../Model/delivery_task_model.dart';

class DeliveryTaskRepository {
  Future<DeliveryTaskResponse> fetchDeliveryTasks() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + "/task/delivery/",
      );

      return DeliveryTaskResponse.fromJson(res.data);

    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Failed to load delivery tasks");
    }
  }

  Future<DeliveryTaskDetails> fetchDeliveryTaskDetails(String id) async {
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
