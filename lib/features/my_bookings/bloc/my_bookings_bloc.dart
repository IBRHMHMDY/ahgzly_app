import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_bookings_event.dart';
import 'my_bookings_state.dart';
import '../../../core/api_service.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  final ApiService apiService;

  MyBookingsBloc(this.apiService) : super(MyBookingsInitial()) {
    on<FetchMyBookings>((event, emit) async {
      emit(MyBookingsLoading());
      try {
        // نطلب الحجوزات من Laravel (تأكد من وجود هذا المسار في api.php)
        final response = await apiService.send.get('my-bookings');
        emit(MyBookingsLoaded(response.data));
      } catch (e) {
        emit(MyBookingsError("فشل في تحميل حجوزاتك"));
      }
    });

    on<CancelBookingRequested>((event, emit) async {
      try {
        await apiService.send.post('bookings/${event.bookingId}/cancel');
        // بعد الإلغاء الناجح، نطلب القائمة المحدثة فوراً
        add(FetchMyBookings());
      } catch (e) {
        emit(MyBookingsError("فشل في إلغاء الحجز: ${e.toString()}"));
      }
    });
  }

}
