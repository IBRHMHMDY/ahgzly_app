import 'package:equatable/equatable.dart';

abstract class MyBookingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMyBookings extends MyBookingsEvent {}

class CancelBookingRequested extends MyBookingsEvent {
  final int bookingId;
  CancelBookingRequested(this.bookingId);
}
