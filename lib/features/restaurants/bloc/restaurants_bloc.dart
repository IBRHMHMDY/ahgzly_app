import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/api_service.dart';

part 'restaurants_event.dart';
part 'restaurants_state.dart';

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final ApiService apiService;

  RestaurantsBloc(this.apiService) : super(RestaurantsInitial()) {
    on<FetchRestaurants>((event, emit) async {
      emit(RestaurantsLoading());
      try {
        final response = await apiService.send.get('/restaurants');
        emit(RestaurantsLoaded(response.data));
      } catch (e) {
        emit(RestaurantsError("فشل جلب البيانات: ${e.toString()}"));
      }
    });
  }
}
