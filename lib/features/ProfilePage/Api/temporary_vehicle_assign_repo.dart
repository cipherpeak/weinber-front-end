import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../../../../core/constants/api_endpoints.dart';

class VehicleRepository {

  Future<void> createTemporaryVehicle({
    required String vehicleNumber,
    required String vehicleModel,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required String location,
    String? note,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.createTemporaryVehicle,
        data: {
          "vehicle_number": vehicleNumber,
          "vehicle_model": vehicleModel,
          "start_date": startDate,
          "end_date": endDate,
          "start_time": startTime,
          "end_time": endTime,
          "location": location,
          "add_note": note,
        },
      );
    } on DioException catch (e) {
      debugPrint("❌ API ERROR => ${e.response?.statusCode}");
      debugPrint("❌ API DATA => ${e.response?.data}");
      rethrow;
    }
  }

}
