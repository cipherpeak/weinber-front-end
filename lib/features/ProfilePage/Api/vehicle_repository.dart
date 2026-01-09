import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
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
}
