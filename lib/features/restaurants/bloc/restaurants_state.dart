import 'package:equatable/equatable.dart';

abstract class RestaurantsState extends Equatable {
  @override
  List<Object> get props => [];
}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsLoading extends RestaurantsState {}

class RestaurantsLoaded extends RestaurantsState {
  final List<dynamic> restaurants;
  RestaurantsLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantsError extends RestaurantsState {
  final String message;
  RestaurantsError(this.message);

  @override
  List<Object> get props => [message];
}
