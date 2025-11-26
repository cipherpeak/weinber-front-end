import 'package:dio/dio.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../Model/employee_information_model.dart';

class EmployeeInformationRepository {
  Future<EmployeeInformationResponse> fetchEmployeeInformation() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.employeeInformation,
      );

      return EmployeeInformationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load employee information: $e");
    }
  }
}
