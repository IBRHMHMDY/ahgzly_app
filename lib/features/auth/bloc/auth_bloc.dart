import 'package:ahgzly_app/core/api_service.dart';
import 'package:ahgzly_app/features/auth/bloc/auth_event.dart';
import 'package:ahgzly_app/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.send.post(
          'login',
          data: {'email': event.email, 'password': event.password},
        );

        String token = response.data['access_token'];
        // حفظ التوكن في الجهاز
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        emit(AuthAuthenticated(token));
      } catch (e) {
        emit(AuthError("فشل تسجيل الدخول، تحقق من البيانات"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        // 1. إخبار السيرفر بتسجيل الخروج (إبطال التوكن)
        await apiService.send.post('/logout');
      } catch (e) {
        // حتى لو فشل طلب السيرفر (مثلاً لا يوجد إنترنت)، سنكمل الحذف من الجهاز
      } finally {
        // 2. حذف التوكن من ذاكرة الهاتف
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        // 3. العودة للحالة الابتدائية
        emit(AuthInitial());
      }
    });
  }
}
