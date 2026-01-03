import 'package:dio/dio.dart';

class ApiService {
  // 10.0.2.2 هو رابط السيرفر المحلي من داخل محاكي أندرويد
  // static const String baseUrl = 'http://10.0.2.2:8000/api/admin/'; // Android Emulator
  static const String baseUrl = 'http://192.168.1.10:8000/api/admin/'; // Physical Device or iOS

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  Dio get send => _dio;
}
