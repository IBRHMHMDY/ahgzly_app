import 'package:equatable/equatable.dart';

abstract class MyBookingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<dynamic> bookings;
  MyBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class MyBookingsError extends MyBookingsState {
  final String message;
  MyBookingsError(this.message);
}
