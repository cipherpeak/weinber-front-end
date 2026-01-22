import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';

import '../Model/personal_information_response.dart';

class PersonalInformationRepository {
  Future<PersonalInfoResponse> fetchPersonalInfo() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.personalInformation,
      );

      return PersonalInfoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load personal information: $e");
    }
  }

  /// ✏️ UPDATE PERSONAL INFO (MULTIPART)
  Future<void> updatePersonalInfo({
    File? profilePic,
    required String mobNumber,
    required String email,
    required String address,
  }) async {
    try {
      final formData = FormData.fromMap({
        "mob_number": mobNumber,
        "email": email,
        "employee_address": address,
        if (profilePic != null)
          "profile_pic": await MultipartFile.fromFile(profilePic.path),
      });

      await DioClient.dio.post(
        ApiEndpoints.personalInformationEdit,
        data: formData,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["error"] ?? "Update failed");
    }
  }
}
