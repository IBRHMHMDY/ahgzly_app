import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;
  BookingSuccess(this.message);
}

class BookingError extends BookingState {
  final String error;
  BookingError(this.error);
}
