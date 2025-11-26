import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/visa_document_response_model.dart';



class VisaDocumentRepository {
  Future<VisaDocumentResponse> fetchVisaData() async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.visaDocument,
      );

      return VisaDocumentResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to load visa & document details: $e");
    }
  }
}
