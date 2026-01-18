import 'dart:io';
import 'package:dio/dio.dart';
import 'package:weinber/core/constants/api_endpoints.dart';
import '../../../../core/constants/dio_interceptor.dart';

class LeaveApplyRepository {
  Future<void> applyLeave({
    required String category,
    required String startDate,
    required String endDate,
    required String totalDays,
    required String reason,
    required String passportFrom,
    required String passportTo,
    required String address,
    File? attachment, // ✅ optional
    required File signature,
  }) async {
    try {
      final Map<String, dynamic> map = {
        "category": category,
        "start_date": startDate,
        "end_date": endDate,
        "total_days": totalDays,
        "reason": reason,
        "passport_required_from": passportFrom,
        "passport_required_to": passportTo,
        "address_during_leave": address,
        "signature": await MultipartFile.fromFile(signature.path),
      };

      // ✅ only add attachment if selected
      if (attachment != null) {
        map["attachment"] = await MultipartFile.fromFile(attachment.path);
      }

      final formData = FormData.fromMap(map);

      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.leaveApply,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

    } catch (e, st) {
      print("❌ LEAVE APPLY ERROR: $e");
      print("🧵 STACK TRACE: $st");
      rethrow;
    }
  }
}
