part of 'restaurants_bloc.dart';

abstract class RestaurantsState extends Equatable {
  @override
  List<Object> get props => [];
}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsLoading extends RestaurantsState {}

class RestaurantsLoaded extends RestaurantsState {
  final List<dynamic> restaurants;
  RestaurantsLoaded(this.restaurants);
}

class RestaurantsError extends RestaurantsState {
  final String message;
  RestaurantsError(this.message);
}
