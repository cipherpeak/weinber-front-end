import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';

class ApiService {
  static final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  static const _storage = FlutterSecureStorage();
  static bool _isRefreshing = false;
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
          // if (error.response?.statusCode == 401 && !_isRefreshing) {
            // _isRefreshing = true;
            // final success = await _refreshToken();
            // _isRefreshing = false;

            // if (success) {
            //   final newToken = await _storage.read(key: 'access_token');
            //   error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            //
            //   final retry = await _dio.fetch(error.requestOptions);
            //   return handler.resolve(retry);
            // }
          // }
          // return handler.next(error);
        },
      ),
    );
  }

  // static Future<bool> _refreshToken() async {
  //   final refreshToken = await _storage.read(key: 'refresh_token');
  //   if (refreshToken == null) return false;
  //
  //   try {
  //     final res = await _dio.post(ApiEndpoints.refresh, data: {'refresh_token': refreshToken});
  //     await _storage.write(key: 'access_token', value: res.data['access_token']);
  //     await _storage.write(key: 'refresh_token', value: res.data['refresh_token']);
  //     return true;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  Future<void> saveUserId(int id) async {
    if (_userId != id) {
      await _storage.write(key: 'userId', value: id.toString());
      _userId = id;
    }
  }

  Dio get client => _dio;

  int? get userId => _userId;
}
