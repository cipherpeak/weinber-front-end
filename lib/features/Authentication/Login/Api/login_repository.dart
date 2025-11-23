import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../Model/login_response.dart';
import '../../../../core/constants/api_endpoints.dart';

class AuthRepository {
  Future<LoginResponse> login({
    required String employeeId,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.login}");

      // print("🔹 Sending login request to: $url");

      final response = await http
          .post(
        url,
        body: {
          "employeeId": employeeId,
          "password": password,
        },
      )
          .timeout(const Duration(seconds: 20));

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    }


    on SocketException catch (_) {
      print(" No Internet connection");
      throw Exception("No internet connection");
    }


    on TimeoutException catch (_) {
      print(" Request timed out");
      throw Exception("Request timed out");
    }


    on FormatException catch (e) {
      print(" Bad JSON Format: $e");
      throw Exception("Invalid response format from server");
    }


    catch (e) {
      print(" Unknown Error: $e");
      throw Exception("Something went wrong: $e");
    }
  }
}
