import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';

class ReportIssueRepository {
  Future<void> reportIssue({
    required String date,
    required String time,
    required String location,
    required String issueCategory,
    required String description,
    File? mediaFile,
  }) async {
    try {
      final Map<String, dynamic> map = {
        "date": date,
        "time": time,
        "location": location,
        "issue_category": issueCategory,
        "description": description,
      };


      if (mediaFile != null) {
        map["media_file"] = await MultipartFile.fromFile(
          mediaFile.path,
          filename: mediaFile.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(map);

      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.reportIssue,
        data: formData,
      );
    } catch (e, st) {
      debugPrint("❌ REPORT ISSUE ERROR => $e");
      debugPrint("🧵 STACK TRACE => $st");
      rethrow;
    }
  }
}
