  // 10.0.2.2 هو رابط السيرفر المحلي من داخل محاكي أندرويد
  // static const String baseUrl = 'http://10.0.2.2:8000/api/admin/'; // Android Emulator
  // static const String baseUrl = 'http://192.168.1.10:8000/api/admin/'; // Physical Device or iOS
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio send = Dio();

  ApiService() {
    // 1. تحديد الإعدادات الأساسية
    send.options.baseUrl =
        'http://192.168.1.10:8000/api/'; // Physical Device [Android or iOS]
    send.options.connectTimeout = const Duration(seconds: 10);
    send.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 2. إضافة الـ Interceptor 
    send.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب التوكن المحفوظ من ذاكرة الهاتف
          final prefs = await SharedPreferences.getInstance();
          final String? token = prefs.getString('token');

          // إذا وجدنا توكن، نضيفه للهيدر الخاص بالطلب
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print("Sending request to: ${options.path}"); // للديجباج فقط
          return handler.next(options); // استكمال الطلب
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // هنا يمكنك إضافة كود لتوجيه المستخدم لصفحة Login إذا انتهت صلاحية التوكن
            print("Token expired or unauthorized");
          }
          return handler.next(e);
        },
      ),
    );
  }
}
