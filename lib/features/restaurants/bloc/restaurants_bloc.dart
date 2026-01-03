import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api_service.dart';
import 'restaurants_event.dart';
import 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final ApiService apiService;

  RestaurantsBloc(this.apiService) : super(RestaurantsInitial()) {
    on<FetchRestaurants>((event, emit) async {
      emit(RestaurantsLoading());
      try {
        // نطلب البيانات من الرابط /restaurants
        final response = await apiService.send.get('restaurants');

        // نرسل حالة النجاح مع البيانات
        emit(RestaurantsLoaded(response.data));
      } catch (e) {
        emit(RestaurantsError("فشل في جلب البيانات: تأكد من تشغيل Laravel"));
      }
    });
  }
}
