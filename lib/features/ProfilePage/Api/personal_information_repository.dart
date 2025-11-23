
import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';

import '../Model/personal_information_response.dart';

class PersonalInformationRepository {
  Future<PersonalInfoResponse> fetchPersonalInfo() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.personalInformation
      );

      return PersonalInfoResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load personal information: $e");
    }
  }
}
