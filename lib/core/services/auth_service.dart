import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';
import 'api_service.dart';

class AuthService {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final _storage = const FlutterSecureStorage();

  AuthService._private();

  static final AuthService instance = AuthService._private();

  Future<bool> login({required String userId, required String password}) async {
    try {
      final res = await _dio.post(ApiEndpoints.login, data: {'userId': userId, 'password': password});
      await _storeTokens(res.data);
      return true;
    } catch (e, st) {
      log('login error: ${e.toString()}');
      log('login Stacktrace: ${st.toString()}');
      return false;
    }
  }


  Future<bool> logout() async {
    try {
      await ApiService.instance.client.delete(ApiEndpoints.logout);
      await _deleteLocalDatabases();
      return true;
    } on DioException catch (e) {
      log(e.response?.data?.toString() ?? 'null');
      return false;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> _storeTokens(Map<String, dynamic> data) async {
    await _storage.write(key: 'access_token', value: data['access_token']);
    // await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    await _storage.write(key: 'user_type', value: data['type']);

    ApiService.init();
  }

  Future<bool> isLoggedIn() async {
    return false;
    return (await _storage.read(key: 'access_token')) != null;
  }


  Future<void> _deleteLocalDatabases() async {
    await _storage.deleteAll();
  }
}
