import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/reportedVehicleIssueModel.dart';
import '../Model/vehicle_details_response.dart';


class VehicleRepository {
  Future<VehicleDetailsResponse> fetchVehicleDetails() async {
    try {
      final response = await DioClient.dio.get(ApiEndpoints.vehicleDetails);
      return VehicleDetailsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load vehicle details: $e");
    }
  }

  Future<List<ReportedVehicleIssue>> fetchReportedVehicleIssues() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl+ApiEndpoints.reportedVehicleDetails,
      );

      debugPrint("✅ VEHICLE REPORT RAW => ${res.data}");

      final list = res.data["issues"] as List? ?? [];

      return list.map((e) => ReportedVehicleIssue.fromJson(e)).toList();

    } on DioException catch (e) {
      debugPrint("❌ VEHICLE REPORT ERROR => ${e.response?.data}");
      throw Exception("Failed to load vehicle reports");
    }
  }

  Future<void> reportVehicleIssue({
    required String title,
    required String reportedDate,
    required String status,
    required String description,
    File? image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "reported_date": reportedDate,
        "status": status,
        "description": description,
        if (image != null)
          "vehicle_issue_image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final res = await DioClient.dio.post(
        ApiEndpoints.baseUrl+ApiEndpoints.reportVehicleIssue,
        data: formData,
      );

      debugPrint("✅ REPORT ISSUE RESPONSE => ${res.data}");

    } on DioException catch (e) {
      debugPrint("❌ REPORT ISSUE ERROR => ${e.response?.data}");
      throw Exception(e.response?.data["message"] ?? "Failed to report issue");
    }
  }


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
