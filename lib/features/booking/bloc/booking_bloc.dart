import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../../core/api_service.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService apiService;
 
  BookingBloc(this.apiService) : super(BookingInitial()) {
    on<SubmitBooking>((event, emit) async {
      emit(BookingLoading());
  // افترضنا أن لديك هذه المتغيرات من الـ DatePicker و TimePicker
      DateTime selectedDate = DateTime.now(); // التاريخ المختصر
      TimeOfDay selectedTime = TimeOfDay.now(); // الوقت المختار

      // 1. تحويل الوقت المختصر إلى كائن DateTime كامل لسهولة التنسيق
      final DateTime fullDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      String formattedForLaravel = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(fullDateTime);

      try {
        final response = await apiService.send.post(
          'bookings',
          data: {
            'user_id': event.userId,
            'restaurant_id': event.restaurantId,
            'table_type_id': event.tableTypeId,
            'booking_date': formattedForLaravel,
            'guests_count': event.guestsCount,
          },
        );
        emit(
          BookingSuccess("تم الحجز بنجاح! رقم الحجز: ${response.data['id']}"),
        );
      } catch (e) {
        if (e is DioException) {
          print(
            "Laravel Error: ${e.response?.data}",
          ); // هذا السطر سيخبرنا بالسبب الدقيق
        }
        emit(BookingError("عذراً، هذه الطاولة غير متاحة في هذا الوقت."));
      }
    });
  }
}
