import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/visa_document_response_model.dart';

class VisaDocumentRepository {

  Future<VisaDocumentResponse> fetchVisaData() async {
    final response = await DioClient.dio.get(ApiEndpoints.visaDocument);
    return VisaDocumentResponse.fromJson(response.data);
  }

  // ✅ UPLOAD DOCUMENT API
  Future<void> uploadDocument({
    required String documentType,
    required File file,
  }) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        "document_type": documentType,
        "document_file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      await DioClient.dio.post(
        ApiEndpoints.visaDocumentUpdate,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }
}
