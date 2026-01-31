import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';

class ApiService {
  static final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  static const _storage = FlutterSecureStorage();
  static int? _userId;

  ApiService._private();
  static final ApiService instance = ApiService._private();

  static Future<void> init() async {
    _userId = int.tryParse(await _storage.read(key: 'userId') ?? '');

    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
        },
      ),
    );
  }



  Future<void> saveUserId(int id) async {
    if (_userId != id) {
      await _storage.write(key: 'userId', value: id.toString());
      _userId = id;
    }
  }

  Dio get client => _dio;

  int? get userId => _userId;
}
