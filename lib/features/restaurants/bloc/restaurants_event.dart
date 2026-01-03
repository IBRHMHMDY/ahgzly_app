part of 'restaurants_bloc.dart';


abstract class RestaurantsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRestaurants extends RestaurantsEvent {}
