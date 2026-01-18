import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/dio_interceptor.dart';
import '../Model/notes_detail_model.dart';
import '../Model/notes_response_model.dart';

class NotesRepository {

  /// 📥 GET ALL NOTES
  Future<NotesResponse> fetchNotes() async {
    try {
      final res = await DioClient.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.notes,
      );
      debugPrint("NOTES RAW => ${res.data}");

      return NotesResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to load notes");
    }
  }

  /// ➕ CREATE NOTE
  Future<void> createNote({
    required String title,
    required String description,
    required String date,
  }) async {
    try {
      await DioClient.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.notes,
        data: {
          "title": title,
          "description": description,
          "date": date,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to create note");
    }
  }

  /// ✏️ EDIT NOTE
  Future<void> editNote({
    required int id,
    required String title,
    required String description,
    required String date,
  }) async {
    try {
      await DioClient.dio.put(
        "${ApiEndpoints.baseUrl}api/office/notes/$id/edit/",
        data: {
          "id": id,
          "title": title,
          "description": description,
          "date": date,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to update note");
    }
  }

  /// 🗑 DELETE NOTE
  Future<void> deleteNote(int id) async {
    try {
      await DioClient.dio.delete(
        "${ApiEndpoints.baseUrl}api/office/notes/$id/delete/",
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to delete note");
    }
  }

  /// ✅ MARK DONE
  Future<void> markDone(int id) async {
    try {
      await DioClient.dio.post(
        "${ApiEndpoints.baseUrl}api/office/notes/$id/mark-done/",
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to mark done");
    }
  }

  /// 📄 NOTE DETAILS
  Future<NoteDetail> fetchNoteDetails(int id) async {
    try {
      final res = await DioClient.dio.get(
        "https://www.cipher-peak.com/api/office/notes/$id/",
      );

      debugPrint("NOTE DETAILS RAW => ${res.data}");

      return NoteDetail.fromJson(res.data["data"]);
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to load note");
    }
  }

}
