import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';

import '../Model/profile_api_model.dart';

class ProfileRepository {

  Future<ProfileResponse> fetchProfile() async {
    try {
      final response = await DioClient.dio.get(ApiEndpoints.profile);

      return ProfileResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load profile: $e");
    }
  }
}
